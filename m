Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC7F7947C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfG2TcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbfG2TcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:32:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB188217D9;
        Mon, 29 Jul 2019 19:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428727;
        bh=ty97BlOGJMlLKNU2GM8hXIFhIkRgTfbUOV9TcJh/z+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmzwzLAxXnOA4y3nuVATWqgDlnAHU91KCBHKhi7Xq2MEMkobLWYxF8bWKtKGi357M
         SZFu13TZe4UbqCc6eiGiQRFYssYxA4/wfcu13LrPTxLNm029jhZBFQI4D68FdtDIr+
         jNdDlRN9Me/kx2L6KigGMFoihjBBQL4mHMsV0hjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 167/293] parisc: Ensure userspace privilege for ptraced processes in regset functions
Date:   Mon, 29 Jul 2019 21:20:58 +0200
Message-Id: <20190729190837.314198313@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 34c32fc603311a72cb558e5e337555434f64c27b upstream.

On parisc the privilege level of a process is stored in the lowest two bits of
the instruction pointers (IAOQ0 and IAOQ1). On Linux we use privilege level 0
for the kernel and privilege level 3 for user-space. So userspace should not be
allowed to modify IAOQ0 or IAOQ1 of a ptraced process to change it's privilege
level to e.g. 0 to try to gain kernel privileges.

This patch prevents such modifications in the regset support functions by
always setting the two lowest bits to one (which relates to privilege level 3
for user-space) if IAOQ0 or IAOQ1 are modified via ptrace regset calls.

Link: https://bugs.gentoo.org/481768
Cc: <stable@vger.kernel.org> # v4.7+
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/ptrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -500,7 +500,8 @@ static void set_reg(struct pt_regs *regs
 			return;
 	case RI(iaoq[0]):
 	case RI(iaoq[1]):
-			regs->iaoq[num - RI(iaoq[0])] = val;
+			/* set 2 lowest bits to ensure userspace privilege: */
+			regs->iaoq[num - RI(iaoq[0])] = val | 3;
 			return;
 	case RI(sar):	regs->sar = val;
 			return;


