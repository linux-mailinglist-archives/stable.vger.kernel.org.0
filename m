Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1778E6AF0CE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCGSgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjCGSfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:35:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4A7B861E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:27:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 709A6614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E4DC433EF;
        Tue,  7 Mar 2023 18:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213620;
        bh=kXVQvDbRjjHJfJN5vjStph0aXrLR7cljx3xmC6+I7xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUro2UcqKD9LJfaovGK+pksGNmubUtNpe0Msxiejk15kf8Wyiia1G/dwC0tojZq0N
         VeoQ7uWnqPU+XjEBkgyIlzVdPnxa4eN5xfs1sBz40SH2A2RZ+7KKlkbBSSC8fYFEVb
         V1E+Mtypx/0X9lemWKPRnOyOmB5PUkfJ8zmGrd4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Thaler <dthaler@microsoft.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 564/885] bpf, docs: Fix modulo zero, division by zero, overflow, and underflow
Date:   Tue,  7 Mar 2023 17:58:18 +0100
Message-Id: <20230307170026.947355919@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 5d798437dad47..3ba6475cfbfc7 100644
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
 
   src_reg = src_reg ^ imm32
 
+Also note that the division and modulo operations are unsigned. Thus, for
+``BPF_ALU``, 'imm' is first interpreted as an unsigned 32-bit value, whereas
+for ``BPF_ALU64``, 'imm' is first sign extended to 64 bits and the result
+interpreted as an unsigned 64-bit value. There are no instructions for
+signed division or modulo.
 
 Byte swap instructions
 ~~~~~~~~~~~~~~~~~~~~~~
-- 
2.39.2



