Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22434122F1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377065AbhITSTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358712AbhITSQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F1A6329A;
        Mon, 20 Sep 2021 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158547;
        bh=6MefaOf4cg6HZEJQSL27gcWoBuJDG1ar9t4LMs4Akfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRKGqy7Y37p9lF8o+35Z1sOtLeSyDUPE2sH4aC2+2s0eK2SXZefH7mUJV2HphDewZ
         fa3AaSPP7+HfAF6f9zIAgjD5xbRRfr9IiiYXJNfF/ennKQnD4xP1FlBG0cJQMXAG78
         Fy1MN5mrwJnuddVdee+GLi1usyEv3GPF0KUI0n4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.4 206/260] drm/etnaviv: add missing MMU context put when reaping MMU mapping
Date:   Mon, 20 Sep 2021 18:43:44 +0200
Message-Id: <20210920163938.109342919@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -204,6 +204,7 @@ static int etnaviv_iommu_find_iova(struc
 		 */
 		list_for_each_entry_safe(m, n, &list, scan_node) {
 			etnaviv_iommu_remove_mapping(context, m);
+			etnaviv_iommu_context_put(m->context);
 			m->context = NULL;
 			list_del_init(&m->mmu_node);
 			list_del_init(&m->scan_node);


