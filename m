Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9CCEEFAD
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfKDVzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388141AbfKDVzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:20 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31052053B;
        Mon,  4 Nov 2019 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904519;
        bh=c/23/zO5M8qYOwM1lKec8fGLum3bc5+xWnSsny0sJZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEc1Ygz25k33wiTAnlDMsEAJ6u+2Bmvzscd7feQ0Y27ef+89paWLWOSZF0LwFIG3N
         rnDX38Vk7uShTa9/ROycuB/9tHmLQOrBQt+G33JWFZtnXFVpGnaf8KE15Lz0ivPaey
         lQbmew/KDS3eBuLfZqCYEEjg2r6iVqFDSAH0siPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 74/95] scsi: target: cxgbit: Fix cxgbit_fw4_ack()
Date:   Mon,  4 Nov 2019 22:45:12 +0100
Message-Id: <20191104212116.495220657@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit fc5b220b2dcf8b512d9bd46fd17f82257e49bf89 upstream.

Use the pointer 'p' after having tested that pointer instead of before.

Fixes: 5cadafb236df ("target/cxgbit: Fix endianness annotations")
Cc: Varun Prakash <varun@chelsio.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191023202150.22173-1-bvanassche@acm.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1767,7 +1767,7 @@ static void cxgbit_fw4_ack(struct cxgbit
 
 	while (credits) {
 		struct sk_buff *p = cxgbit_sock_peek_wr(csk);
-		const u32 csum = (__force u32)p->csum;
+		u32 csum;
 
 		if (unlikely(!p)) {
 			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
@@ -1776,6 +1776,7 @@ static void cxgbit_fw4_ack(struct cxgbit
 			break;
 		}
 
+		csum = (__force u32)p->csum;
 		if (unlikely(credits < csum)) {
 			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
 				csk,  csk->tid,


