Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CF4330194
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCGN6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhCGN6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CA3B65104;
        Sun,  7 Mar 2021 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125480;
        bh=pKcDvcotxMsrf4+LbrNUXwH0PrbogRxGiMwa+d+u244=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDhKoToTvVRhqNArgx+YyL8aOifoyfBFKwxE8bOZIxxBpZY72BiOYJuwgx5DmMLfK
         RxiOsaRt+uT7S++V35zzWi+vuD5SV5d0eJ30y9pijiDxKM7fd1aWIHVI06ebedBnYD
         1K4H0nW5UK58ux433dpWqNlAEgtNPkyA9xrKgCXphpOrPpNH0Kw/mCWGNiB6/tD2Ec
         pjDKPxfNHQQXZC256cIMU91rPwXT/ZrFMH2oiMofLrjMIa2UpiMoXn7UZqWeKm6LSf
         MJFb81k7A4jUEwGnkGZcZ6A1Gl19i89SS2OU2Iggbb1x2uB59Cn5QhjNuf3HGKTHg5
         3Ks0LydNHupbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 12/12] nvmet: model_number must be immutable once set
Date:   Sun,  7 Mar 2021 08:57:46 -0500
Message-Id: <20210307135746.967418-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit d9f273b7585c380d7a10d4b3187ddc2d37f2740b ]

In case we have already established connection to nvmf target, it
shouldn't be allowed to change the model_number. E.g. if someone will
identify ctrl and get model_number of "my_model" later on will change
the model_numbel via configfs to "my_new_model" this will break the NVMe
specification for "Get Log Page – Persistent Event Log" that refers to
Model Number as: "This field contains the same value as reported in the
Model Number field of the Identify Controller data structure, bytes
63:24."

Although it doesn't mentioned explicitly that this field can't be
changed, we can assume it.

So allow setting this field only once: using configfs or in the first
identify ctrl operation.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 36 ++++++++++++++++--------
 drivers/nvme/target/configfs.c  | 50 +++++++++++++++------------------
 drivers/nvme/target/core.c      |  2 +-
 drivers/nvme/target/nvmet.h     |  7 +----
 4 files changed, 50 insertions(+), 45 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 1827d8d8f3b0..44d6d9f419d0 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -319,27 +319,40 @@ static void nvmet_execute_get_log_page(struct nvmet_req *req)
 	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
 }
 
-static void nvmet_id_set_model_number(struct nvme_id_ctrl *id,
-				      struct nvmet_subsys *subsys)
+static u16 nvmet_set_model_number(struct nvmet_subsys *subsys)
 {
-	const char *model = NVMET_DEFAULT_CTRL_MODEL;
-	struct nvmet_subsys_model *subsys_model;
+	u16 status = 0;
+
+	mutex_lock(&subsys->lock);
+	if (!subsys->model_number) {
+		subsys->model_number =
+			kstrdup(NVMET_DEFAULT_CTRL_MODEL, GFP_KERNEL);
+		if (!subsys->model_number)
+			status = NVME_SC_INTERNAL;
+	}
+	mutex_unlock(&subsys->lock);
 
-	rcu_read_lock();
-	subsys_model = rcu_dereference(subsys->model);
-	if (subsys_model)
-		model = subsys_model->number;
-	memcpy_and_pad(id->mn, sizeof(id->mn), model, strlen(model), ' ');
-	rcu_read_unlock();
+	return status;
 }
 
 static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	struct nvmet_subsys *subsys = ctrl->subsys;
 	struct nvme_id_ctrl *id;
 	u32 cmd_capsule_size;
 	u16 status = 0;
 
+	/*
+	 * If there is no model number yet, set it now.  It will then remain
+	 * stable for the life time of the subsystem.
+	 */
+	if (!subsys->model_number) {
+		status = nvmet_set_model_number(subsys);
+		if (status)
+			goto out;
+	}
+
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (!id) {
 		status = NVME_SC_INTERNAL;
@@ -353,7 +366,8 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	memset(id->sn, ' ', sizeof(id->sn));
 	bin2hex(id->sn, &ctrl->subsys->serial,
 		min(sizeof(ctrl->subsys->serial), sizeof(id->sn) / 2));
-	nvmet_id_set_model_number(id, ctrl->subsys);
+	memcpy_and_pad(id->mn, sizeof(id->mn), subsys->model_number,
+		       strlen(subsys->model_number), ' ');
 	memcpy_and_pad(id->fr, sizeof(id->fr),
 		       UTS_RELEASE, strlen(UTS_RELEASE), ' ');
 
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index c61ffd767062..4b809fe499c2 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1120,16 +1120,12 @@ static ssize_t nvmet_subsys_attr_model_show(struct config_item *item,
 					    char *page)
 {
 	struct nvmet_subsys *subsys = to_subsys(item);
-	struct nvmet_subsys_model *subsys_model;
-	char *model = NVMET_DEFAULT_CTRL_MODEL;
 	int ret;
 
-	rcu_read_lock();
-	subsys_model = rcu_dereference(subsys->model);
-	if (subsys_model)
-		model = subsys_model->number;
-	ret = snprintf(page, PAGE_SIZE, "%s\n", model);
-	rcu_read_unlock();
+	mutex_lock(&subsys->lock);
+	ret = snprintf(page, PAGE_SIZE, "%s\n", subsys->model_number ?
+			subsys->model_number : NVMET_DEFAULT_CTRL_MODEL);
+	mutex_unlock(&subsys->lock);
 
 	return ret;
 }
@@ -1140,14 +1136,17 @@ static bool nvmet_is_ascii(const char c)
 	return c >= 0x20 && c <= 0x7e;
 }
 
-static ssize_t nvmet_subsys_attr_model_store(struct config_item *item,
-					     const char *page, size_t count)
+static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
+		const char *page, size_t count)
 {
-	struct nvmet_subsys *subsys = to_subsys(item);
-	struct nvmet_subsys_model *new_model;
-	char *new_model_number;
 	int pos = 0, len;
 
+	if (subsys->model_number) {
+		pr_err("Can't set model number. %s is already assigned\n",
+		       subsys->model_number);
+		return -EINVAL;
+	}
+
 	len = strcspn(page, "\n");
 	if (!len)
 		return -EINVAL;
@@ -1157,28 +1156,25 @@ static ssize_t nvmet_subsys_attr_model_store(struct config_item *item,
 			return -EINVAL;
 	}
 
-	new_model_number = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!new_model_number)
+	subsys->model_number = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!subsys->model_number)
 		return -ENOMEM;
+	return count;
+}
 
-	new_model = kzalloc(sizeof(*new_model) + len + 1, GFP_KERNEL);
-	if (!new_model) {
-		kfree(new_model_number);
-		return -ENOMEM;
-	}
-	memcpy(new_model->number, new_model_number, len);
+static ssize_t nvmet_subsys_attr_model_store(struct config_item *item,
+					     const char *page, size_t count)
+{
+	struct nvmet_subsys *subsys = to_subsys(item);
+	ssize_t ret;
 
 	down_write(&nvmet_config_sem);
 	mutex_lock(&subsys->lock);
-	new_model = rcu_replace_pointer(subsys->model, new_model,
-					mutex_is_locked(&subsys->lock));
+	ret = nvmet_subsys_attr_model_store_locked(subsys, page, count);
 	mutex_unlock(&subsys->lock);
 	up_write(&nvmet_config_sem);
 
-	kfree_rcu(new_model, rcuhead);
-	kfree(new_model_number);
-
-	return count;
+	return ret;
 }
 CONFIGFS_ATTR(nvmet_subsys_, attr_model);
 
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 8ce4d59cc9e7..c7af907912f2 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1521,7 +1521,7 @@ static void nvmet_subsys_free(struct kref *ref)
 	nvmet_passthru_subsys_free(subsys);
 
 	kfree(subsys->subsysnqn);
-	kfree_rcu(subsys->model, rcuhead);
+	kfree(subsys->model_number);
 	kfree(subsys);
 }
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 592763732065..aac741bf378c 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -208,11 +208,6 @@ struct nvmet_ctrl {
 	bool			pi_support;
 };
 
-struct nvmet_subsys_model {
-	struct rcu_head		rcuhead;
-	char			number[];
-};
-
 struct nvmet_subsys {
 	enum nvme_subsys_type	type;
 
@@ -242,7 +237,7 @@ struct nvmet_subsys {
 	struct config_group	namespaces_group;
 	struct config_group	allowed_hosts_group;
 
-	struct nvmet_subsys_model	__rcu *model;
+	char			*model_number;
 
 #ifdef CONFIG_NVME_TARGET_PASSTHRU
 	struct nvme_ctrl	*passthru_ctrl;
-- 
2.30.1

