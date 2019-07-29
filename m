Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E28796E0
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390947AbfG2T4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404323AbfG2T4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:56:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 213F0204EC;
        Mon, 29 Jul 2019 19:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430175;
        bh=QokPj/8tokDdsipMSdBPf+71ZL0m1+BCD/04tFVb1S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQJrTs6Voxio6Wj85KZGe+suOLiesExpGV8tKZ9tdr91RFdoQg9WWGz5x16oJkxck
         vRuLqg9bt0Vfcg6iSZjfQqBxykljzzvbZN+oJhkzVWAfQvbsk6Q8Et8Nw9RGB7LTq9
         Li3XIk8SzsHp6AoKo2VNcWPlJX4LsAlS4ta51ZmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.2 204/215] iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA
Date:   Mon, 29 Jul 2019 21:23:20 +0200
Message-Id: <20190729190815.448954818@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 201c1db90cd643282185a00770f12f95da330eca upstream.

The stub function for !CONFIG_IOMMU_IOVA needs to be
'static inline'.

Fixes: effa467870c76 ('iommu/vt-d: Don't queue_iova() if there is no flush queue')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/iova.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -236,7 +236,7 @@ static inline void init_iova_domain(stru
 {
 }
 
-bool has_iova_flush_queue(struct iova_domain *iovad)
+static inline bool has_iova_flush_queue(struct iova_domain *iovad)
 {
 	return false;
 }


