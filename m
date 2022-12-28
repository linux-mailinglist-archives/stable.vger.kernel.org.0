Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8445C657AE5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiL1PQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiL1PQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:16:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6E22655
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:16:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9890461365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE71C433EF;
        Wed, 28 Dec 2022 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240561;
        bh=Hi6BFIMRcUjPEp2sL+IcqtBoaRRu7/3k8oGvrd7hHKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaZTCZ/Ab/YSITpNp5vz5GqUSul/NJUpQ67DkzI6oFzg4hkUR3jk1eNPLIDhEzOuG
         OA9LATOruzbqNtWd4O4v2PVPpXiMOkE8nivtX1HdXRk3+vGZZbVwUEIqhXHWsCXK1o
         jQw2TpLvdHG1oOnyNf/vECm81LQntliXe36yxN8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leon Romanovsky <leonro@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/731] RDMA/core: Fix order of nldev_exit call
Date:   Wed, 28 Dec 2022 15:37:54 +0100
Message-Id: <20221228144307.199336345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 4508d32ccced24c972bc4592104513e1ff8439b5 ]

Create symmetrical exit flow by calling to nldev_exit() after
call to rdma_nl_unregister(RDMA_NL_LS).

Fixes: 6c80b41abe22 ("RDMA/netlink: Add nldev initialization flows")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/64e676774a53a406f4cde265d5a4cfd6b8e97df9.1666683334.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 1519379b116e..ab2106a09f9c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2848,8 +2848,8 @@ static int __init ib_core_init(void)
 static void __exit ib_core_cleanup(void)
 {
 	roce_gid_mgmt_cleanup();
-	nldev_exit();
 	rdma_nl_unregister(RDMA_NL_LS);
+	nldev_exit();
 	unregister_pernet_device(&rdma_dev_net_ops);
 	unregister_blocking_lsm_notifier(&ibdev_lsm_nb);
 	ib_sa_cleanup();
-- 
2.35.1



