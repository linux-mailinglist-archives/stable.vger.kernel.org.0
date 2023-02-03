Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD9688F3F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 07:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBCGAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 01:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjBCGAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 01:00:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0BF6FD2B
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 22:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7F9861D5C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 06:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6F4C433D2;
        Fri,  3 Feb 2023 05:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675404000;
        bh=MUX11QXcdtryiPh9YYdWL0LEKfpJ+MB21o4iwYhwm5o=;
        h=Subject:To:From:Date:From;
        b=nyVXIOjN+Te4HJwfBJ39b2UmL844WsCLdS5yYKyuXZR0ldpvQgWgjZq/Ax9zJsgXs
         mlKY8tNU9eHo7260m896UAW17FokM3U7v712geXgPeXLNZFHFH6hQlpY8+AliE8vRJ
         miECfaiEm8CM20G7gnSqO6ow/eXBRaT2ymps2fS8=
Subject: patch "bus: mhi: ep: Save channel state locally during suspend and resume" added to char-misc-testing
To:     manivannan.sadhasivam@linaro.org, quic_jhugo@quicinc.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Feb 2023 06:59:38 +0100
Message-ID: <1675403978146131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    bus: mhi: ep: Save channel state locally during suspend and resume

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 8a1c24bb908f9ecbc4be0fea014df67d43161551 Mon Sep 17 00:00:00 2001
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Wed, 28 Dec 2022 21:47:04 +0530
Subject: bus: mhi: ep: Save channel state locally during suspend and resume

During suspend and resume, the channel state needs to be saved locally.
Otherwise, the endpoint may access the channels while they were being
suspended and causing access violations.

Fix it by saving the channel state locally during suspend and resume.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: e4b7b5f0f30a ("bus: mhi: ep: Add support for suspending and resuming channels")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com)
Link: https://lore.kernel.org/r/20221228161704.255268-7-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/ep/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 2362fcc8b32c..bcaaba97ef63 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1122,6 +1122,7 @@ void mhi_ep_suspend_channels(struct mhi_ep_cntrl *mhi_cntrl)
 
 		dev_dbg(&mhi_chan->mhi_dev->dev, "Suspending channel\n");
 		/* Set channel state to SUSPENDED */
+		mhi_chan->state = MHI_CH_STATE_SUSPENDED;
 		tmp &= ~CHAN_CTX_CHSTATE_MASK;
 		tmp |= FIELD_PREP(CHAN_CTX_CHSTATE_MASK, MHI_CH_STATE_SUSPENDED);
 		mhi_cntrl->ch_ctx_cache[i].chcfg = cpu_to_le32(tmp);
@@ -1151,6 +1152,7 @@ void mhi_ep_resume_channels(struct mhi_ep_cntrl *mhi_cntrl)
 
 		dev_dbg(&mhi_chan->mhi_dev->dev, "Resuming channel\n");
 		/* Set channel state to RUNNING */
+		mhi_chan->state = MHI_CH_STATE_RUNNING;
 		tmp &= ~CHAN_CTX_CHSTATE_MASK;
 		tmp |= FIELD_PREP(CHAN_CTX_CHSTATE_MASK, MHI_CH_STATE_RUNNING);
 		mhi_cntrl->ch_ctx_cache[i].chcfg = cpu_to_le32(tmp);
-- 
2.39.1


