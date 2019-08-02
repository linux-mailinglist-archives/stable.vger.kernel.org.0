Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4F7F229
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388426AbfHBJpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392018AbfHBJpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5534020B7C;
        Fri,  2 Aug 2019 09:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739149;
        bh=oZQ86BBsGwGXKISr8ot9saUVaLRJbr10trhIT/B/b3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSArMo2UbjaRUZSe/9hUPXdT3tsqhsdVb1GU083CfKS+lfxid94tDz2feYNU0c398
         JwuB9VmhDBKc/+H4AapKILOmf+kQmHUIjsgRku810o7du40fcsnT6CZ2BCbT9xsZPg
         5icrKkRq/Cy5uXlpazh8+sYdvSJDFT2kgFkvxBc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeroen Roovers <jer@gentoo.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 117/223] parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1
Date:   Fri,  2 Aug 2019 11:35:42 +0200
Message-Id: <20190802092246.763018856@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 10835c854685393a921b68f529bf740fa7c9984d upstream.

On parisc the privilege level of a process is stored in the lowest two bits of
the instruction pointers (IAOQ0 and IAOQ1). On Linux we use privilege level 0
for the kernel and privilege level 3 for user-space. So userspace should not be
allowed to modify IAOQ0 or IAOQ1 of a ptraced process to change it's privilege
level to e.g. 0 to try to gain kernel privileges.

This patch prevents such modifications by always setting the two lowest bits to
one (which relates to privilege level 3 for user-space) if IAOQ0 or IAOQ1 are
modified via ptrace calls in the native and compat ptrace paths.

Link: https://bugs.gentoo.org/481768
Reported-by: Jeroen Roovers <jer@gentoo.org>
Cc: <stable@vger.kernel.org>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/ptrace.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -170,6 +170,9 @@ long arch_ptrace(struct task_struct *chi
 		if ((addr & (sizeof(unsigned long)-1)) ||
 		     addr >= sizeof(struct pt_regs))
 			break;
+		if (addr == PT_IAOQ0 || addr == PT_IAOQ1) {
+			data |= 3; /* ensure userspace privilege */
+		}
 		if ((addr >= PT_GR1 && addr <= PT_GR31) ||
 				addr == PT_IAOQ0 || addr == PT_IAOQ1 ||
 				(addr >= PT_FR0 && addr <= PT_FR31 + 4) ||
@@ -231,16 +234,18 @@ long arch_ptrace(struct task_struct *chi
 
 static compat_ulong_t translate_usr_offset(compat_ulong_t offset)
 {
-	if (offset < 0)
-		return sizeof(struct pt_regs);
-	else if (offset <= 32*4)	/* gr[0..31] */
-		return offset * 2 + 4;
-	else if (offset <= 32*4+32*8)	/* gr[0..31] + fr[0..31] */
-		return offset + 32*4;
-	else if (offset < sizeof(struct pt_regs)/2 + 32*4)
-		return offset * 2 + 4 - 32*8;
+	compat_ulong_t pos;
+
+	if (offset < 32*4)	/* gr[0..31] */
+		pos = offset * 2 + 4;
+	else if (offset < 32*4+32*8)	/* fr[0] ... fr[31] */
+		pos = (offset - 32*4) + PT_FR0;
+	else if (offset < sizeof(struct pt_regs)/2 + 32*4) /* sr[0] ... ipsw */
+		pos = (offset - 32*4 - 32*8) * 2 + PT_SR0 + 4;
 	else
-		return sizeof(struct pt_regs);
+		pos = sizeof(struct pt_regs);
+
+	return pos;
 }
 
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
@@ -284,9 +289,12 @@ long compat_arch_ptrace(struct task_stru
 			addr = translate_usr_offset(addr);
 			if (addr >= sizeof(struct pt_regs))
 				break;
+			if (addr == PT_IAOQ0+4 || addr == PT_IAOQ1+4) {
+				data |= 3; /* ensure userspace privilege */
+			}
 			if (addr >= PT_FR0 && addr <= PT_FR31 + 4) {
 				/* Special case, fp regs are 64 bits anyway */
-				*(__u64 *) ((char *) task_regs(child) + addr) = data;
+				*(__u32 *) ((char *) task_regs(child) + addr) = data;
 				ret = 0;
 			}
 			else if ((addr >= PT_GR1+4 && addr <= PT_GR31+4) ||


