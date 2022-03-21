Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F164E2A2B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349049AbiCUOOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349611AbiCUOId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE411E3D5;
        Mon, 21 Mar 2022 07:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09ED6132C;
        Mon, 21 Mar 2022 14:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FB3C340E8;
        Mon, 21 Mar 2022 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871386;
        bh=0uBFwo4dObKSt47frABjkpdhEbOqAtuJ8KAHkE6jSiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1iP2CjETf7WNqkuc+dPiwt56VxJT0LQLk04SRmMFo856iceBongTS9NQWxDHEKFM
         JfVbFRwZ3CkoFyIVZsMTIhLjfyz3kwy+3sPVr01sv06hNzdqVcBXWbv9DV3JEyyA/D
         Bs2rFX9LkRYV0LfWv+dJCZJSnIAYm+IWrxgAleC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 12/37] nvmet: revert "nvmet: make discovery NQN configurable"
Date:   Mon, 21 Mar 2022 14:52:54 +0100
Message-Id: <20220321133221.650869844@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 0c48645a7f3988a624767d025fa3275ae24b6ca1 ]

Revert commit 626851e9225d ("nvmet: make discovery NQN configurable");
the interface was deemed incorrect and will be replaced with a different
one.

Fixes: 626851e9225d ("nvmet: make discovery NQN configurable")
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 39 ----------------------------------
 drivers/nvme/target/core.c     |  3 +--
 2 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 091a0ca16361..496d775c6770 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1233,44 +1233,6 @@ static ssize_t nvmet_subsys_attr_model_store(struct config_item *item,
 }
 CONFIGFS_ATTR(nvmet_subsys_, attr_model);
 
-static ssize_t nvmet_subsys_attr_discovery_nqn_show(struct config_item *item,
-			char *page)
-{
-	return snprintf(page, PAGE_SIZE, "%s\n",
-			nvmet_disc_subsys->subsysnqn);
-}
-
-static ssize_t nvmet_subsys_attr_discovery_nqn_store(struct config_item *item,
-			const char *page, size_t count)
-{
-	struct nvmet_subsys *subsys = to_subsys(item);
-	char *subsysnqn;
-	int len;
-
-	len = strcspn(page, "\n");
-	if (!len)
-		return -EINVAL;
-
-	subsysnqn = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!subsysnqn)
-		return -ENOMEM;
-
-	/*
-	 * The discovery NQN must be different from subsystem NQN.
-	 */
-	if (!strcmp(subsysnqn, subsys->subsysnqn)) {
-		kfree(subsysnqn);
-		return -EBUSY;
-	}
-	down_write(&nvmet_config_sem);
-	kfree(nvmet_disc_subsys->subsysnqn);
-	nvmet_disc_subsys->subsysnqn = subsysnqn;
-	up_write(&nvmet_config_sem);
-
-	return count;
-}
-CONFIGFS_ATTR(nvmet_subsys_, attr_discovery_nqn);
-
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static ssize_t nvmet_subsys_attr_pi_enable_show(struct config_item *item,
 						char *page)
@@ -1300,7 +1262,6 @@ static struct configfs_attribute *nvmet_subsys_attrs[] = {
 	&nvmet_subsys_attr_attr_cntlid_min,
 	&nvmet_subsys_attr_attr_cntlid_max,
 	&nvmet_subsys_attr_attr_model,
-	&nvmet_subsys_attr_attr_discovery_nqn,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	&nvmet_subsys_attr_attr_pi_enable,
 #endif
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 5119c687de68..626caf6f1e4b 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1493,8 +1493,7 @@ static struct nvmet_subsys *nvmet_find_get_subsys(struct nvmet_port *port,
 	if (!port)
 		return NULL;
 
-	if (!strcmp(NVME_DISC_SUBSYS_NAME, subsysnqn) ||
-	    !strcmp(nvmet_disc_subsys->subsysnqn, subsysnqn)) {
+	if (!strcmp(NVME_DISC_SUBSYS_NAME, subsysnqn)) {
 		if (!kref_get_unless_zero(&nvmet_disc_subsys->ref))
 			return NULL;
 		return nvmet_disc_subsys;
-- 
2.34.1



