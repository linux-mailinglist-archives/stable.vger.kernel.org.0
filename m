Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78575688F4A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 07:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBCGBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 01:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjBCGBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 01:01:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894FD6FD08
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 22:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CA90B827B1
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 06:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878C4C4339B;
        Fri,  3 Feb 2023 06:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675404103;
        bh=SniJoLJ2VQlk4yGR7JbvL5iVsw6HI8zDkYM7vWypbtc=;
        h=Subject:To:From:Date:From;
        b=Ajw4OHKaWN+JV9nNUZxknZo/ST0JVdZr0/o9jlr3qCs31hU2zMIKBUGnWn1VpVO88
         fBdlxNwBifLgDBakzkX+NMg1CSRe0IdAWltMv9jpb/NPZ/6JMWJZQQ0VylVdlxXZ+A
         NJxnc8keE9xnYvRs9JAF8Pcx/RHzZX/JAQDSTRi4=
Subject: patch "bus: mhi: ep: Save channel state locally during suspend and resume" added to char-misc-next
To:     manivannan.sadhasivam@linaro.org, quic_jhugo@quicinc.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Feb 2023 07:01:20 +0100
Message-ID: <167540408077194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


