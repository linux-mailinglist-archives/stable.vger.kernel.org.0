Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1011BC9F6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgD1Sof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731523AbgD1Soe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9CAF20575;
        Tue, 28 Apr 2020 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099474;
        bh=7aAfdH315mEjxyKAJ9uYiH+oWvIOOA9wFDcUuOCR874=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsHue0EZ0qiPz26QRq5YGvJH97I1lNZlbVWEER4BDRrdW+pstIeadyafv6uuc54z/
         R0asrCDLNEbXqnKYedIxPQpzzzOhBY0IsfPfmlrchPX50l3Upa8aUPn2rxBYTQqbrZ
         gOubXoO/I05gjAczDtMcPWASsgauCNB2ceijZ4pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 165/168] powerpc/kuap: PPC_KUAP_DEBUG should depend on PPC_KUAP
Date:   Tue, 28 Apr 2020 20:25:39 +0200
Message-Id: <20200428182251.594486664@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 61da50b76b62fd815aa82d853bf82bf4f69568f5 upstream.

Currently you can enable PPC_KUAP_DEBUG when PPC_KUAP is disabled,
even though the former has not effect without the latter.

Fix it so that PPC_KUAP_DEBUG can only be enabled when PPC_KUAP is
enabled, not when the platform could support KUAP (PPC_HAVE_KUAP).

Fixes: 890274c2dc4c ("powerpc/64s: Implement KUAP for Radix MMU")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200301111738.22497-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/Kconfig.cputype |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -389,7 +389,7 @@ config PPC_KUAP
 
 config PPC_KUAP_DEBUG
 	bool "Extra debugging for Kernel Userspace Access Protection"
-	depends on PPC_HAVE_KUAP && (PPC_RADIX_MMU || PPC_32)
+	depends on PPC_KUAP && (PPC_RADIX_MMU || PPC_32)
 	help
 	  Add extra debugging for Kernel Userspace Access Protection (KUAP)
 	  If you're unsure, say N.


