Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998E64CF969
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbiCGKEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbiCGKAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D7E7DE2F;
        Mon,  7 Mar 2022 01:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCC761343;
        Mon,  7 Mar 2022 09:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78769C340F3;
        Mon,  7 Mar 2022 09:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646421;
        bh=PJhclMeZHNqjQ4k7occUJb+52L47Qcey3RRk2AO8MJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5LXo1uw7XVZ3bgcHSTkfIQ29yJ9B4fwsjG0wZxN51CJIAzFiPGFe/ZN6AEKzZCE7
         DuSITOSZWN99AV8pVrw5oYC4EXp0dZyl+iuHItdB22+q+zK4YhmyJzfDTqw2CqijLE
         s29QGlQTPiNGQatulLGCzCosH/H7PVF27RRhQ17o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/262] MIPS: ralink: mt7621: use bitwise NOT instead of logical
Date:   Mon,  7 Mar 2022 10:19:42 +0100
Message-Id: <20220307091710.088685224@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

[ Upstream commit 5d8965704fe5662e2e4a7e4424a2cbe53e182670 ]

It was the intention to reverse the bits, not make them all zero by
using logical NOT operator.

Fixes: cc19db8b312a ("MIPS: ralink: mt7621: do memory detection on KSEG1")
Suggested-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/mt7621.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index fd9a872d5713..4c8378661219 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -38,7 +38,7 @@ static bool __init mt7621_addr_wraparound_test(phys_addr_t size)
 	__raw_writel(MT7621_MEM_TEST_PATTERN, dm);
 	if (__raw_readl(dm) != __raw_readl(dm + size))
 		return false;
-	__raw_writel(!MT7621_MEM_TEST_PATTERN, dm);
+	__raw_writel(~MT7621_MEM_TEST_PATTERN, dm);
 	return __raw_readl(dm) == __raw_readl(dm + size);
 }
 
-- 
2.34.1



