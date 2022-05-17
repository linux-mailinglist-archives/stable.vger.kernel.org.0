Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2760529E98
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 11:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbiEQJ67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 05:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243178AbiEQJ6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 05:58:38 -0400
X-Greylist: delayed 131 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 02:58:25 PDT
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B11A43394;
        Tue, 17 May 2022 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=RGaHmVYObVzH+m7sYp
        QCxzcT7fn0h4cxILJiyo027rw=; b=H311eSeFVeS7yQZ7Yxaem9vUXiKucTs9MU
        lufXYklFJVA4BoUEUfTt/9Tgj/Hw/QBdh4SinvpRG6UqDPTsXxwhoAf6kdmiGy6X
        YDcwYazkr0iBNtsVExdU5Rc4T8kKBnWvwwqZqjz5WAZ0PXqktQVmq8rCsEB8dxMF
        Zv+GX4lnY=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp7 (Coremail) with SMTP id C8CowAAXIJObcYNi42D3Cw--.59736S4;
        Tue, 17 May 2022 17:57:57 +0800 (CST)
From:   Yuanjun Gong <ruc_gongyuanjun@163.com>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>,
        Evan Quan <evan.quan@amd.com>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] drm/amd/pm: fix a potential gpu_metrics_table memory leak
Date:   Tue, 17 May 2022 17:57:46 +0800
Message-Id: <20220517095746.7537-1-ruc_gongyuanjun@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowAAXIJObcYNi42D3Cw--.59736S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruFW7tFW7KFWxZw1DZF4xWFg_yoWftrc_Gr
        y8Xwn3Z3sxCF1vyrWrZFs8ZFyYkF15CF4kJFnYg390vr17XFy3Za9FqF1kua18CF1UZFWD
        XF1kXF98CrZrJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNJ5rUUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: 5uxfsw5rqj53pdqm30i6rwjhhfrp/xtbB6BUE5WBHIt94LQAAsT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gong Yuanjun <ruc_gongyuanjun@163.com>

gpu_metrics_table is allocated in yellow_carp_init_smc_tables() but
not freed in yellow_carp_fini_smc_tables().

Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index e2d099409123..c66c39ccf19c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -190,6 +190,9 @@ static int yellow_carp_fini_smc_tables(struct smu_context *smu)
 	kfree(smu_table->watermarks_table);
 	smu_table->watermarks_table = NULL;
 
+	kfree(smu_table->gpu_metrics_table);
+	smu_table->gpu_metrics_table = NULL;
+
 	return 0;
 }
 
-- 
2.17.1

