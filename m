Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2E629C338
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760028AbgJ0ObQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902176AbgJ0ObN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC3820754;
        Tue, 27 Oct 2020 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809072;
        bh=lcte25DQ0I5zKue9ZIyN70bxF85x8e2iVDHlwfavOmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIUn/05vrv5AHjcY7aCT9ifNmorLk4kBbRPxt23wWMXhM/6eCXpMy9eKviOzuIKRP
         W94kmwAzH58dixID/Kvulc5IXBYQT9U+vwMPEhXGOhJZRElfDy6rtOMNR1aSvUUlHO
         nb3qBHoFbtkNM1H3laG8QWDO+E8AAucltdWjUBIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/408] x86/events/amd/iommu: Fix sizeof mismatch
Date:   Tue, 27 Oct 2020 14:50:04 +0100
Message-Id: <20201027135458.119233396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index fb616203ce427..be50ef8572cce 100644
--- a/arch/x86/events/amd/iommu.c
+++ b/arch/x86/events/amd/iommu.c
@@ -379,7 +379,7 @@ static __init int _init_events_attrs(void)
 	while (amd_iommu_v2_event_descs[i].attr.attr.name)
 		i++;
 
-	attrs = kcalloc(i + 1, sizeof(struct attribute **), GFP_KERNEL);
+	attrs = kcalloc(i + 1, sizeof(*attrs), GFP_KERNEL);
 	if (!attrs)
 		return -ENOMEM;
 
-- 
2.25.1



