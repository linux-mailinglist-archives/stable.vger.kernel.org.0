Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8602C9D6F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgLAJXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388886AbgLAJGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959A420770;
        Tue,  1 Dec 2020 09:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813587;
        bh=fDOYCOxHpG/8IxKY4f501UGZN7teu79FhQ7xC3jVKag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yu5SXa7NLrm+wKEOeWN0ZNx4zhjei+9jaJlFhZ41QcO8uxAJGpDmJFini4e11BG/d
         4kmGI7peA8YRhPBcSlrbNUcntnWseNkHA8R6vpxr9fjLJUMYFrhI7uSahV6cR1MosV
         VGs4bBwVMxq0UTcGQHWO31qAhDe1TXEl7bv6u7ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/98] powerpc/64s: Fix allnoconfig build since uaccess flush
Date:   Tue,  1 Dec 2020 09:53:37 +0100
Message-Id: <20201201084658.030197820@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit b6b79dd53082db11070b4368d85dd6699ff0b063 ]

Using DECLARE_STATIC_KEY_FALSE needs linux/jump_table.h.

Otherwise the build fails with eg:

  arch/powerpc/include/asm/book3s/64/kup-radix.h:66:1: warning: data definition has no type or storage class
     66 | DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);

Fixes: 9a32a7e78bd0 ("powerpc/64s: flush L1D after user accesses")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
[mpe: Massage change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201123184016.693fe464@canb.auug.org.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index c1e45f510591e..a29b64129a7d4 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -54,6 +54,8 @@
 
 #else /* !__ASSEMBLY__ */
 
+#include <linux/jump_label.h>
+
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 
 #ifdef CONFIG_PPC_KUAP
-- 
2.27.0



