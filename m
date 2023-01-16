Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDEB66C4A2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjAPP45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjAPP4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC5A234C6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33FF861030
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4727AC433F0;
        Mon, 16 Jan 2023 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884589;
        bh=bvwb+TfdFqzrZlYaGhhtHqOkFZItse3P8vMMxYXsjmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6aLZFkPGrxxi2cwkDNK2srZ4YUZidpUs6dcf0oXt6GASHGzdlkJUnz1+tkqyUHAY
         CbsXEvfKqKE+kk6Q3cciKiWexrAKDYLTkWS+voDiV4oc7o38OheQSLSq8kqCt/GQEd
         9ODIqlV4yDrQim7pKbbh9+c2+XD44Q32vd0VgCTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 063/183] arm64: ptrace: Use ARM64_SME to guard the SME register enumerations
Date:   Mon, 16 Jan 2023 16:49:46 +0100
Message-Id: <20230116154806.016941838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Zenghui Yu <yuzenghui@huawei.com>

commit eb9a85261e297292c4cc44b628c1373c996cedc2 upstream.

We currently guard REGSET_{SSVE, ZA} using ARM64_SVE for no good reason.
Both enumerations would be pointless without ARM64_SME and create two empty
entries in aarch64_regsets[] which would then become part of a process's
native regset view (they should be ignored though).

Switch to use ARM64_SME instead.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221214135943.379-1-yuzenghui@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1364,7 +1364,7 @@ enum aarch64_regset {
 #ifdef CONFIG_ARM64_SVE
 	REGSET_SVE,
 #endif
-#ifdef CONFIG_ARM64_SVE
+#ifdef CONFIG_ARM64_SME
 	REGSET_SSVE,
 	REGSET_ZA,
 #endif


