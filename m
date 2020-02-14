Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31A815E4DC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404672AbgBNQX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405651AbgBNQX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 031C624764;
        Fri, 14 Feb 2020 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697407;
        bh=1ncGh5Rk9EITS77TL+pGGDb/7PSP3K5PnHevgyuW3vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXyy75tlWb4pnMA1c92ToC5bR3NYo+eAeCS8K4KAPQPJaxOHD14yqM48oBr+equjO
         gUfCH3ZnPlPQ8taaveNVciUWV9B0RODknRAN6l7k5DeGWMYHY8jHkaqsg9DnlOMEeu
         nkTN7x+IBgAY+VivpCoLRx+l3N/WvAOIH0UY82/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 100/141] drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add
Date:   Fri, 14 Feb 2020 11:20:40 -0500
Message-Id: <20200214162122.19794-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 40efb09a7f53125719e49864da008495e39aaa1e ]

In vmw_cmdbuf_res_add if drm_ht_insert_item fails the allocated memory
for cres should be released.

Fixes: 18e4a4669c50 ("drm/vmwgfx: Fix compat shader namespace")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
index 1f013d45c9e9a..0c7c3005594cc 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
@@ -210,8 +210,10 @@ int vmw_cmdbuf_res_add(struct vmw_cmdbuf_res_manager *man,
 
 	cres->hash.key = user_key | (res_type << 24);
 	ret = drm_ht_insert_item(&man->resources, &cres->hash);
-	if (unlikely(ret != 0))
+	if (unlikely(ret != 0)) {
+		kfree(cres);
 		goto out_invalid_key;
+	}
 
 	cres->state = VMW_CMDBUF_RES_ADD;
 	cres->res = vmw_resource_reference(res);
-- 
2.20.1

