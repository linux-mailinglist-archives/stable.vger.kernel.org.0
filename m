Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B75360D72
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhDOPCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhDOPAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF92661409;
        Thu, 15 Apr 2021 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498565;
        bh=czU1BBx5gFfWn2AkdLFSpb+b7yuGXEGeypDvJmsYFWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClBx+QZ0hc04Oha7csX0wG41jfwH3Tl0utqzcDTZzXZmhVzYYLMsJFDZjlh9C6y+b
         oLFupOlwzxLJqC9xMYDCHp+qSBQLvObi14H0yvEGrOue185Fx1t62OLj3JpAV8n7qQ
         26fpdRahpEuoH69JEOaZo+M/jlpuNwPD3mXQ3u5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zihao Yu <yuzihao@ict.ac.cn>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/13] riscv,entry: fix misaligned base for excp_vect_table
Date:   Thu, 15 Apr 2021 16:47:56 +0200
Message-Id: <20210415144411.843251257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zihao Yu <yuzihao@ict.ac.cn>

[ Upstream commit ac8d0b901f0033b783156ab2dc1a0e73ec42409b ]

In RV64, the size of each entry in excp_vect_table is 8 bytes. If the
base of the table is not 8-byte aligned, loading an entry in the table
will raise a misaligned exception. Although such exception will be
handled by opensbi/bbl, this still causes performance degradation.

Signed-off-by: Zihao Yu <yuzihao@ict.ac.cn>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index a03821b2656a..d9de22686e27 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -449,6 +449,7 @@ ENDPROC(__fstate_restore)
 
 
 	.section ".rodata"
+	.align LGREG
 	/* Exception vector table */
 ENTRY(excp_vect_table)
 	RISCV_PTR do_trap_insn_misaligned
-- 
2.30.2



