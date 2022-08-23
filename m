Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6325759D5C2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbiHWI1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243412AbiHWIY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBDF5142D;
        Tue, 23 Aug 2022 01:13:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0AABB81C26;
        Tue, 23 Aug 2022 08:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ECDC433D6;
        Tue, 23 Aug 2022 08:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242385;
        bh=/xqVVv9eJQPMGS9O/t5wJKYPFNFQbguJKEdKTDljefE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD46+Kc/7jveCdOcF0uD+2T5aGP4xQvQnSDj9uLH7/I8pmMQK3NECAdeAhLcEHcgd
         PcQnsNGlGKcyyhqgAwf8YxIZAZe+sOC+yyLcPfnmOKS6Pb28b+mSKVPCkEdtV5Lcl+
         OOq+r7JULsvEGz1v0FDnb5NwTyPUVOsTE4Byrpas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 107/365] Input: iqs7222 - acknowledge reset before writing registers
Date:   Tue, 23 Aug 2022 10:00:08 +0200
Message-Id: <20220823080122.666363089@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

commit 2e70ef525b7309287b2d4dd24e7c9c038a006328 upstream.

If the device suffers a spurious reset while reacting to a previous
spurious reset, the second reset interrupt is preempted because the
ACK_RESET bit is written last.

To solve this problem, write the ACK_RESET bit prior to writing any
other registers. This ensures that any registers written before the
second spurious reset will be rewritten.

Last but not least, the order in which the ACK_RESET bit is written
relative to the second filter beta register is important for select
variants of silicon. Enforce the correct order so as to not clobber
the system status register.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-5-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index c46d3c8f0230..aa46f2cd4d34 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -94,11 +94,11 @@ enum iqs7222_reg_key_id {
 
 enum iqs7222_reg_grp_id {
 	IQS7222_REG_GRP_STAT,
+	IQS7222_REG_GRP_FILT,
 	IQS7222_REG_GRP_CYCLE,
 	IQS7222_REG_GRP_GLBL,
 	IQS7222_REG_GRP_BTN,
 	IQS7222_REG_GRP_CHAN,
-	IQS7222_REG_GRP_FILT,
 	IQS7222_REG_GRP_SLDR,
 	IQS7222_REG_GRP_GPIO,
 	IQS7222_REG_GRP_SYS,
@@ -1348,6 +1348,34 @@ static int iqs7222_dev_init(struct iqs7222_private *iqs7222, int dir)
 	int comms_offset = dev_desc->comms_offset;
 	int error, i, j, k;
 
+	/*
+	 * Acknowledge reset before writing any registers in case the device
+	 * suffers a spurious reset during initialization. Because this step
+	 * may change the reserved fields of the second filter beta register,
+	 * its cache must be updated.
+	 *
+	 * Writing the second filter beta register, in turn, may clobber the
+	 * system status register. As such, the filter beta register pair is
+	 * written first to protect against this hazard.
+	 */
+	if (dir == WRITE) {
+		u16 reg = dev_desc->reg_grps[IQS7222_REG_GRP_FILT].base + 1;
+		u16 filt_setup;
+
+		error = iqs7222_write_word(iqs7222, IQS7222_SYS_SETUP,
+					   iqs7222->sys_setup[0] |
+					   IQS7222_SYS_SETUP_ACK_RESET);
+		if (error)
+			return error;
+
+		error = iqs7222_read_word(iqs7222, reg, &filt_setup);
+		if (error)
+			return error;
+
+		iqs7222->filt_setup[1] &= GENMASK(7, 0);
+		iqs7222->filt_setup[1] |= (filt_setup & ~GENMASK(7, 0));
+	}
+
 	/*
 	 * Take advantage of the stop-bit disable function, if available, to
 	 * save the trouble of having to reopen a communication window after
@@ -2254,8 +2282,6 @@ static int iqs7222_parse_all(struct iqs7222_private *iqs7222)
 			return error;
 	}
 
-	sys_setup[0] |= IQS7222_SYS_SETUP_ACK_RESET;
-
 	return iqs7222_parse_props(iqs7222, NULL, 0, IQS7222_REG_GRP_SYS,
 				   IQS7222_REG_KEY_NONE);
 }
-- 
2.37.2



