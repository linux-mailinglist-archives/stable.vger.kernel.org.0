Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4D29B053
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901062AbgJ0OSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901057AbgJ0OSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:18:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 987C4206FA;
        Tue, 27 Oct 2020 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808297;
        bh=9FL28y9L/BHlBLdFXtlAauyOjWB9+L7MtfeEro2jJ9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cc1wzWg0pOS5DKS6Zmb+XqP/T/ctv0/E4RZer3j01PlaNI1PJzJXeA5Bpt0zm1+nv
         S44xY0KEopNKJffS6+J4eXKE2Hi2D6mCDvSXB2RGJMxgcxEbnC956eidAL0OF6Y4i8
         UG3Gv7NzdMcXeSVYQXndU4Jk04SiJLWUyKAeRgL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/264] x86/events/amd/iommu: Fix sizeof mismatch
Date:   Tue, 27 Oct 2020 14:51:36 +0100
Message-Id: <20201027135432.454999907@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 59d5396a4666195f89a67e118e9e627ddd6f53a1 ]

An incorrect sizeof is being used, struct attribute ** is not correct,
it should be struct attribute *. Note that since ** is the same size as
* this is not causing any issues.  Improve this fix by using sizeof(*attrs)
as this allows us to not even reference the type of the pointer.

Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
Fixes: 51686546304f ("x86/events/amd/iommu: Fix sysfs perf attribute groups")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201001113900.58889-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/iommu.c b/arch/x86/events/amd/iommu.c
index 3210fee27e7f9..0014d26391fa6 100644
--- a/arch/x86/events/amd/iommu.c
+++ b/arch/x86/events/amd/iommu.c
@@ -387,7 +387,7 @@ static __init int _init_events_attrs(void)
 	while (amd_iommu_v2_event_descs[i].attr.attr.name)
 		i++;
 
-	attrs = kcalloc(i + 1, sizeof(struct attribute **), GFP_KERNEL);
+	attrs = kcalloc(i + 1, sizeof(*attrs), GFP_KERNEL);
 	if (!attrs)
 		return -ENOMEM;
 
-- 
2.25.1



