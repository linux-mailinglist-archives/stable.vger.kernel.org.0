Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B925081A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfFXKE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbfFXKE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:26 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78EC3208E4;
        Mon, 24 Jun 2019 10:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370665;
        bh=3rtSL/c/4C9S8Ce/tdeE9tMTBn05hu6OGsoopWkk47w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qswu1nKdr82fPzSEceN9Z4Ab5TkvbD44/LlEC4QmnmlGP1/1qQPnGf5KH6oCyMxTA
         p+yhzlDK2488sw0yEGC7MKIeh2DP4+cKLD/DDcagIe4I0FCW9v6sXwKCwMA9wMr1cN
         qNFqz9M70I6GCmNhK1HP8cmbHwUtwoTUW1ggTBy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/90] s390/ap: rework assembler functions to use unions for in/out register variables
Date:   Mon, 24 Jun 2019 17:56:01 +0800
Message-Id: <20190624092314.738302736@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 159491f3b509bd8101199944dc7b0673b881c734 ]

The inline assembler functions ap_aqic() and ap_qact() used two
variables declared on the very same register. One variable was for
input only, the other for output. Looks like newer versions of the gcc
don't like this. Anyway it is a better coding to use one variable
(which may have a union data type) on one register for input and
output. So this patch introduces unions and uses only one variable now
for input and output for GR1 for the PQAP(QACT) and PQAP(QIC)
invocation.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index 8c00fd509c45..1a6a7092d942 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -221,16 +221,22 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 					     void *ind)
 {
 	register unsigned long reg0 asm ("0") = qid | (3UL << 24);
-	register struct ap_qirq_ctrl reg1_in asm ("1") = qirqctrl;
-	register struct ap_queue_status reg1_out asm ("1");
+	register union {
+		unsigned long value;
+		struct ap_qirq_ctrl qirqctrl;
+		struct ap_queue_status status;
+	} reg1 asm ("1");
 	register void *reg2 asm ("2") = ind;
 
+	reg1.qirqctrl = qirqctrl;
+
 	asm volatile(
 		".long 0xb2af0000"		/* PQAP(AQIC) */
-		: "=d" (reg1_out)
-		: "d" (reg0), "d" (reg1_in), "d" (reg2)
+		: "+d" (reg1)
+		: "d" (reg0), "d" (reg2)
 		: "cc");
-	return reg1_out;
+
+	return reg1.status;
 }
 
 /*
@@ -264,17 +270,21 @@ static inline struct ap_queue_status ap_qact(ap_qid_t qid, int ifbit,
 {
 	register unsigned long reg0 asm ("0") = qid | (5UL << 24)
 		| ((ifbit & 0x01) << 22);
-	register unsigned long reg1_in asm ("1") = apinfo->val;
-	register struct ap_queue_status reg1_out asm ("1");
+	register union {
+		unsigned long value;
+		struct ap_queue_status status;
+	} reg1 asm ("1");
 	register unsigned long reg2 asm ("2");
 
+	reg1.value = apinfo->val;
+
 	asm volatile(
 		".long 0xb2af0000"		/* PQAP(QACT) */
-		: "+d" (reg1_in), "=d" (reg1_out), "=d" (reg2)
+		: "+d" (reg1), "=d" (reg2)
 		: "d" (reg0)
 		: "cc");
 	apinfo->val = reg2;
-	return reg1_out;
+	return reg1.status;
 }
 
 /**
-- 
2.20.1



