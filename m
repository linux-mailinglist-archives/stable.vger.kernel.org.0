Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F248F53199B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbiEWRaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241305AbiEWR0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C976C0CC;
        Mon, 23 May 2022 10:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2AAE61157;
        Mon, 23 May 2022 17:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73A3C385A9;
        Mon, 23 May 2022 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326426;
        bh=xZXm9hxyr42KzqGtHutUC98ZI1vmCDUMDb8TdOKvfkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ialM3F9CuKkej3cLQpirgtD3csxe/I32VP22Vz3bHtDPS2LdY3tMXBjKvdsZhqb7y
         3/w98S1p14M1b5/iljYjn53s4khhgPDldODXzE/GMPB4QEP6SBVCyAKe7LQE9fL57G
         DJTDEfaSHeQOZkStPmxdHqm8AD+pcqgpvNnn/x9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.15 054/132] arm64: mte: Ensure the cleared tags are visible before setting the PTE
Date:   Mon, 23 May 2022 19:04:23 +0200
Message-Id: <20220523165832.235944269@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 1d0cb4c8864addc362bae98e8ffa5500c87e1227 upstream.

As an optimisation, only pages mapped with PROT_MTE in user space have
the MTE tags zeroed. This is done lazily at the set_pte_at() time via
mte_sync_tags(). However, this function is missing a barrier and another
CPU may see the PTE updated before the zeroed tags are visible. Add an
smp_wmb() barrier if the mapping is Normal Tagged.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
Cc: <stable@vger.kernel.org> # 5.10.x
Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Link: https://lore.kernel.org/r/20220517093532.127095-1-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/mte.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -73,6 +73,9 @@ void mte_sync_tags(pte_t old_pte, pte_t
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
+
+	/* ensure the tags are visible before the PTE is set */
+	smp_wmb();
 }
 
 int memcmp_pages(struct page *page1, struct page *page2)


