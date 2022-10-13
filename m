Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551645FCF68
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJMASH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJMARe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:17:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17087197F85;
        Wed, 12 Oct 2022 17:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CE29616B5;
        Thu, 13 Oct 2022 00:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CCAC433C1;
        Thu, 13 Oct 2022 00:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620220;
        bh=SbOlvIFkuyxyhYg20Cv9c7JE7j32qJ/p3yVbNpY/YwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbLOjpX8SwzcE+BmVmRt56gUlrgH5wwO+/yY0wsRQ+jmerL+/vtUN7SEqhAHofLc6
         Lq7ookL6zKZaM9DXlIELbUQiPAakmyW1ioZ07n+tPRiQ80vG5qZwjPhjeYx0xrIGvn
         Sk/pElPPEWFZH++nFjGBQdmpJr+i6R7V01DeDfoiTosvKZk2WlkSIrwoxVeyZDtJx7
         ExRMe9DWMCCclmGGdQozDx9XRLiVwpmoWIt6KZ1oIjhZIADotcKPoIMyNzNCnLjfo9
         pFPajDOmFy3qeylS8PGpM/koNTjnfkaI23+xQR+d2vKM+4hjzBgc9wO8tHGloLroG3
         udQQ3Y2vbB8QA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jackie Liu <liuyun01@kylinos.cn>,
        Genjian Zhang <zhanggenjian@kylinos.cn>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 26/67] nvmet-auth: clean up with done_kfree
Date:   Wed, 12 Oct 2022 20:15:07 -0400
Message-Id: <20221013001554.1892206-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 42147981561c3344d2c6781fe7029e5900daa9fb ]

Jump directly to done_kfree to release d, which is consistent with the
code style behind.

Reported-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index ebdf9aa81041..8458ec40340b 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -229,10 +229,8 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	}
 
 	status = nvmet_copy_from_sgl(req, 0, d, tl);
-	if (status) {
-		kfree(d);
-		goto done;
-	}
+	if (status)
+		goto done_kfree;
 
 	data = d;
 	pr_debug("%s: ctrl %d qid %d type %d id %d step %x\n", __func__,
-- 
2.35.1

