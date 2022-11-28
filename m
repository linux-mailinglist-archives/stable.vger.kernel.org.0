Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9F63AF4E
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiK1Rkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiK1RkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2562529812;
        Mon, 28 Nov 2022 09:39:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6D59612E9;
        Mon, 28 Nov 2022 17:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD21C433D6;
        Mon, 28 Nov 2022 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657141;
        bh=wdLy3DGrffKX9Qj8o4u72weS2ccdp4pwLKa8Yk9H6Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTuV8HFObQobzrVqnPd3D2XdGnOcEjY2SW29cwfqSSy63vXW+o/C+9Ib3vhhMiwAt
         efD6BrQoIrz0UQRn/qV5XXGZ9ws+x2XU0R50rtnDkNaKAoEHIfjE4+hLcA6JlbWSBO
         NUQfdxdbx+064pr37AwYXREgyjcPmTjV9NbQ/Zj2ZkahcSDbr8zfhS+deoaDAjrnCY
         xE03Of1i9dV9V6+sWTMC1ei6jfwU6yyk+NmMaE3i3oBO6M7mPitG3jb89l633zVxNd
         XNgM8ap7qrwEqbXf1HSUnPTctEkQziliW2lNDptIp5MAr3zUSGVNyl6vInJxCAjSKD
         2HnOIBsmYuOMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>, Guo Ren <guoren@kernel.org>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        akpm@linux-foundation.org, rppt@kernel.org,
        jiaxun.yang@flygoat.com, git@xen0n.name, loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 25/39] LoongArch: Set _PAGE_DIRTY only if _PAGE_MODIFIED is set in {pmd,pte}_mkwrite()
Date:   Mon, 28 Nov 2022 12:36:05 -0500
Message-Id: <20221128173642.1441232-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 54e6cd42a183b602e3627ad3aaeeed44f7443e67 ]

Set _PAGE_DIRTY only if _PAGE_MODIFIED is set in {pmd,pte}_mkwrite().
Otherwise, _PAGE_DIRTY silences the TLB modify exception and make us
have no chance to mark a pmd/pte dirty (_PAGE_MODIFIED) for software.

Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 8ea57e2f0e04..79981ee8a171 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -355,7 +355,9 @@ static inline pte_t pte_mkdirty(pte_t pte)
 
 static inline pte_t pte_mkwrite(pte_t pte)
 {
-	pte_val(pte) |= (_PAGE_WRITE | _PAGE_DIRTY);
+	pte_val(pte) |= _PAGE_WRITE;
+	if (pte_val(pte) & _PAGE_MODIFIED)
+		pte_val(pte) |= _PAGE_DIRTY;
 	return pte;
 }
 
@@ -452,7 +454,9 @@ static inline int pmd_write(pmd_t pmd)
 
 static inline pmd_t pmd_mkwrite(pmd_t pmd)
 {
-	pmd_val(pmd) |= (_PAGE_WRITE | _PAGE_DIRTY);
+	pmd_val(pmd) |= _PAGE_WRITE;
+	if (pmd_val(pmd) & _PAGE_MODIFIED)
+		pmd_val(pmd) |= _PAGE_DIRTY;
 	return pmd;
 }
 
-- 
2.35.1

