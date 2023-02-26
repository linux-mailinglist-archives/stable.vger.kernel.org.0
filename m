Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835606A3265
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBZPho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBZPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:37:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBD01AF;
        Sun, 26 Feb 2023 07:37:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF38160B8F;
        Sun, 26 Feb 2023 14:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174B6C433A1;
        Sun, 26 Feb 2023 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422742;
        bh=Z6cedVlKYTp/sAIk1wKhQqv0dIA+sCn2Q5iMjMWSs4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFqx4B3pd3X3db+mjQRt+qacq2gJ122YJvDtYkHJ2ZxliRXhsXmdPJ4mxOgz75ogC
         lwMOZ2k15e/6rV4A7CEUMJ/hzQMrK8M7j6sBIsHIG03CimrIMyulQRNKpvfUQkgpKh
         Ofls7cEmuSApcZSrNiz/TSKBni0ftO2PEno82zql4MVSi5Az7/pc/7aC+uLaPX8b06
         KNjO9zXnSwRbIbv9B8e20VyAu1N/5H0oaj/fheBrB9QgYng5TKorMnJ8y3tsBQvuw+
         57Jzg3QbGbXS/gIejnF5q2zuj1N7e9eywSCuY+XdATg1cgyeezJSJBfhttswUad/QG
         eWoasmi6YeTgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Thaler <dthaler@microsoft.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        andrii@kernel.org, corbet@lwn.net, bpf@vger.kernel.org,
        bpf@ietf.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 22/53] bpf, docs: Fix modulo zero, division by zero, overflow, and underflow
Date:   Sun, 26 Feb 2023 09:44:14 -0500
Message-Id: <20230226144446.824580-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Thaler <dthaler@microsoft.com>

[ Upstream commit 0eb9d19e2201068260e439a5c96dc85f9f3722a2 ]

Fix modulo zero, division by zero, overflow, and underflow. Also clarify how
a negative immediate value is used in unsigned division.

Signed-off-by: Dave Thaler <dthaler@microsoft.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230124001218.827-1-dthaler1968@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/bpf/instruction-set.rst | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index e672d5ec6cc7b..2d3fe59bd260f 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -99,19 +99,26 @@ code      value  description
 BPF_ADD   0x00   dst += src
 BPF_SUB   0x10   dst -= src
 BPF_MUL   0x20   dst \*= src
-BPF_DIV   0x30   dst /= src
+BPF_DIV   0x30   dst = (src != 0) ? (dst / src) : 0
 BPF_OR    0x40   dst \|= src
 BPF_AND   0x50   dst &= src
 BPF_LSH   0x60   dst <<= src
 BPF_RSH   0x70   dst >>= src
 BPF_NEG   0x80   dst = ~src
-BPF_MOD   0x90   dst %= src
+BPF_MOD   0x90   dst = (src != 0) ? (dst % src) : dst
 BPF_XOR   0xa0   dst ^= src
 BPF_MOV   0xb0   dst = src
 BPF_ARSH  0xc0   sign extending shift right
 BPF_END   0xd0   byte swap operations (see `Byte swap instructions`_ below)
 ========  =====  ==========================================================
 
+Underflow and overflow are allowed during arithmetic operations, meaning
+the 64-bit or 32-bit value will wrap. If eBPF program execution would
+result in division by zero, the destination register is instead set to zero.
+If execution would result in modulo by zero, for ``BPF_ALU64`` the value of
+the destination register is unchanged whereas for ``BPF_ALU`` the upper
+32 bits of the destination register are zeroed.
+
 ``BPF_ADD | BPF_X | BPF_ALU`` means::
 
   dst_reg = (u32) dst_reg + (u32) src_reg;
@@ -128,6 +135,11 @@ BPF_END   0xd0   byte swap operations (see `Byte swap instructions`_ below)
 
   dst_reg = dst_reg ^ imm32
 
+Also note that the division and modulo operations are unsigned. Thus, for
+``BPF_ALU``, 'imm' is first interpreted as an unsigned 32-bit value, whereas
+for ``BPF_ALU64``, 'imm' is first sign extended to 64 bits and the result
+interpreted as an unsigned 64-bit value. There are no instructions for
+signed division or modulo.
 
 Byte swap instructions
 ~~~~~~~~~~~~~~~~~~~~~~
-- 
2.39.0

