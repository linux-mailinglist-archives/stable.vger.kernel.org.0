Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7A615C1E5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgBMP11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgBMP10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:26 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 833B52468C;
        Thu, 13 Feb 2020 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607645;
        bh=brwYKlmau825gDmimRPicwKuw/d51BOfakanpJf4+aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uq0WfYi+udvEGPF8qniFAXiKrpqGfK/inKPJ4I/C4VKLvLrynr8pOjBKzZFbqlSa4
         8FT6kCdaaz/oFJyXEgg/npoYXbmO6JyTN1ZJ9qtJJifxvDBr3X6KIE6WDoYyqQdngv
         fCgbn78CZc++GIx3tHcjGnSWAS0qOE50s4Zwf7H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 54/96] powerpc/ptdump: Fix W+X verification call in mark_rodata_ro()
Date:   Thu, 13 Feb 2020 07:21:01 -0800
Message-Id: <20200213151900.389377364@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit e26ad936dd89d79f66c2b567f700e0c2a7103070 upstream.

ptdump_check_wx() also have to be called when pages are mapped
by blocks.

Fixes: 453d87f6a8ae ("powerpc/mm: Warn if W+X pages found on boot")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/37517da8310f4457f28921a4edb88fb21d27b62a.1578989531.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/pgtable_32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -221,6 +221,7 @@ void mark_rodata_ro(void)
 
 	if (v_block_mapped((unsigned long)_sinittext)) {
 		mmu_mark_rodata_ro();
+		ptdump_check_wx();
 		return;
 	}
 


