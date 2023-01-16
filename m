Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB3066C167
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbjAPOLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjAPOKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:10:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9DA2887E;
        Mon, 16 Jan 2023 06:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19A1BB80F9B;
        Mon, 16 Jan 2023 14:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6BEC433EF;
        Mon, 16 Jan 2023 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877856;
        bh=km44sbS8NbtMWSQnGnpXLdIrlgwp4CK+OBKJlAp9J1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDZZZySoRGJNgdjp72gUnf2ErvHKbBNJ23UF5PeZ14044smuCfFXDK5xyswQvAa0/
         VVb6bAY/f8SAqLbHoZmWF4KA188Q1FwIkhVQ9Q0XSP5qVjqO+m5IbMSaPmQdq8/EK/
         tHw/woBZo4EOEO3e4J1E8UKa1LMM4k3Ukzx4s2ge3pgpf+EKfBr5ln5V1YHvwS6Cpc
         4GeeXbL2SLRPPK74P6wIJGi7cu/1Cs7/Op9hu+SgW/G3Vu3jWMQjnOd+FMYeXXUwcp
         hxUDr+9h62y2Etrrof2xZNm9fqCGm9Oh7qtGL8zLlJctU+WeBhX4xfXU7yu/KgQdTf
         KU0v60zv8UnbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        jpoimboe@kernel.org, masahiroy@kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/24] s390: expicitly align _edata and _end symbols on page boundary
Date:   Mon, 16 Jan 2023 09:03:44 -0500
Message-Id: <20230116140359.115716-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 45d619bdaf799196d702a9ae464b07066d6db2f9 ]

Symbols _edata and _end in the linker script are the
only unaligned expicitly on page boundary. Although
_end is aligned implicitly by BSS_SECTION macro that
is still inconsistent and could lead to a bug if a tool
or function would assume that _edata is as aligned as
others.

For example, vmem_map_init() function does not align
symbols _etext, _einittext etc. Should these symbols
be unaligned as well, the size of ranges to update
were short on one page.

Instead of fixing every occurrence of this kind in the
code and external tools just force the alignment on
these two symbols.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index b508ccad4856..8ce1615c1046 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -80,6 +80,7 @@ SECTIONS
 		_end_amode31_refs = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);
 	_edata = .;		/* End of data section */
 
 	/* will be freed after init */
@@ -194,6 +195,7 @@ SECTIONS
 
 	BSS_SECTION(PAGE_SIZE, 4 * PAGE_SIZE, PAGE_SIZE)
 
+	. = ALIGN(PAGE_SIZE);
 	_end = . ;
 
 	/*
-- 
2.35.1

