Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712724418CA
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhKAJvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234786AbhKAJtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B27C6124B;
        Mon,  1 Nov 2021 09:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759103;
        bh=Ofna1o3ie+n21vpiTSA3lx93tCycHR9DlDgQsRn5+OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2TS+Fg1oNHWAcx+IPvdJ7E3WlcKwEFBEZdp1e3Xzn8qj6jtkCTFtQ8vKu5EY9mXK
         2J5oTeyMQOJBy4zyV3NTDl5XU4kVwfyOqm+FKIXlqWoRGX9YbyAXTyRYxeMA4Nqpph
         uzNs6GbT1TMC8UlF3UheX4eyfSiXMT8skTfVaUS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.14 117/125] scsi: ibmvfc: Fix up duplicate response detection
Date:   Mon,  1 Nov 2021 10:18:10 +0100
Message-Id: <20211101082555.193904371@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

commit e20f80b9b163dc402dca115eed0affba6df5ebb5 upstream.

Commit a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale
response detection") introduced a regression in detecting duplicate
responses. This was observed in test where a command was sent to the VIOS
and completed before ibmvfc_send_event() set the active flag to 1, which
resulted in the atomic_dec_if_positive() call in ibmvfc_handle_crq()
thinking this was a duplicate response, which resulted in scsi_done() not
getting called, so we then hit a SCSI command timeout for this command once
the timeout expires.  This simply ensures the active flag gets set prior to
making the hcall to send the command to the VIOS, in order to close this
window.

Link: https://lore.kernel.org/r/20211019152129.16558-1-brking@linux.vnet.ibm.com
Fixes: a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale response detection")
Cc: stable@vger.kernel.org
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1696,6 +1696,7 @@ static int ibmvfc_send_event(struct ibmv
 
 	spin_lock_irqsave(&evt->queue->l_lock, flags);
 	list_add_tail(&evt->queue_list, &evt->queue->sent);
+	atomic_set(&evt->active, 1);
 
 	mb();
 
@@ -1710,6 +1711,7 @@ static int ibmvfc_send_event(struct ibmv
 				     be64_to_cpu(crq_as_u64[1]));
 
 	if (rc) {
+		atomic_set(&evt->active, 0);
 		list_del(&evt->queue_list);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		del_timer(&evt->timer);
@@ -1737,7 +1739,6 @@ static int ibmvfc_send_event(struct ibmv
 
 		evt->done(evt);
 	} else {
-		atomic_set(&evt->active, 1);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
 	}


