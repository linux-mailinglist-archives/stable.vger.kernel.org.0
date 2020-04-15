Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1C1AA312
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505819AbgDONEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897143AbgDOLg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E76D0208FE;
        Wed, 15 Apr 2020 11:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950584;
        bh=1pQapq9m3603xrXiSN4BF3wGZPcBk5uTiJAJZ3h1E+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3MkuLRURQYK3wsH+aKZbj/stfmM7GbXJu+V6qRGnmTL8hxyj1YCPuhoAwO24IsZ2
         C0uOn9Wcwfh3P+WdRAw318CQ5bxQccLpfHXvXvT7VPnJ0NUmh6psWgfM59XoSSPIew
         OjO2guO7scPxidOXGG09Smd/ikxxeOPf61tzLs9k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 083/129] KVM: s390: vsie: Fix possible race when shadowing region 3 tables
Date:   Wed, 15 Apr 2020 07:33:58 -0400
Message-Id: <20200415113445.11881-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 1493e0f944f3c319d11e067c185c904d01c17ae5 ]

We have to properly retry again by returning -EINVAL immediately in case
somebody else instantiated the table concurrently. We missed to add the
goto in this function only. The code now matches the other, similar
shadowing functions.

We are overwriting an existing region 2 table entry. All allocated pages
are added to the crst_list to be freed later, so they are not lost
forever. However, when unshadowing the region 2 table, we wouldn't trigger
unshadowing of the original shadowed region 3 table that we replaced. It
would get unshadowed when the original region 3 table is modified. As it's
not connected to the page table hierarchy anymore, it's not going to get
used anymore. However, for a limited time, this page table will stick
around, so it's in some sense a temporary memory leak.

Identified by manual code inspection. I don't think this classifies as
stable material.

Fixes: 998f637cc4b9 ("s390/mm: avoid races on region/segment/page table shadowing")
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200403153050.20569-4-david@redhat.com
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index edcdca97e85ee..06d602c5ec7b7 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1840,6 +1840,7 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 		goto out_free;
 	} else if (*table & _REGION_ENTRY_ORIGIN) {
 		rc = -EAGAIN;		/* Race with shadow */
+		goto out_free;
 	}
 	crst_table_init(s_r3t, _REGION3_ENTRY_EMPTY);
 	/* mark as invalid as long as the parent table is not protected */
-- 
2.20.1

