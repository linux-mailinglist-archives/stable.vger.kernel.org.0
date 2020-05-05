Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7396B1C4E25
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 08:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEEGPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 02:15:35 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:38343 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbgEEGPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 02:15:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588659334; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=4LMyBGiVjDWuIw38SfK2K8gkzHgQXhrQL+ytQ2dYrts=; b=qRFJVkaiNS7CvXviI/BEdouXAqf6wxW85TUnUgotA3GZzll/MzWcB1s6yyw71JE/nK3tbCtw
 oOxnRQgEv6i2aTUurwPLlB2zUex3pmRXVftRDlG0kuzAivDLdNo7JEiXdsKz4fWdWjXffcos
 Wqh/pBf3jwte8cbLeLVcW6+3Uz8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb1047e.7fe0a1acb030-smtp-out-n04;
 Tue, 05 May 2020 06:15:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 37DB4C433BA; Tue,  5 May 2020 06:15:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from sallenki-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sallenki)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2020EC433CB;
        Tue,  5 May 2020 06:15:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2020EC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sallenki@codeaurora.org
From:   Sriharsha Allenki <sallenki@codeaurora.org>
To:     mathias.nyman@intel.com, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, mgautam@codeaurora.org,
        jackp@codeaurora.org, Sriharsha Allenki <sallenki@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] usb: xhci: Fix NULL pointer dereference as part of completion
Date:   Tue,  5 May 2020 11:44:46 +0530
Message-Id: <20200505061446.21850-1-sallenki@codeaurora.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On platforms with IOMMU enabled, multiple SGs can be
coalesced into one by the IOMMU driver. In that case
the SG list processing as part of the completion of
a urb on a bulk endpoint can result into a NULL pointer
dereference with the below stack dump.

<6> Unable to handle kernel NULL pointer dereference at virtual address 0000000c
<6> pgd = c0004000
<6> [0000000c] *pgd=00000000
<6> Internal error: Oops: 5 [#1] PREEMPT SMP ARM
<2> PC is at xhci_queue_bulk_tx+0x454/0x80c
<2> LR is at xhci_queue_bulk_tx+0x44c/0x80c
<2> pc : [<c08907c4>]    lr : [<c08907bc>]    psr: 000000d3
<2> sp : ca337c80  ip : 00000000  fp : ffffffff
<2> r10: 00000000  r9 : 50037000  r8 : 00004000
<2> r7 : 00000000  r6 : 00004000  r5 : 00000000  r4 : 00000000
<2> r3 : 00000000  r2 : 00000082  r1 : c2c1a200  r0 : 00000000
<2> Flags: nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
<2> Control: 10c0383d  Table: b412c06a  DAC: 00000051
<6> Process usb-storage (pid: 5961, stack limit = 0xca336210)
<snip>
<2> [<c08907c4>] (xhci_queue_bulk_tx)
<2> [<c0881b3c>] (xhci_urb_enqueue)
<2> [<c0831068>] (usb_hcd_submit_urb)
<2> [<c08350b4>] (usb_sg_wait)
<2> [<c089f384>] (usb_stor_bulk_transfer_sglist)
<2> [<c089f2c0>] (usb_stor_bulk_srb)
<2> [<c089fe38>] (usb_stor_Bulk_transport)
<2> [<c089f468>] (usb_stor_invoke_transport)
<2> [<c08a11b4>] (usb_stor_control_thread)
<2> [<c014a534>] (kthread)

The above NULL pointer dereference is the result of block_len and
the sent_len set to zero after the first SG of the list when IOMMU
driver is enabled. Because of this the loop of processing the SGs
has run more than num_sgs which resulted in a sg_next on the
last SG of the list which has SG_END set.

Fix this by check for the sg before any attributes of the sg are
accessed.

Fixes: f9c589e142d04 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
---
 drivers/usb/host/xhci-ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a78787bb5133..18141b38f7bf 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3399,8 +3399,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 			/* New sg entry */
 			--num_sgs;
 			sent_len -= block_len;
-			if (num_sgs != 0) {
-				sg = sg_next(sg);
+			sg = sg_next(sg);
+			if (num_sgs != 0 && sg) {
 				block_len = sg_dma_len(sg);
 				addr = (u64) sg_dma_address(sg);
 				addr += sent_len;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
