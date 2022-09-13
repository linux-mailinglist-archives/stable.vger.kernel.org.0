Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468035B7322
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiIMOzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiIMOyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:54:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497AC72EC1;
        Tue, 13 Sep 2022 07:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A922F61414;
        Tue, 13 Sep 2022 14:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BDDC4347C;
        Tue, 13 Sep 2022 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078713;
        bh=OYGIZzUf3tsRIRrsrVbwFTBCi+ghl60JeGakohJsvs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NboPBjg/oxeA9uv32J9a9SbB8IqIYVOV3YFTjY+5ADNLrZaHVmFo5fRvrytFuOey0
         NUAWTqIC5JOORP64Ok7I4IRs/LVAuwRx0mQ9vaooVYYK+T1xUnd+qd0W0rky2idgFB
         eQVQpSQsGPMkbccZzPrvIsroz7Mt+qlFxhZXHan0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Masney <bmasney@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/121] regulator: core: Clean up on enable failure
Date:   Tue, 13 Sep 2022 16:04:05 +0200
Message-Id: <20220913140359.678790053@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit c32f1ebfd26bece77141257864ed7b4720da1557 ]

If regulator_enable() fails, enable_count is incremented still.
A consumer, assuming no matching regulator_disable() is necessary on
failure, will then get this error message upon regulator_put()
since enable_count is non-zero:

    [    1.277418] WARNING: CPU: 3 PID: 1 at drivers/regulator/core.c:2304 _regulator_put.part.0+0x168/0x170

The consumer could try to fix this in their driver by cleaning up on
error from regulator_enable() (i.e. call regulator_disable()), but that
results in the following since regulator_enable() failed and didn't
increment user_count:

    [    1.258112] unbalanced disables for vreg_l17c
    [    1.262606] WARNING: CPU: 4 PID: 1 at drivers/regulator/core.c:2899 _regulator_disable+0xd4/0x190

Fix this by decrementing enable_count upon failure to enable.

With this in place, just the reason for failure to enable is printed
as expected and developers can focus on the root cause of their issue
instead of thinking their usage of the regulator consumer api is
incorrect. For example, in my case:

    [    1.240426] vreg_l17c: invalid input voltage found

Fixes: 5451781dadf8 ("regulator: core: Only count load for enabled consumers")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20220819194336.382740-1-ahalaney@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f4f28e5888b1c..43613db7af754 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2688,13 +2688,18 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
  */
 static int _regulator_handle_consumer_enable(struct regulator *regulator)
 {
+	int ret;
 	struct regulator_dev *rdev = regulator->rdev;
 
 	lockdep_assert_held_once(&rdev->mutex.base);
 
 	regulator->enable_count++;
-	if (regulator->uA_load && regulator->enable_count == 1)
-		return drms_uA_update(rdev);
+	if (regulator->uA_load && regulator->enable_count == 1) {
+		ret = drms_uA_update(rdev);
+		if (ret)
+			regulator->enable_count--;
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1



