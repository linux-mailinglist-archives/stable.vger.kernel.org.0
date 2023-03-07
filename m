Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD276AEE4D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjCGSLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjCGSKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11A44D630
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E37F61520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ED6C4339B;
        Tue,  7 Mar 2023 18:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212334;
        bh=anWK4BZaITy0XSARCu9RwGG+L/gUg3n2076L28i3ww0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJRNJn1H3cg1Lv9pW9kP4oIXH2sXH7ggaFSVDyF6XCDxkFPBD+U+Op+WvIANoWptF
         Eb6dtABRe1ugpHTzEH3uTE3tjHoOb8krUoW9dWKA0sYmNa5rWZeZoSliMeICNaOri3
         g/zomv8IrYAZkXzNToYMvY/B91CL4J4QUulGivnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/885] kselftest/arm64: Fix syscall-abi for systems without 128 bit SME
Date:   Tue,  7 Mar 2023 17:51:27 +0100
Message-Id: <20230307170008.552093263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 97ec597b26df774a257e3f8e97353fd1b4471615 ]

SME does not mandate any specific VL so we may not have 128 bit SME but
the algorithm used for enumerating VLs assumes that we will. Add the
required check to ensure that the algorithm terminates.

Fixes: 43e3f85523e4 ("kselftest/arm64: Add SME support to syscall ABI test")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221223-arm64-syscall-abi-sme-only-v1-1-4fabfbd62087@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/syscall-abi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/arm64/abi/syscall-abi.c b/tools/testing/selftests/arm64/abi/syscall-abi.c
index dd7ebe536d05f..ffe719b50c215 100644
--- a/tools/testing/selftests/arm64/abi/syscall-abi.c
+++ b/tools/testing/selftests/arm64/abi/syscall-abi.c
@@ -390,6 +390,10 @@ static void test_one_syscall(struct syscall_cfg *cfg)
 
 			sme_vl &= PR_SME_VL_LEN_MASK;
 
+			/* Found lowest VL */
+			if (sve_vq_from_vl(sme_vl) > sme_vq)
+				break;
+
 			if (sme_vq != sve_vq_from_vl(sme_vl))
 				sme_vq = sve_vq_from_vl(sme_vl);
 
@@ -461,6 +465,10 @@ int sme_count_vls(void)
 
 		vl &= PR_SME_VL_LEN_MASK;
 
+		/* Found lowest VL */
+		if (sve_vq_from_vl(vl) > vq)
+			break;
+
 		if (vq != sve_vq_from_vl(vl))
 			vq = sve_vq_from_vl(vl);
 
-- 
2.39.2



