Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C066198FD8
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgCaJGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731055AbgCaJGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:06:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A6320675;
        Tue, 31 Mar 2020 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645602;
        bh=CzooAaftlavTbOqyUjLGDWwIFSY/farNaexwMre5f40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpWqrsQnrZCRtcflrKH7DqW27mw7LLkEyAOULFmtaz3jGau7WP6gNPe5u5jd/8LvG
         rj7NsRLtY5/UoH0XgVWWQ5BqJhvnV/5BCq173UZk+TPO8pez4sOH0YF6q7dHSXOK2t
         r2PtZRw9qdQ+x0fGgQQWoustMA1unm/TdqFa54lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shane Francis <bigbeeshane@gmail.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 103/170] drm/prime: use dma length macro when mapping sg
Date:   Tue, 31 Mar 2020 10:58:37 +0200
Message-Id: <20200331085435.153059838@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shane Francis <bigbeeshane@gmail.com>

commit 42e67b479eab6d26459b80b4867298232b0435e7 upstream.

As dma_map_sg can reorganize scatter-gather lists in a
way that can cause some later segments to be empty we should
always use the sg_dma_len macro to fetch the actual length.

This could now be 0 and not need to be mapped to a page or
address array

Fixes: be62dbf554c5 ("iommu/amd: Convert AMD iommu driver to the dma-iommu api")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206461
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206895
Bug: https://gitlab.freedesktop.org/drm/amd/issues/1056
Signed-off-by: Shane Francis <bigbeeshane@gmail.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200325090741.21957-2-bigbeeshane@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_prime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -964,7 +964,7 @@ int drm_prime_sg_to_page_addr_arrays(str
 
 	index = 0;
 	for_each_sg(sgt->sgl, sg, sgt->nents, count) {
-		len = sg->length;
+		len = sg_dma_len(sg);
 		page = sg_page(sg);
 		addr = sg_dma_address(sg);
 


