Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9201B0AEC
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgDTMvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbgDTMsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3FEA206E9;
        Mon, 20 Apr 2020 12:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386894;
        bh=yeLSGgzR6n88LM6EkHFaw2nAdyVzgk80CaFPsnUulog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYXyezgMwB54vZEknlCh0zorXIOU0turZ3MLYj1z6RVJV4jEgv9uzmM00xj7BdFzB
         JEdB8s+1cyL9kOStBbqfVE2givaIuoq3cAA50pWHQSW3FM5OuT4fyW+5NnRW6B8536
         2hjQs9GKaQwERCUd8urLLGvGSShSYwfHObXqdsok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongwu Su <hongwus@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 10/40] scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
Date:   Mon, 20 Apr 2020 14:39:20 +0200
Message-Id: <20200420121454.614682734@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

commit c63d6099a7959ecc919b2549dc6b71f53521f819 upstream.

The async version of ufshcd_hold(async == true), which is only called in
queuecommand path as for now, is expected to work in atomic context, thus
it should not sleep or schedule out. When it runs into the condition that
clocks are ON but link is still in hibern8 state, it should bail out
without flushing the clock ungate work.

Fixes: f2a785ac2312 ("scsi: ufshcd: Fix race between clk scaling and ungate work")
Link: https://lore.kernel.org/r/1581392451-28743-6-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1563,6 +1563,11 @@ start:
 		 */
 		if (ufshcd_can_hibern8_during_gating(hba) &&
 		    ufshcd_is_link_hibern8(hba)) {
+			if (async) {
+				rc = -EAGAIN;
+				hba->clk_gating.active_reqs--;
+				break;
+			}
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
 			flush_work(&hba->clk_gating.ungate_work);
 			spin_lock_irqsave(hba->host->host_lock, flags);


