Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FA31B0A4F
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgDTMrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgDTMrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:47:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60019206D4;
        Mon, 20 Apr 2020 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386828;
        bh=zdaV98C4qGP4BiZi+UEicnipIKDAQoW3KWA80HZLGKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bn39YE6rtws3JHzDixQ/j9ZqfN7bVH61YISLdNpPmgbpPhs38UvoVTnV70UDSOhB5
         hH05Q/HGTbIryAASEaWNRkTir3cqdgfalmrrKvwF+vDOBI3izJSWlVJMYRbbiy4lAv
         O1HDQZw7VAnTjCA/M9LWbKW91r0B7g4T/14ThdMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 41/60] arm64: vdso: dont free unallocated pages
Date:   Mon, 20 Apr 2020 14:39:19 +0200
Message-Id: <20200420121511.768372248@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 9cc3d0c6915aee5140f8335d41bbc3ff1b79aa4e upstream.

The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
or C_VDSO slots, and as the array is zero initialized these contain
NULL.

However in __aarch32_alloc_vdso_pages() when
aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
struct page is at NULL, which is obviously nonsensical.

This patch removes the erroneous page freeing.

Fixes: 7c1deeeb0130 ("arm64: compat: VDSO setup for compat layer")
Cc: <stable@vger.kernel.org> # 5.3.x-
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/vdso.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -260,18 +260,7 @@ static int __aarch32_alloc_vdso_pages(vo
 	if (ret)
 		return ret;
 
-	ret = aarch32_alloc_kuser_vdso_page();
-	if (ret) {
-		unsigned long c_vvar =
-			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VVAR]);
-		unsigned long c_vdso =
-			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VDSO]);
-
-		free_page(c_vvar);
-		free_page(c_vdso);
-	}
-
-	return ret;
+	return aarch32_alloc_kuser_vdso_page();
 }
 #else
 static int __aarch32_alloc_vdso_pages(void)


