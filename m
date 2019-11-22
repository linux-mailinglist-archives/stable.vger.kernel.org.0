Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9553A10633E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfKVGJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbfKVF5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E59E2072E;
        Fri, 22 Nov 2019 05:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402231;
        bh=ezfUYjhGPrhOaDVH+CHLGp4YuChOzTj0T9Bq3EJZaO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFHVKiwher75LG5cgrocvYedqVPJuEu7UCm/O5C7PjWXHkWyQrHf5ZnaeJBHwX/Wi
         MTk4e3GyYbziZ3RrZWY/5LVq2g2XJIc/t+HKLWWbaVTDELTU/6zezypIlRxYuIruAU
         jyXK5q0q+mzxPhB2ozKQjtrVD0qzi4hYZJJS7n9E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 077/127] powerpc/pseries: Fix node leak in update_lmb_associativity_index()
Date:   Fri, 22 Nov 2019 00:54:55 -0500
Message-Id: <20191122055544.3299-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 47918bc68b7427e961035949cc1501a864578a69 ]

In update_lmb_associativity_index() we lookup dr_node using
of_find_node_by_path() which takes a reference for us. In the
non-error case we forget to drop the reference. Note that
find_aa_index() does modify properties of the node, but doesn't need
an extra reference held once it's returned.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 93e09f108ca17..b40798c878259 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -295,6 +295,7 @@ static u32 lookup_lmb_associativity_index(struct of_drconf_cell *lmb)
 
 	aa_index = find_aa_index(dr_node, ala_prop, lmb_assoc);
 
+	of_node_put(dr_node);
 	dlpar_free_cc_nodes(lmb_node);
 	return aa_index;
 }
-- 
2.20.1

