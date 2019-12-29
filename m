Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCE812C88E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbfL2R4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732723AbfL2R4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5198208C4;
        Sun, 29 Dec 2019 17:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642165;
        bh=5pN0LP0+rabHyB/A/H0CgO5PTb6Xqph+/bQbJyuN+a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ4RoMPhQVzIdZeEGKi9uiO6k0mjACyPvA+ddYvX1UuT5a4bmmxdrm4RHszTzfDKH
         n5yS1U/dQCX85vPECnfFbHM/oHFFwhLHbCgI6BIKggNd1GRbzqDOspa7yxqliX+Hh/
         5BAdirXqhaPokGt45syQV13HGU6TFKdilHG0LoYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Qian Cai <cai@lca.pw>, Jerry Snitselaar <jsnitsel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 367/434] iommu: fix KASAN use-after-free in iommu_insert_resv_region
Date:   Sun, 29 Dec 2019 18:27:00 +0100
Message-Id: <20191229172726.351162300@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 4c80ba392bf603d468ea827d902f8e7b2505fbf4 upstream.

In case the new region gets merged into another one, the nr list node is
freed.  Checking its type while completing the merge algorithm leads to
a use-after-free.  Use new->type instead.

Fixes: 4dbd258ff63e ("iommu: Revisit iommu_insert_resv_region() implementation")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Stable <stable@vger.kernel.org> #v5.3+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -312,8 +312,8 @@ int iommu_insert_resv_region(struct iomm
 	list_for_each_entry_safe(iter, tmp, regions, list) {
 		phys_addr_t top_end, iter_end = iter->start + iter->length - 1;
 
-		/* no merge needed on elements of different types than @nr */
-		if (iter->type != nr->type) {
+		/* no merge needed on elements of different types than @new */
+		if (iter->type != new->type) {
 			list_move_tail(&iter->list, &stack);
 			continue;
 		}


