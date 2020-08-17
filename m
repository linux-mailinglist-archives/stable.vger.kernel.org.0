Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F824700B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbgHQR7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388536AbgHQQKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 254A522D70;
        Mon, 17 Aug 2020 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680587;
        bh=E6OS2FT95VtV0/IV0WeRwCdybz7w+OojF51B7w+0eog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWCuK9NwErN5cyU6jOIxV64YMlcRU7HNq4oSSO2WIQGn2gypsOEVLsQT7GifwcQ7z
         zYG4wDSwTbOBHQnhn3eeg5tbQTdqlAqTXYyJSkhLZytUwetTLcpDH7LBYwhxrZH9Hk
         Yd+Chotg2her2aGOvZpgzBq5lCLKfQCFxGrbFz/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 246/270] Revert "parisc: Drop LDCW barrier in CAS code when running UP"
Date:   Mon, 17 Aug 2020 17:17:27 +0200
Message-Id: <20200817143808.079367859@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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


