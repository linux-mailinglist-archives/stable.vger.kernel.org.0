Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F829404DE3
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243430AbhIIMHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345027AbhIIMC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 855BC604D2;
        Thu,  9 Sep 2021 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187999;
        bh=XGXIMPjk5VgGI7sWbMyUjW+BEVGq6scPTOraEgj3xIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1HIibiCj5Vt6GJ28roMtrPoLqpRBmFXHzV0QKXxsndp30GRbnohHJPrBKr6ahzqt
         GiCNmwv+n3DCmNFUZWLC9xqnfvFwvLqVQBc5oH9Cx1vDTfNje0SjW+PsLxecBbpSWA
         Y5oxQFSYdglVq/qq7l5MXTTwyhbUsuGOgbM5T9gsJAgPo1RyArG0a2aZN+BRGYENvN
         BUTGo6diMG6Uytb77ylFOGeXKD803CRgMevfEkT5LOHsfLa0DfwaecgVI1kMsXR5Qw
         ACIT5HWKjGZ+nJiUBWto4hY7LWvDls2fz2SeadgH7BnEpRByY2oKcgTtPV3bXrbvnj
         jJk4pN3fYUj9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zack Rusin <zackr@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 002/219] drm/vmwgfx: Fix some static checker warnings
Date:   Thu,  9 Sep 2021 07:42:58 -0400
Message-Id: <20210909114635.143983-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 74231041d14030f1ae6582b9233bfe782ac23e33 ]

Fix some minor issues that Coverity spotted in the code. None
of that are serious but they're all valid concerns so fixing
them makes sense.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210609172307.131929-5-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/ttm_memory.c        |  2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_binding.c    | 20 ++++++++------------
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c     |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c |  4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c    |  2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c        |  4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c        |  6 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |  8 ++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_so.c         |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c |  4 ++--
 10 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/ttm_memory.c b/drivers/gpu/drm/vmwgfx/ttm_memory.c
index aeb0a22a2c34..edd17c30d5a5 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_memory.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_memory.c
@@ -435,8 +435,10 @@ int ttm_mem_global_init(struct ttm_mem_global *glob, struct device *dev)
 
 	si_meminfo(&si);
 
+	spin_lock(&glob->lock);
 	/* set it as 0 by default to keep original behavior of OOM */
 	glob->lower_mem_limit = 0;
+	spin_unlock(&glob->lock);
 
 	ret = ttm_mem_init_kernel_zone(glob, &si);
 	if (unlikely(ret != 0))
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c b/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
index 81f525a82b77..4e7de45407c8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
@@ -715,7 +715,7 @@ static int vmw_binding_scrub_cb(struct vmw_ctx_bindinfo *bi, bool rebind)
  * without checking which bindings actually need to be emitted
  *
  * @cbs: Pointer to the context's struct vmw_ctx_binding_state
- * @bi: Pointer to where the binding info array is stored in @cbs
+ * @biv: Pointer to where the binding info array is stored in @cbs
  * @max_num: Maximum number of entries in the @bi array.
  *
  * Scans the @bi array for bindings and builds a buffer of view id data.
@@ -725,11 +725,9 @@ static int vmw_binding_scrub_cb(struct vmw_ctx_bindinfo *bi, bool rebind)
  * contains the command data.
  */
 static void vmw_collect_view_ids(struct vmw_ctx_binding_state *cbs,
-				 const struct vmw_ctx_bindinfo *bi,
+				 const struct vmw_ctx_bindinfo_view *biv,
 				 u32 max_num)
 {
-	const struct vmw_ctx_bindinfo_view *biv =
-		container_of(bi, struct vmw_ctx_bindinfo_view, bi);
 	unsigned long i;
 
 	cbs->bind_cmd_count = 0;
@@ -838,7 +836,7 @@ static int vmw_emit_set_sr(struct vmw_ctx_binding_state *cbs,
  */
 static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->render_targets[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->render_targets[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetRenderTargets body;
@@ -874,7 +872,7 @@ static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
  * without checking which bindings actually need to be emitted
  *
  * @cbs: Pointer to the context's struct vmw_ctx_binding_state
- * @bi: Pointer to where the binding info array is stored in @cbs
+ * @biso: Pointer to where the binding info array is stored in @cbs
  * @max_num: Maximum number of entries in the @bi array.
  *
  * Scans the @bi array for bindings and builds a buffer of SVGA3dSoTarget data.
@@ -884,11 +882,9 @@ static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
  * contains the command data.
  */
 static void vmw_collect_so_targets(struct vmw_ctx_binding_state *cbs,
-				   const struct vmw_ctx_bindinfo *bi,
+				   const struct vmw_ctx_bindinfo_so_target *biso,
 				   u32 max_num)
 {
-	const struct vmw_ctx_bindinfo_so_target *biso =
-		container_of(bi, struct vmw_ctx_bindinfo_so_target, bi);
 	unsigned long i;
 	SVGA3dSoTarget *so_buffer = (SVGA3dSoTarget *) cbs->bind_cmd_buffer;
 
@@ -919,7 +915,7 @@ static void vmw_collect_so_targets(struct vmw_ctx_binding_state *cbs,
  */
 static int vmw_emit_set_so_target(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->so_targets[0].bi;
+	const struct vmw_ctx_bindinfo_so_target *loc = &cbs->so_targets[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetSOTargets body;
@@ -1066,7 +1062,7 @@ static int vmw_emit_set_vb(struct vmw_ctx_binding_state *cbs)
 
 static int vmw_emit_set_uav(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->ua_views[0].views[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->ua_views[0].views[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetUAViews body;
@@ -1096,7 +1092,7 @@ static int vmw_emit_set_uav(struct vmw_ctx_binding_state *cbs)
 
 static int vmw_emit_set_cs_uav(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->ua_views[1].views[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->ua_views[1].views[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetCSUAViews body;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
index 2e23e537cdf5..dac4624c5dc1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
@@ -516,7 +516,7 @@ static void vmw_cmdbuf_work_func(struct work_struct *work)
 	struct vmw_cmdbuf_man *man =
 		container_of(work, struct vmw_cmdbuf_man, work);
 	struct vmw_cmdbuf_header *entry, *next;
-	uint32_t dummy;
+	uint32_t dummy = 0;
 	bool send_fence = false;
 	struct list_head restart_head[SVGA_CB_CONTEXT_MAX];
 	int i;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
index b262d61d839d..9487faff5229 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
@@ -159,6 +159,7 @@ void vmw_cmdbuf_res_commit(struct list_head *list)
 void vmw_cmdbuf_res_revert(struct list_head *list)
 {
 	struct vmw_cmdbuf_res *entry, *next;
+	int ret;
 
 	list_for_each_entry_safe(entry, next, list, head) {
 		switch (entry->state) {
@@ -166,7 +167,8 @@ void vmw_cmdbuf_res_revert(struct list_head *list)
 			vmw_cmdbuf_res_free(entry->man, entry);
 			break;
 		case VMW_CMDBUF_RES_DEL:
-			drm_ht_insert_item(&entry->man->resources, &entry->hash);
+			ret = drm_ht_insert_item(&entry->man->resources, &entry->hash);
+			BUG_ON(ret);
 			list_del(&entry->head);
 			list_add_tail(&entry->head, &entry->man->list);
 			entry->state = VMW_CMDBUF_RES_COMMITTED;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index d6a6d8a3387a..319ecca5d1cb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2546,6 +2546,8 @@ static int vmw_cmd_dx_so_define(struct vmw_private *dev_priv,
 
 	so_type = vmw_so_cmd_to_type(header->id);
 	res = vmw_context_cotable(ctx_node->ctx, vmw_so_cotables[so_type]);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 	cmd = container_of(header, typeof(*cmd), header);
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
index f2d625415458..2d8caf09f172 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -506,11 +506,13 @@ static void vmw_mob_pt_setup(struct vmw_mob *mob,
 {
 	unsigned long num_pt_pages = 0;
 	struct ttm_buffer_object *bo = mob->pt_bo;
-	struct vmw_piter save_pt_iter;
+	struct vmw_piter save_pt_iter = {0};
 	struct vmw_piter pt_iter;
 	const struct vmw_sg_table *vsgt;
 	int ret;
 
+	BUG_ON(num_data_pages == 0);
+
 	ret = ttm_bo_reserve(bo, false, true, NULL);
 	BUG_ON(ret != 0);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 609269625468..e90fd3d16697 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -154,6 +154,7 @@ static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
 	/* HB port can't access encrypted memory. */
 	if (hb && !mem_encrypt_active()) {
 		unsigned long bp = channel->cookie_high;
+		u32 channel_id = (channel->channel_id << 16);
 
 		si = (uintptr_t) msg;
 		di = channel->cookie_low;
@@ -161,7 +162,7 @@ static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
 		VMW_PORT_HB_OUT(
 			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
 			msg_len, si, di,
-			VMWARE_HYPERVISOR_HB | (channel->channel_id << 16) |
+			VMWARE_HYPERVISOR_HB | channel_id |
 			VMWARE_HYPERVISOR_OUT,
 			VMW_HYPERVISOR_MAGIC, bp,
 			eax, ebx, ecx, edx, si, di);
@@ -209,6 +210,7 @@ static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
 	/* HB port can't access encrypted memory */
 	if (hb && !mem_encrypt_active()) {
 		unsigned long bp = channel->cookie_low;
+		u32 channel_id = (channel->channel_id << 16);
 
 		si = channel->cookie_high;
 		di = (uintptr_t) reply;
@@ -216,7 +218,7 @@ static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
 		VMW_PORT_HB_IN(
 			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
 			reply_len, si, di,
-			VMWARE_HYPERVISOR_HB | (channel->channel_id << 16),
+			VMWARE_HYPERVISOR_HB | channel_id,
 			VMW_HYPERVISOR_MAGIC, bp,
 			eax, ebx, ecx, edx, si, di);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 35f02958ee2c..f275a08999ef 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -114,6 +114,7 @@ static void vmw_resource_release(struct kref *kref)
 	    container_of(kref, struct vmw_resource, kref);
 	struct vmw_private *dev_priv = res->dev_priv;
 	int id;
+	int ret;
 	struct idr *idr = &dev_priv->res_idr[res->func->res_type];
 
 	spin_lock(&dev_priv->resource_lock);
@@ -122,7 +123,8 @@ static void vmw_resource_release(struct kref *kref)
 	if (res->backup) {
 		struct ttm_buffer_object *bo = &res->backup->base;
 
-		ttm_bo_reserve(bo, false, false, NULL);
+		ret = ttm_bo_reserve(bo, false, false, NULL);
+		BUG_ON(ret);
 		if (vmw_resource_mob_attached(res) &&
 		    res->func->unbind != NULL) {
 			struct ttm_validate_buffer val_buf;
@@ -1002,7 +1004,9 @@ int vmw_resource_pin(struct vmw_resource *res, bool interruptible)
 		if (res->backup) {
 			vbo = res->backup;
 
-			ttm_bo_reserve(&vbo->base, interruptible, false, NULL);
+			ret = ttm_bo_reserve(&vbo->base, interruptible, false, NULL);
+			if (ret)
+				goto out_no_validate;
 			if (!vbo->base.pin_count) {
 				ret = ttm_bo_validate
 					(&vbo->base,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_so.c b/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
index 2877c7b43bd7..615bf9ca03d7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
@@ -539,7 +539,8 @@ const SVGACOTableType vmw_so_cotables[] = {
 	[vmw_so_ds] = SVGA_COTABLE_DEPTHSTENCIL,
 	[vmw_so_rs] = SVGA_COTABLE_RASTERIZERSTATE,
 	[vmw_so_ss] = SVGA_COTABLE_SAMPLER,
-	[vmw_so_so] = SVGA_COTABLE_STREAMOUTPUT
+	[vmw_so_so] = SVGA_COTABLE_STREAMOUTPUT,
+	[vmw_so_max]= SVGA_COTABLE_MAX
 };
 
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
index e7570f422400..bf20ca9f3a24 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -586,13 +586,13 @@ int vmw_validation_bo_validate(struct vmw_validation_context *ctx, bool intr)
 			container_of(entry->base.bo, typeof(*vbo), base);
 
 		if (entry->cpu_blit) {
-			struct ttm_operation_ctx ctx = {
+			struct ttm_operation_ctx ttm_ctx = {
 				.interruptible = intr,
 				.no_wait_gpu = false
 			};
 
 			ret = ttm_bo_validate(entry->base.bo,
-					      &vmw_nonfixed_placement, &ctx);
+					      &vmw_nonfixed_placement, &ttm_ctx);
 		} else {
 			ret = vmw_validation_bo_validate_single
 			(entry->base.bo, intr, entry->as_mob);
-- 
2.30.2

