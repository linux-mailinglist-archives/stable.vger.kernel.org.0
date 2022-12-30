Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501D26584AD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiL1RAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiL1Q7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:59:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C681EACB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2608B8188C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5BCC433D2;
        Wed, 28 Dec 2022 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246503;
        bh=/yXmksJOT4HkWi9od/IsfhSh/Se23sgAw0aKE2I9pBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sM3qh18qjX5KRx/0kCP7WGh+/1BlinZS8GgD2u94sqJyKMGZ1SFplnuTWqgFmBAfu
         zE9Vvqsb51VablhyfjzrxVl6688ta/Duls2Z64es3yckj+NzTzLmPu+HMrx0mG8Ah6
         AYkHoaCvAjkjormauhxsIaKbWUVxaxn3eRSa5vmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rui Zhang <zr.zhang@vivo.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1033/1146] regulator: core: fix use_count leakage when handling boot-on
Date:   Wed, 28 Dec 2022 15:42:52 +0100
Message-Id: <20221228144358.415418819@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Zhang <zr.zhang@vivo.com>

[ Upstream commit 0591b14ce0398125439c759f889647369aa616a0 ]

I found a use_count leakage towards supply regulator of rdev with
boot-on option.

┌───────────────────┐           ┌───────────────────┐
│  regulator_dev A  │           │  regulator_dev B  │
│     (boot-on)     │           │     (boot-on)     │
│    use_count=0    │◀──supply──│    use_count=1    │
│                   │           │                   │
└───────────────────┘           └───────────────────┘

In case of rdev(A) configured with `regulator-boot-on', the use_count
of supplying regulator(B) will increment inside
regulator_enable(rdev->supply).

Thus, B will acts like always-on, and further balanced
regulator_enable/disable cannot actually disable it anymore.

However, B was also configured with `regulator-boot-on', we wish it
could be disabled afterwards.

Signed-off-by: Rui Zhang <zr.zhang@vivo.com>
Link: https://lore.kernel.org/r/20221201033806.2567812-1-zr.zhang@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d65721498349..15677f5dcd99 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1596,7 +1596,13 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		if (rdev->supply_name && !rdev->supply)
 			return -EPROBE_DEFER;
 
-		if (rdev->supply) {
+		/* If supplying regulator has already been enabled,
+		 * it's not intended to have use_count increment
+		 * when rdev is only boot-on.
+		 */
+		if (rdev->supply &&
+		    (rdev->constraints->always_on ||
+		     !regulator_is_enabled(rdev->supply))) {
 			ret = regulator_enable(rdev->supply);
 			if (ret < 0) {
 				_regulator_put(rdev->supply);
-- 
2.35.1



