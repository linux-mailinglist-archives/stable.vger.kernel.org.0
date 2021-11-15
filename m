Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAA8452441
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242887AbhKPBgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242852AbhKOSq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C8B963392;
        Mon, 15 Nov 2021 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999653;
        bh=Djosf74jsueH7VUcEdzjJ5J+PIfJsUN+bo3L+bf7ndM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnXU7KPQTA3/HAEGTtGpRF9trYsNVuo5rTmpuFbQmbNEcgttALAoJubUSTPp4leXP
         AP/E/sVfmDZT39cqAW5fuuMEQJE7X2lfe0fXDS4uJswkVr/VOS82xMHXkm4rLd2E62
         1TGK/s2ZC91tUWWXeOVxsgFsXss5dkyRwFyAk48A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>,
        Chris Goldsworthy <quic_cgoldswo@quicinc.com>,
        David Hildenbrand <david@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Georgi Djakov <quic_c_gdjako@quicinc.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 375/849] arm64: mm: update max_pfn after memory hotplug
Date:   Mon, 15 Nov 2021 17:57:38 +0100
Message-Id: <20211115165432.917639986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>

[ Upstream commit 8fac67ca236b961b573355e203dbaf62a706a2e5 ]

After new memory blocks have been hotplugged, max_pfn and max_low_pfn
needs updating to reflect on new PFNs being hot added to system.
Without this patch, debug-related functions that use max_pfn such as
get_max_dump_pfn() or read_page_owner() will not work with any page in
memory that is hot-added after boot.

Fixes: 4ab215061554 ("arm64: Add memory hotplug support")
Signed-off-by: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
Signed-off-by: Chris Goldsworthy <quic_cgoldswo@quicinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Georgi Djakov <quic_c_gdjako@quicinc.com>
Tested-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
Link: https://lore.kernel.org/r/a51a27ee7be66024b5ce626310d673f24107bcb8.1632853776.git.quic_cgoldswo@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 9ff0de1b2b93c..90d185853e341 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1499,6 +1499,11 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	if (ret)
 		__remove_pgd_mapping(swapper_pg_dir,
 				     __phys_to_virt(start), size);
+	else {
+		max_pfn = PFN_UP(start + size);
+		max_low_pfn = max_pfn;
+	}
+
 	return ret;
 }
 
-- 
2.33.0



