Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D00497211
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiAWOYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:24:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37490 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWOYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:24:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61DF660C97
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B1BC340E2;
        Sun, 23 Jan 2022 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947889;
        bh=cYpWC+6yZvyY+BiPGScrCoo5S8GwOEMgEoo2rqm8Apc=;
        h=Subject:To:Cc:From:Date:From;
        b=0NKviDI7SOHNXSTqXgax3oQcILf7TUgRa0kJTk5dJN7oimx0o6hkdHVUnTLjDXL9Y
         TYwYIJf9AbdsIf+nPxyFy6F+BTrzxry77CL7bfqlN+TDxJ07CzmTyOtBr6CPbUe9ys
         Jxnk7xyNDqeu0y3H7JkWGonJuRfmlMD1An0EZqHI=
Subject: FAILED: patch "[PATCH] bus: mhi: core: Fix reading wake_capable channel" failed to apply to 5.10-stable tree
To:     quic_bbhatt@quicinc.com, gregkh@linuxfoundation.org,
        mani@kernel.org, manivannan.sadhasivam@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:24:47 +0100
Message-ID: <1642947887104196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42c4668f7efe1485dfc382517b412c0c6ab102b8 Mon Sep 17 00:00:00 2001
From: Bhaumik Bhatt <quic_bbhatt@quicinc.com>
Date: Thu, 16 Dec 2021 13:42:23 +0530
Subject: [PATCH] bus: mhi: core: Fix reading wake_capable channel
 configuration

The 'wake-capable' entry in channel configuration is not set when
parsing the configuration specified by the controller driver. Add
the missing entry to ensure channel is correctly specified as a
'wake-capable' channel.

Link: https://lore.kernel.org/r/1638320491-13382-1-git-send-email-quic_bbhatt@quicinc.com
Fixes: 0cbf260820fa ("bus: mhi: core: Add support for registering MHI controllers")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bhaumik Bhatt <quic_bbhatt@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211216081227.237749-7-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 5aaca6d0f52b..f1ec34417592 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -788,6 +788,7 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
 		mhi_chan->offload_ch = ch_cfg->offload_channel;
 		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
 		mhi_chan->pre_alloc = ch_cfg->auto_queue;
+		mhi_chan->wake_capable = ch_cfg->wake_capable;
 
 		/*
 		 * If MHI host allocates buffers, then the channel direction

