Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65F16C56FC
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjCVULR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjCVUKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BFD7DF90;
        Wed, 22 Mar 2023 13:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550D4B81B97;
        Wed, 22 Mar 2023 20:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6923EC433EF;
        Wed, 22 Mar 2023 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515330;
        bh=ADgOMX62IrR82V6veE+B2pFtCQ5XlrDFYKj5HOS6t58=;
        h=From:To:Cc:Subject:Date:From;
        b=aY3aBFczkCcb9UVy2ASFnv3mGpXwsVfB6nc2UmM0m31rV5VcxBnFJGctoP3k3MhkJ
         f4kHCtqVEAiRdBCKNPuosauxDHw1auPQnoi8cUI42QUn+meJaPb2gKLPWxf9G8MLZd
         TprogqtX1z9ONDzTWPxCb/eU65tFCRDQ7L0LFNe/XIJtfCbpcboZx9oItBv9WWlxC0
         AFV5X5yVBsAlj++M+Q2OCbdjTfEz+8wy//I+G58h7ww5KF7gYGxUhy+5m+Tca7yHpM
         ZoewSIpBt4ZH518lrBPOSHdALbCi0eFU7pn5Vrib+ZkEo3wJjktsWt73GEdineMdn8
         t8sVimH1f+PGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, Dan Carpenter <error27@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/12] md: avoid signed overflow in slot_store()
Date:   Wed, 22 Mar 2023 16:01:55 -0400
Message-Id: <20230322200207.1997367-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index c0b34637bd667..1553c2495841b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3207,6 +3207,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
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

