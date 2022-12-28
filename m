Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFECD657826
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiL1OsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiL1Orn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B29E3A8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE1A26153B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF285C433EF;
        Wed, 28 Dec 2022 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238846;
        bh=+/9+k3HOnbZRS0kmOnJiB7eIkfHebWElTNIkgumUp58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poxGp9bLNn/CYKF3orAa7rn+TTNs0Fw5HMLIztly0paN1G+5EElb7E3DQfg1ME5LD
         RA+KazPBYUuWAgTuqRW4J1OBhSmjSE47mkSjEAarxCTFXunNZtVd5xkQvvO7qP2qJ8
         aAZED9wryosFQqR8lWUwq8xeOJUNBIdAjaDfMiSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/731] arm64: mm: kfence: only handle translation faults
Date:   Wed, 28 Dec 2022 15:32:19 +0100
Message-Id: <20221228144257.481469320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 0bb1fbffc631064db567ccaeb9ed6b6df6342b66 ]

Alexander noted that KFENCE only expects to handle faults from invalid page
table entries (i.e. translation faults), but arm64's fault handling logic will
call kfence_handle_page_fault() for other types of faults, including alignment
faults caused by unaligned atomics. This has the unfortunate property of
causing those other faults to be reported as "KFENCE: use-after-free",
which is misleading and hinders debugging.

Fix this by only forwarding unhandled translation faults to the KFENCE
code, similar to what x86 does already.

Alexander has verified that this passes all the tests in the KFENCE test
suite and avoids bogus reports on misaligned atomics.

Link: https://lore.kernel.org/all/20221102081620.1465154-1-zhongbaisong@huawei.com/
Fixes: 840b23986344 ("arm64, kfence: enable KFENCE for ARM64")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221114104411.2853040-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index e38e7dc0f8f5..d09b21faa0b2 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -350,6 +350,11 @@ static bool is_el1_mte_sync_tag_check_fault(unsigned long esr)
 	return false;
 }
 
+static bool is_translation_fault(unsigned long esr)
+{
+	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_FAULT;
+}
+
 static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 			      struct pt_regs *regs)
 {
@@ -382,7 +387,8 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
-		if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
+		if (is_translation_fault(esr) &&
+		    kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
 			return;
 
 		msg = "paging request";
-- 
2.35.1



