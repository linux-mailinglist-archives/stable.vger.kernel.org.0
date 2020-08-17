Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE5246B8C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388121AbgHQP6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388113AbgHQP6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:58:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC0EF207FF;
        Mon, 17 Aug 2020 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679891;
        bh=E6OS2FT95VtV0/IV0WeRwCdybz7w+OojF51B7w+0eog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0ZWXYyG0aCK1XTw+b5BiUOmEpzwaGWTEFvyJMCOh+ff5GQSFrL+8VnNe8ICL/+NM
         8NcQcBAdU0Ly+UgFYzgU1VHE3nX9/NfthsQmChh4kmqmxXFVN+7Kp8VVEMId/PLr32
         4hY4NmnLfu6JU92NLXTZF/8+lP/fUh15k8OPH/Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.7 370/393] Revert "parisc: Drop LDCW barrier in CAS code when running UP"
Date:   Mon, 17 Aug 2020 17:17:00 +0200
Message-Id: <20200817143837.553240967@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 462fb756c7de1ffe5bc6099149136031c2d9c02a upstream.

This reverts commit e6eb5fe9123f05dcbf339ae5c0b6d32fcc0685d5.
We need to optimize it differently. A follow up patch will correct it.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/syscall.S |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -641,8 +641,7 @@ cas_action:
 2:	stw	%r24, 0(%r26)
 	/* Free lock */
 #ifdef CONFIG_SMP
-98:	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
+	LDCW	0(%sr2,%r20), %r1			/* Barrier */
 #endif
 	stw	%r20, 0(%sr2,%r20)
 #if ENABLE_LWS_DEBUG
@@ -659,8 +658,7 @@ cas_action:
 	/* Error occurred on load or store */
 	/* Free lock */
 #ifdef CONFIG_SMP
-98:	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
+	LDCW	0(%sr2,%r20), %r1			/* Barrier */
 #endif
 	stw	%r20, 0(%sr2,%r20)
 #if ENABLE_LWS_DEBUG
@@ -864,8 +862,7 @@ cas2_action:
 cas2_end:
 	/* Free lock */
 #ifdef CONFIG_SMP
-98:	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
+	LDCW	0(%sr2,%r20), %r1			/* Barrier */
 #endif
 	stw	%r20, 0(%sr2,%r20)
 	/* Enable interrupts */
@@ -878,8 +875,7 @@ cas2_end:
 	/* Error occurred on load or store */
 	/* Free lock */
 #ifdef CONFIG_SMP
-98:	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
+	LDCW	0(%sr2,%r20), %r1			/* Barrier */
 #endif
 	stw	%r20, 0(%sr2,%r20)
 	ssm	PSW_SM_I, %r0


