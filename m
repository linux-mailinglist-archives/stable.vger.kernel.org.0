Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69364A13C
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiLLNhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiLLNgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:36:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E246D13F54
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F3AD61070
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290B2C433EF;
        Mon, 12 Dec 2022 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852179;
        bh=20Rh54gxRjbshHnR3rWD8D4aJaHTewoN5Qws81kUu9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKLtfDVNhoEcMp6UJJKv6wgRqlQl0X3F+LQQu3qIsAn2CzIHENmsDJeECoyqnhnvC
         dUaohgx+yuGbcq2SzE10FiC888nntZP3SHJQASDrvKVECnZKK5T3JA1JeW7Pd6Fv3t
         giKAmTugIdOG2fV9AWmM4Oo83L8I3yNs5M1nJlxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 027/157] LoongArch: Set _PAGE_DIRTY only if _PAGE_MODIFIED is set in {pmd,pte}_mkwrite()
Date:   Mon, 12 Dec 2022 14:16:15 +0100
Message-Id: <20221212130935.608480688@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cc0674d1b8f0..645e24ebec68 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -357,7 +357,9 @@ static inline pte_t pte_mkdirty(pte_t pte)
 
 static inline pte_t pte_mkwrite(pte_t pte)
 {
-	pte_val(pte) |= (_PAGE_WRITE | _PAGE_DIRTY);
+	pte_val(pte) |= _PAGE_WRITE;
+	if (pte_val(pte) & _PAGE_MODIFIED)
+		pte_val(pte) |= _PAGE_DIRTY;
 	return pte;
 }
 
@@ -454,7 +456,9 @@ static inline int pmd_write(pmd_t pmd)
 
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



