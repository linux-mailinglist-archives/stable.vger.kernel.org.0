Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052956C571D
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjCVUNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjCVUMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:12:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F996C699;
        Wed, 22 Mar 2023 13:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF9AE622CD;
        Wed, 22 Mar 2023 20:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF60C4339B;
        Wed, 22 Mar 2023 20:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515392;
        bh=NxzOtRQu6KigYzzhwtqdp249Roma4xVFBm/yW7xDUEc=;
        h=From:To:Cc:Subject:Date:From;
        b=oGI8SywsJU30r5QhG2wnacLd5vOhYGV/2IBSymTv2IQJPpgu7fYdXnGPkzf4YT1LB
         14EFG7ET5/YIOKYlsBS09CeR2ob+LlMHGkSONRyB5nUDJEUwRqUrEMfFbAt2MzFPxJ
         rlEmdSSB6vwZG0xdvhDXad4KQYsqiJ6JUxNoaXXnqTntjPL/tE6G0x8f7aAkqVKwFB
         S5S0zbIW97rMhhPWWaoL1eoCbMrfvqoAQFR9tvOptKn0UysVK+XqwkBUeRq/0ekzkp
         h7t9Cvpmuqc5x2xw6jwiVdFxZBJSzvSe2W1ZqjtJSCBl298zCoxCyuAdZIMaBcftKk
         MfnSRZCRSqeuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, Dan Carpenter <error27@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/9] md: avoid signed overflow in slot_store()
Date:   Wed, 22 Mar 2023 16:03:01 -0400
Message-Id: <20230322200309.1997651-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3bc57292278a0b6ac4656cad94c14f2453344b57 ]

slot_store() uses kstrtouint() to get a slot number, but stores the
result in an "int" variable (by casting a pointer).
This can result in a negative slot number if the unsigned int value is
very large.

A negative number means that the slot is empty, but setting a negative
slot number this way will not remove the device from the array.  I don't
think this is a serious problem, but it could cause confusion and it is
best to fix it.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 89d4dcc5253e5..f8c111b369928 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2991,6 +2991,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
-- 
2.39.2

