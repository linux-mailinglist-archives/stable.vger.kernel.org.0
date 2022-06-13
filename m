Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB17B54974D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356774AbiFMM5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355427AbiFMM4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:56:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEDA12ACB;
        Mon, 13 Jun 2022 04:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE901B80E93;
        Mon, 13 Jun 2022 11:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D116C34114;
        Mon, 13 Jun 2022 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119017;
        bh=Peq5gzmdgmG8DJ+CvcqQLnVGG1RKzHTqlFTjY4iQTVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZC+L1QglFpbmynsfG+035DCdtRM7Msr3n/Vdt4vHad5RACIhwlkLVWJLb/+9HXAY
         484KHdMD05B9GZJUFdvNq8QsIxIWLRkFBQ2J7Yo2JOZUBUcfamAtqpY99SFUQ6ad7N
         iej5zFAGP1XHB8yCH+ysklN9SCy2cck/HrGzcEC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/247] riscv: read-only pages should not be writable
Date:   Mon, 13 Jun 2022 12:09:46 +0200
Message-Id: <20220613094925.503755819@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>

[ Upstream commit 630f972d76d6460235e84e1aa034ee06f9c8c3a9 ]

If EFI pages are marked as read-only,
we should remove the _PAGE_WRITE flag.

The current code overwrites an unused value.

Fixes: b91540d52a08b ("RISC-V: Add EFI runtime services")
Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Link: https://lore.kernel.org/r/20220528014132.91052-1-heinrich.schuchardt@canonical.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
index 024159298231..1aa540350abd 100644
--- a/arch/riscv/kernel/efi.c
+++ b/arch/riscv/kernel/efi.c
@@ -65,7 +65,7 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 
 	if (md->attribute & EFI_MEMORY_RO) {
 		val = pte_val(pte) & ~_PAGE_WRITE;
-		val = pte_val(pte) | _PAGE_READ;
+		val |= _PAGE_READ;
 		pte = __pte(val);
 	}
 	if (md->attribute & EFI_MEMORY_XP) {
-- 
2.35.1



