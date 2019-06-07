Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B9D38FE3
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbfFGPqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731421AbfFGPqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:46:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75670212F5;
        Fri,  7 Jun 2019 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922394;
        bh=8QlJJdFA43+I5a1OP0oP2z71pKHVQ6ZQmOOq+9J9Ni8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9y2g8wOKSinzFUm/J0GxiWCchqOqhpYP6yg9GoeGpH7gD1OJzlsZKxdby4qzzQ7n
         j2Gf2S2fAga3zFI0qhjWRNkiQ6rm/8pVrwQSzXe6JSF65WLDdaw5j+G5ILAcsfM0Af
         eEEkO/SXIEWrtxl3fjKpv1Q4gFV9eljGf1EPnV50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 4.19 70/73] scsi: lpfc: Fix backport of faf5a744f4f8 ("scsi: lpfc: avoid uninitialized variable warning")
Date:   Fri,  7 Jun 2019 17:39:57 +0200
Message-Id: <20190607153856.615668534@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Prior to commit 4c47efc140fa ("scsi: lpfc: Move SCSI and NVME Stats to
hardware queue structures") upstream, we allocated a cstat structure in
lpfc_nvme_create_localport. When commit faf5a744f4f8 ("scsi: lpfc: avoid
uninitialized variable warning") was backported, it was placed after the
allocation so we leaked memory whenever this function was called and
that conditional was true (so whenever CONFIG_NVME_FC is disabled).

Move the IS_ENABLED if statement above the allocation since it is not
needed when the condition is true.

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2477,14 +2477,14 @@ lpfc_nvme_create_localport(struct lpfc_v
 	lpfc_nvme_template.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
 	lpfc_nvme_template.max_hw_queues = phba->cfg_nvme_io_channel;
 
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return ret;
+
 	cstat = kmalloc((sizeof(struct lpfc_nvme_ctrl_stat) *
 			phba->cfg_nvme_io_channel), GFP_KERNEL);
 	if (!cstat)
 		return -ENOMEM;
 
-	if (!IS_ENABLED(CONFIG_NVME_FC))
-		return ret;
-
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */


