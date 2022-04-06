Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2474F69CC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiDFT2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiDFT1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:27:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266722706C8;
        Wed,  6 Apr 2022 11:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5CF1B8253D;
        Wed,  6 Apr 2022 18:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EEAC385A1;
        Wed,  6 Apr 2022 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269665;
        bh=D8VjMSLV7J+BhyvDpS/RzYuVt06tHFYRtIsaCv/TRl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1C9n8kuCwAMn+rqRALD+EYJXtSPB7tSmYYFIGctPu+bhYq5DGewgWrtZTEft3hgQ
         GRVuvhtlbh8HJz5wcWRslR88t8ud73QOG1wHcoJkxRdw+ZziQaVzJW22Tg2hfiF0o1
         /0zwhM4Kup1APOtUb0CaWIORGf7AyJI8T9VugIkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 24/43] arm64: Add helper to decode register from instruction
Date:   Wed,  6 Apr 2022 20:26:33 +0200
Message-Id: <20220406182437.383541735@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 8c2dcbd2c4443bad0b4242fb62baa47b260b8f79 upstream.

Add a helper to extract the register field from a given
instruction.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/insn.h |    2 ++
 arch/arm64/kernel/insn.c      |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -332,6 +332,8 @@ bool aarch64_insn_is_branch(u32 insn);
 u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
+u32 aarch64_insn_decode_register(enum aarch64_insn_register_type type,
+					 u32 insn);
 u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
 				enum aarch64_insn_branch_type type);
 u32 aarch64_insn_gen_comp_branch_imm(unsigned long pc, unsigned long addr,
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -418,6 +418,35 @@ u32 __kprobes aarch64_insn_encode_immedi
 	return insn;
 }
 
+u32 aarch64_insn_decode_register(enum aarch64_insn_register_type type,
+					u32 insn)
+{
+	int shift;
+
+	switch (type) {
+	case AARCH64_INSN_REGTYPE_RT:
+	case AARCH64_INSN_REGTYPE_RD:
+		shift = 0;
+		break;
+	case AARCH64_INSN_REGTYPE_RN:
+		shift = 5;
+		break;
+	case AARCH64_INSN_REGTYPE_RT2:
+	case AARCH64_INSN_REGTYPE_RA:
+		shift = 10;
+		break;
+	case AARCH64_INSN_REGTYPE_RM:
+		shift = 16;
+		break;
+	default:
+		pr_err("%s: unknown register type encoding %d\n", __func__,
+		       type);
+		return 0;
+	}
+
+	return (insn >> shift) & GENMASK(4, 0);
+}
+
 static u32 aarch64_insn_encode_register(enum aarch64_insn_register_type type,
 					u32 insn,
 					enum aarch64_insn_register reg)


