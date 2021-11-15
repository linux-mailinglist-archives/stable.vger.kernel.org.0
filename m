Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4179451FAE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353767AbhKPAo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343740AbhKOTV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0411463385;
        Mon, 15 Nov 2021 18:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001931;
        bh=ucQjVbr8ybsf9jj/eP5/L7HbY9Rcy9soWSz3ZBPEyc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bs0fPDKUj9VA9RId6v1yL3syVTH/Ujatq3W37WY9i6QGnm4M/lH77n9a5CK9Wltxn
         G7MbirS8eRzhnFHLa55hOZT1Zl4cVvqMunk1uxc9rd+tsKU+UQJgZKIrU9YPPqDEmV
         hBYay3EGeyosTA2b+u259KTCd5KUzfopF54SBWe8=
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
Subject: [PATCH 5.15 374/917] arm64: mm: update max_pfn after memory hotplug
Date:   Mon, 15 Nov 2021 17:57:49 +0100
Message-Id: <20211115165441.443420977@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index cfd9deb347c38..fd85b51b9d50f 100644
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



