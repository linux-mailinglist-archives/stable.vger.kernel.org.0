Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA2840DF3D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhIPQHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233137AbhIPQHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E4961251;
        Thu, 16 Sep 2021 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808360;
        bh=QY6MBd25QKZiu36ewlOr0ps4BMJR4Qlho/OjIvbK2xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=begjlYQoR+5i0D31R1nskgEjP3d6/OhvDpxvRDXPVKjbKOcbadJsq0y4BlmFCsU4Z
         rKMME8nt+4/xdl/1WJBrrLr/En46yGHOIKIlfGkQPJ+DnNfIMjaNxfa53m9kfrsJpO
         91sqZDw+QeowyY0iqQtjQVD1jCLxUKcg8MFl5pdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/306] RDMA/iwcm: Release resources if iw_cm module initialization fails
Date:   Thu, 16 Sep 2021 17:56:46 +0200
Message-Id: <20210916155756.027920734@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e677b72a0647249370f2635862bf0241c86f66ad ]

The failure during iw_cm module initialization partially left the system
with unreleased memory and other resources. Rewrite the module init/exit
routines in such way that netlink commands will be opened only after
successful initialization.

Fixes: b493d91d333e ("iwcm: common code for port mapper")
Link: https://lore.kernel.org/r/b01239f99cb1a3e6d2b0694c242d89e6410bcd93.1627048781.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/iwcm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index da8adadf4755..75b6da00065a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1187,29 +1187,34 @@ static int __init iw_cm_init(void)
 
 	ret = iwpm_init(RDMA_NL_IWCM);
 	if (ret)
-		pr_err("iw_cm: couldn't init iwpm\n");
-	else
-		rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
+		return ret;
+
 	iwcm_wq = alloc_ordered_workqueue("iw_cm_wq", 0);
 	if (!iwcm_wq)
-		return -ENOMEM;
+		goto err_alloc;
 
 	iwcm_ctl_table_hdr = register_net_sysctl(&init_net, "net/iw_cm",
 						 iwcm_ctl_table);
 	if (!iwcm_ctl_table_hdr) {
 		pr_err("iw_cm: couldn't register sysctl paths\n");
-		destroy_workqueue(iwcm_wq);
-		return -ENOMEM;
+		goto err_sysctl;
 	}
 
+	rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
 	return 0;
+
+err_sysctl:
+	destroy_workqueue(iwcm_wq);
+err_alloc:
+	iwpm_exit(RDMA_NL_IWCM);
+	return -ENOMEM;
 }
 
 static void __exit iw_cm_cleanup(void)
 {
+	rdma_nl_unregister(RDMA_NL_IWCM);
 	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
-	rdma_nl_unregister(RDMA_NL_IWCM);
 	iwpm_exit(RDMA_NL_IWCM);
 }
 
-- 
2.30.2



