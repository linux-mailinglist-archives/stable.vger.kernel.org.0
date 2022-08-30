Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E245A6A19
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiH3R0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiH3RZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:25:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EF1C1644;
        Tue, 30 Aug 2022 10:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 321ACB81D12;
        Tue, 30 Aug 2022 17:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F64CC433C1;
        Tue, 30 Aug 2022 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880169;
        bh=L+kb1PjlO2zZUHIOB4XWHokuhAxTc5I1jpYA5piofE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJsFmY1CufURLN/8BSKxeYADOqrOu7iTS+nb5vahZJtnexa8hFfJ7/ga+USEKrLxQ
         Zi+0E7u8wPP9WJHIzcb6ArWiJvj48Cgli8LDP32SaRAinJAJF6OmZzKCVBPVx/lD/k
         5RkTpVrlpEEJmlBviO5ZHg+0mzBIZ8TlXfySS2Fo7aHPT53o/KLLJpa0cXcUvF+nGq
         5e/D5DTERVjzSKKO8zqcrjhJRxOJfLxQq2mR1BAmjlZN3qZzjj047ehjfMifvjXUi5
         RLG+qKHchAu6GnKJ5KIAT4CBVam/k5ES/wrTLsr66joYajefclirPsj++MpdKt4avc
         Uiz3PwLrzi0NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/23] md: Flush workqueue md_rdev_misc_wq in md_alloc()
Date:   Tue, 30 Aug 2022 13:21:36 -0400
Message-Id: <20220830172141.581086-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172141.581086-1-sashal@kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: David Sloan <david.sloan@eideticom.com>

[ Upstream commit 5e8daf906f890560df430d30617c692a794acb73 ]

A race condition still exists when removing and re-creating md devices
in test cases. However, it is only seen on some setups.

The race condition was tracked down to a reference still being held
to the kobject by the rdev in the md_rdev_misc_wq which will be released
in rdev_delayed_delete().

md_alloc() waits for previous deletions by waiting on the md_misc_wq,
but the md_rdev_misc_wq may still be holding a reference to a recently
removed device.

To fix this, also flush the md_rdev_misc_wq in md_alloc().

Signed-off-by: David Sloan <david.sloan@eideticom.com>
[logang@deltatee.com: rewrote commit message]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 33946adb0d6f6..17100b39ff14a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5651,6 +5651,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_rdev_misc_wq);
 
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
-- 
2.35.1

