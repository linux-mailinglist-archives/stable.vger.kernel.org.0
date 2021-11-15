Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446C5450C5A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhKORhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238088AbhKORfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A8D632C6;
        Mon, 15 Nov 2021 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997002;
        bh=MhkQThuZu9xEQw+KVc2XekTNMy1nAIEAK7iqY+0VRB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vS2IsOSD2WDGrGBiq7lZV1z65lM9D+rDqMFHhTMq/8aenzv16r4wxSggy1AhKils+
         Xx9PcHGYWlW41uizOV+6pNhs71FZsDTbUTWAVIP8MfuZmxxscLmCjX7LDkk4+NMY0J
         9jleIKNuX6dlS0XR6luilnJjzNrYteaiu5/nRHS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 345/355] powerpc/security: Add a helper to query stf_barrier type
Date:   Mon, 15 Nov 2021 18:04:29 +0100
Message-Id: <20211115165324.902823686@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

upstream commit 030905920f32e91a52794937f67434ac0b3ea41a

Add a helper to return the stf_barrier type for the current processor.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/3bd5d7f96ea1547991ac2ce3137dc2b220bae285.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/security_features.h |    5 +++++
 arch/powerpc/kernel/security.c               |    5 +++++
 2 files changed, 10 insertions(+)

--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -39,6 +39,11 @@ static inline bool security_ftr_enabled(
 	return !!(powerpc_security_features & feature);
 }
 
+#ifdef CONFIG_PPC_BOOK3S_64
+enum stf_barrier_type stf_barrier_type_get(void);
+#else
+static inline enum stf_barrier_type stf_barrier_type_get(void) { return STF_BARRIER_NONE; }
+#endif
 
 // Features indicating support for Spectre/Meltdown mitigations
 
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -256,6 +256,11 @@ static int __init handle_no_stf_barrier(
 
 early_param("no_stf_barrier", handle_no_stf_barrier);
 
+enum stf_barrier_type stf_barrier_type_get(void)
+{
+	return stf_enabled_flush_types;
+}
+
 /* This is the generic flag used by other architectures */
 static int __init handle_ssbd(char *p)
 {


