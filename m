Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0794B6949F9
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjBMPDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjBMPD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1240113E2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 910436115B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3E4C433EF;
        Mon, 13 Feb 2023 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300594;
        bh=NaqXkfFZtpoDH9Rm1mz+i9p6uXwYGnK7GsGYT4K3MM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMW/iRGox8ojVHk6rJesGMvlVfwFf6QB+7xgajvIferjKd4xR/d9P6kv9rjc5F/YG
         6pSuiyHlnkeH39FfdnNu+nF96L+oGtNFfDfeYDKU8nfjCh1Bp8d72nWAxpZqm0Vwpn
         WkDDbyAJaLG/HjddzKoXcSr8FYROIs1zwjhHipIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anton Gusev <aagusev@ispras.ru>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/139] efi: fix potential NULL deref in efi_mem_reserve_persistent
Date:   Mon, 13 Feb 2023 15:49:41 +0100
Message-Id: <20230213144747.561289739@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Anton Gusev <aagusev@ispras.ru>

[ Upstream commit 966d47e1f27c45507c5df82b2a2157e5a4fd3909 ]

When iterating on a linked list, a result of memremap is dereferenced
without checking it for NULL.

This patch adds a check that falls back on allocating a new page in
case memremap doesn't succeed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 18df7577adae ("efi/memreserve: deal with memreserve entries in unmapped memory")
Signed-off-by: Anton Gusev <aagusev@ispras.ru>
[ardb: return -ENOMEM instead of breaking out of the loop]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a2765d668856..332739f3eded 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -950,6 +950,8 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 	/* first try to find a slot in an existing linked list entry */
 	for (prsv = efi_memreserve_root->next; prsv; ) {
 		rsv = memremap(prsv, sizeof(*rsv), MEMREMAP_WB);
+		if (!rsv)
+			return -ENOMEM;
 		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
 		if (index < rsv->size) {
 			rsv->entry[index].base = addr;
-- 
2.39.0



