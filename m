Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F696A09FE
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbjBWNMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjBWNMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBEC570AA
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A46561705
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A64C433EF;
        Thu, 23 Feb 2023 13:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157901;
        bh=GXeqm3LsXtJ4e8OMUG+rff/3jUn1CLFe2DnSGieRSJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyEYZYmTswGidIjXOY6AfN2hZX9e7nzPusw7Ab5HZnTNbql2Tn6tFeJIpj6JOrEsf
         6fI2u6FNzxvCuD0ZeEmB5Fqt0DNWkU6U2TbY2/nnm5FBFIOSOBqHqcNP+UIhI9Jrk1
         Pose4UAVWcfZ7JxZ+jGmWViXhXTKdZvwReK/mlvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/36] powerpc/vmlinux.lds: Ensure STRICT_ALIGN_SIZE is at least page aligned
Date:   Thu, 23 Feb 2023 14:06:53 +0100
Message-Id: <20230223130429.880558662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 331771e836e6a32c8632d8cf5e2cdd94471258ad ]

Add a check that STRICT_ALIGN_SIZE is aligned to at least PAGE_SIZE.

That then makes the alignment to PAGE_SIZE immediately after the
alignment to STRICT_ALIGN_SIZE redundant, so remove it.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220916131422.318752-1-mpe@ellerman.id.au
Stable-dep-of: 111bcb373853 ("powerpc/64s/radix: Fix RWX mapping with relocated kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 1a63e37f336ab..bcbe41c6998ca 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -32,6 +32,10 @@
 
 #define STRICT_ALIGN_SIZE	(1 << CONFIG_DATA_SHIFT)
 
+#if STRICT_ALIGN_SIZE < PAGE_SIZE
+#error "CONFIG_DATA_SHIFT must be >= PAGE_SHIFT"
+#endif
+
 ENTRY(_stext)
 
 PHDRS {
@@ -209,7 +213,6 @@ SECTIONS
  */
 	. = ALIGN(STRICT_ALIGN_SIZE);
 	__init_begin = .;
-	. = ALIGN(PAGE_SIZE);
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
 		INIT_TEXT
-- 
2.39.0



