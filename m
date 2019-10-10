Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED14D25E5
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbfJJJDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387648AbfJJIig (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A3120B7C;
        Thu, 10 Oct 2019 08:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696715;
        bh=IHhM2BGlpoHn43ptPAAojk+cLdU1l36SYQs0R+V2Vd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOAkLQrZKm1aNQ2R87HEvWy8QZocM2Eaw0iSRsBs2MKNkez4LDM4QsllPAHQ1ZMlB
         I7BnAZEtv/YV6eGwH9ndgXmk83Xz57I/181HUHh85m3ZrLUt3MM+llWUHQuOz4jh8c
         1ph6qA20FIRnfXyKmFRRqt/J3M/G4rAYbFR2n2qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 026/148] powerpc/ptdump: Fix addresses display on PPC32
Date:   Thu, 10 Oct 2019 10:34:47 +0200
Message-Id: <20191010083612.703301291@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 7c7a532ba3fc51bf9527d191fb410786c1fdc73c upstream.

Commit 453d87f6a8ae ("powerpc/mm: Warn if W+X pages found on boot")
wrongly changed KERN_VIRT_START from 0 to PAGE_OFFSET, leading to a
shift in the displayed addresses.

Lets revert that change to resync walk_pagetables()'s addr val and
pgd_t pointer for PPC32.

Fixes: 453d87f6a8ae ("powerpc/mm: Warn if W+X pages found on boot")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/eb4d626514e22f85814830012642329018ef6af9.1565786091.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/ptdump/ptdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -27,7 +27,7 @@
 #include "ptdump.h"
 
 #ifdef CONFIG_PPC32
-#define KERN_VIRT_START	PAGE_OFFSET
+#define KERN_VIRT_START	0
 #endif
 
 /*


