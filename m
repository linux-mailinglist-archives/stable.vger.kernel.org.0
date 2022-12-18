Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B499565002C
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLRQKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiLRQKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:10:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F04C777;
        Sun, 18 Dec 2022 08:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71FC960DCF;
        Sun, 18 Dec 2022 16:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A19C433F1;
        Sun, 18 Dec 2022 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379488;
        bh=payr6Zz9b7V+tYyl8ijR5b+RPG29xwu55hsg8ntU0cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plYfwaYejzj2vDU+Vhf0yDBM/QTRYwbsOP00QSb+8khbStGfRD2fDhL6eSahg+Pft
         VuQDpGF5A37zUaMfsHLM5b9k1aDSzhUxxSnKob7wPHOAPinjM2hqa0WX1RkEMOGqVf
         ibV/ZNxe3dNAySCO9HO6YStQtH16R4z7PaF/Ouy2ohKZyQphrQ9FfA4lwg6JSf4oZu
         QkZ2twRYixjUmbkfLvDZf5CZnHZVLoja7d2s5zX1ggb/m/BlcWXMi19lVmjq5sHCrW
         TxnQpSeRJt0PhiSgx6yBydPinqRUjeWnv8vfzrTNJcItdUyScpzNG6MlfW2sVzmIip
         Ldt/BmjJW6RhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 47/85] nvme-auth: don't override ctrl keys before validation
Date:   Sun, 18 Dec 2022 11:01:04 -0500
Message-Id: <20221218160142.925394-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 01604350e14560d4d69323eb1ba12a257a643ea8 ]

Replace ctrl ctrl_key/host_key only after nvme_auth_generate_key is successful.
Also, this fixes a bug where the keys are leaked.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7e3893d06bab..c69dcc0e3d67 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3745,13 +3745,17 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
 	memcpy(dhchap_secret, buf, count);
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_secret)) {
+		struct nvme_dhchap_key *key, *host_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->host_key);
+		ret = nvme_auth_generate_key(dhchap_secret, &key);
 		if (ret)
 			return ret;
 		kfree(opts->dhchap_secret);
 		opts->dhchap_secret = dhchap_secret;
+		host_key = ctrl->host_key;
+		ctrl->host_key = key;
+		nvme_auth_free_key(host_key);
 		/* Key has changed; re-authentication with new key */
 		nvme_auth_reset(ctrl);
 	}
@@ -3795,13 +3799,17 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	memcpy(dhchap_secret, buf, count);
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_ctrl_secret)) {
+		struct nvme_dhchap_key *key, *ctrl_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->ctrl_key);
+		ret = nvme_auth_generate_key(dhchap_secret, &key);
 		if (ret)
 			return ret;
 		kfree(opts->dhchap_ctrl_secret);
 		opts->dhchap_ctrl_secret = dhchap_secret;
+		ctrl_key = ctrl->ctrl_key;
+		ctrl->ctrl_key = key;
+		nvme_auth_free_key(ctrl_key);
 		/* Key has changed; re-authentication with new key */
 		nvme_auth_reset(ctrl);
 	}
-- 
2.35.1

