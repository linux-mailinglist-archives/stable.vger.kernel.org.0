Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1302E4123A9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352131AbhITS0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378347AbhITSY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CA9B613A2;
        Mon, 20 Sep 2021 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158702;
        bh=uSCus/CvVsBhDvotbxmndFrZ31G696mSG8Rf+gOHDf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vss0x/P/ffcPzrHY3+Tp5RXJwDKNo8btXhdyTP2Yyd/j4ZBswGXQBmaO/c9CBrxDd
         adYAKLJUsiLC0WB74SAgNd3HMV4Y1sAUJNspCqCA+9r3yjD2wMEPT3T7GCdAl5N+k2
         IzVZ7Q/Yzw14rSLsgadQHbKqsXl5fpjaiwamWEtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.10 017/122] drm/etnaviv: add missing MMU context put when reaping MMU mapping
Date:   Mon, 20 Sep 2021 18:43:09 +0200
Message-Id: <20210920163916.339109430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit f2faea8b64125852fa9acc6771c07fc0311a039b upstream.

When we forcefully evict a mapping from the the address space and thus the
MMU context, the MMU context is leaked, as the mapping no longer points to
it, so it doesn't get freed when the GEM object is destroyed. Add the
mssing context put to fix the leak.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -197,6 +197,7 @@ static int etnaviv_iommu_find_iova(struc
 		 */
 		list_for_each_entry_safe(m, n, &list, scan_node) {
 			etnaviv_iommu_remove_mapping(context, m);
+			etnaviv_iommu_context_put(m->context);
 			m->context = NULL;
 			list_del_init(&m->mmu_node);
 			list_del_init(&m->scan_node);


