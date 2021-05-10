Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1F437842C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhEJKu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:32906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhEJKrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8C15613D6;
        Mon, 10 May 2021 10:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643048;
        bh=R7D31y8nsmWI3dFkznXurGDs0a/F7LUElxM14Pt5aEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB6t8+oT/w52O2ESGSqH0dn8ZBpxi1tuBV8K0wDe3RsVd00V5gxtuHOHbOxWaQPxt
         LCbZ8y3oBz9/Mch2SeKp8CtuOvb67j1XUMFoJ3Hjkp9Uy05EnFUbZjYEKdXZQjyps0
         E5Q2fsci4oU5fZdT6xcPW6rauYPIjNPKyFyDBsUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Carsten Haitzler <carsten.haitzler@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/299] drm/komeda: Fix bit check to import to value of proper type
Date:   Mon, 10 May 2021 12:19:12 +0200
Message-Id: <20210510102010.078527836@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carsten Haitzler <carsten.haitzler@arm.com>

[ Upstream commit be3e477effba636ad25dcd244db264c6cd5c1f36 ]

KASAN found this problem. find_first_bit() expects to look at a
pointer pointing to a long, but we look at a u32 - this is going to be
an issue with endianness but, KSAN already flags this as out-of-bounds
stack reads. This fixes it by just importing inot a local long.

Signed-off-by: Carsten Haitzler <carsten.haitzler@arm.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201218150812.68195-1-carsten.haitzler@foss.arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/arm/display/include/malidp_utils.h    |  3 ---
 .../drm/arm/display/komeda/komeda_pipeline.c  | 16 +++++++++++-----
 .../display/komeda/komeda_pipeline_state.c    | 19 +++++++++++--------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/include/malidp_utils.h b/drivers/gpu/drm/arm/display/include/malidp_utils.h
index 3bc383d5bf73..49a1d7f3539c 100644
--- a/drivers/gpu/drm/arm/display/include/malidp_utils.h
+++ b/drivers/gpu/drm/arm/display/include/malidp_utils.h
@@ -13,9 +13,6 @@
 #define has_bit(nr, mask)	(BIT(nr) & (mask))
 #define has_bits(bits, mask)	(((bits) & (mask)) == (bits))
 
-#define dp_for_each_set_bit(bit, mask) \
-	for_each_set_bit((bit), ((unsigned long *)&(mask)), sizeof(mask) * 8)
-
 #define dp_wait_cond(__cond, __tries, __min_range, __max_range)	\
 ({							\
 	int num_tries = __tries;			\
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline.c b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline.c
index 452e505a1fd3..79a6339840bb 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline.c
@@ -46,8 +46,9 @@ void komeda_pipeline_destroy(struct komeda_dev *mdev,
 {
 	struct komeda_component *c;
 	int i;
+	unsigned long avail_comps = pipe->avail_comps;
 
-	dp_for_each_set_bit(i, pipe->avail_comps) {
+	for_each_set_bit(i, &avail_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, i);
 		komeda_component_destroy(mdev, c);
 	}
@@ -246,6 +247,7 @@ static void komeda_pipeline_dump(struct komeda_pipeline *pipe)
 {
 	struct komeda_component *c;
 	int id;
+	unsigned long avail_comps = pipe->avail_comps;
 
 	DRM_INFO("Pipeline-%d: n_layers: %d, n_scalers: %d, output: %s.\n",
 		 pipe->id, pipe->n_layers, pipe->n_scalers,
@@ -257,7 +259,7 @@ static void komeda_pipeline_dump(struct komeda_pipeline *pipe)
 		 pipe->of_output_links[1] ?
 		 pipe->of_output_links[1]->full_name : "none");
 
-	dp_for_each_set_bit(id, pipe->avail_comps) {
+	for_each_set_bit(id, &avail_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, id);
 
 		komeda_component_dump(c);
@@ -269,8 +271,9 @@ static void komeda_component_verify_inputs(struct komeda_component *c)
 	struct komeda_pipeline *pipe = c->pipeline;
 	struct komeda_component *input;
 	int id;
+	unsigned long supported_inputs = c->supported_inputs;
 
-	dp_for_each_set_bit(id, c->supported_inputs) {
+	for_each_set_bit(id, &supported_inputs, 32) {
 		input = komeda_pipeline_get_component(pipe, id);
 		if (!input) {
 			c->supported_inputs &= ~(BIT(id));
@@ -301,8 +304,9 @@ static void komeda_pipeline_assemble(struct komeda_pipeline *pipe)
 	struct komeda_component *c;
 	struct komeda_layer *layer;
 	int i, id;
+	unsigned long avail_comps = pipe->avail_comps;
 
-	dp_for_each_set_bit(id, pipe->avail_comps) {
+	for_each_set_bit(id, &avail_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, id);
 		komeda_component_verify_inputs(c);
 	}
@@ -354,13 +358,15 @@ void komeda_pipeline_dump_register(struct komeda_pipeline *pipe,
 {
 	struct komeda_component *c;
 	u32 id;
+	unsigned long avail_comps;
 
 	seq_printf(sf, "\n======== Pipeline-%d ==========\n", pipe->id);
 
 	if (pipe->funcs && pipe->funcs->dump_register)
 		pipe->funcs->dump_register(pipe, sf);
 
-	dp_for_each_set_bit(id, pipe->avail_comps) {
+	avail_comps = pipe->avail_comps;
+	for_each_set_bit(id, &avail_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, id);
 
 		seq_printf(sf, "\n------%s------\n", c->name);
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
index 8f32ae7c25d0..c3cdf283ecef 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
@@ -1231,14 +1231,15 @@ komeda_pipeline_unbound_components(struct komeda_pipeline *pipe,
 	struct komeda_pipeline_state *old = priv_to_pipe_st(pipe->obj.state);
 	struct komeda_component_state *c_st;
 	struct komeda_component *c;
-	u32 disabling_comps, id;
+	u32 id;
+	unsigned long disabling_comps;
 
 	WARN_ON(!old);
 
 	disabling_comps = (~new->active_comps) & old->active_comps;
 
 	/* unbound all disabling component */
-	dp_for_each_set_bit(id, disabling_comps) {
+	for_each_set_bit(id, &disabling_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, id);
 		c_st = komeda_component_get_state_and_set_user(c,
 				drm_st, NULL, new->crtc);
@@ -1286,7 +1287,8 @@ bool komeda_pipeline_disable(struct komeda_pipeline *pipe,
 	struct komeda_pipeline_state *old;
 	struct komeda_component *c;
 	struct komeda_component_state *c_st;
-	u32 id, disabling_comps = 0;
+	u32 id;
+	unsigned long disabling_comps;
 
 	old = komeda_pipeline_get_old_state(pipe, old_state);
 
@@ -1296,10 +1298,10 @@ bool komeda_pipeline_disable(struct komeda_pipeline *pipe,
 		disabling_comps = old->active_comps &
 				  pipe->standalone_disabled_comps;
 
-	DRM_DEBUG_ATOMIC("PIPE%d: active_comps: 0x%x, disabling_comps: 0x%x.\n",
+	DRM_DEBUG_ATOMIC("PIPE%d: active_comps: 0x%x, disabling_comps: 0x%lx.\n",
 			 pipe->id, old->active_comps, disabling_comps);
 
-	dp_for_each_set_bit(id, disabling_comps) {
+	for_each_set_bit(id, &disabling_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, id);
 		c_st = priv_to_comp_st(c->obj.state);
 
@@ -1330,16 +1332,17 @@ void komeda_pipeline_update(struct komeda_pipeline *pipe,
 	struct komeda_pipeline_state *new = priv_to_pipe_st(pipe->obj.state);
 	struct komeda_pipeline_state *old;
 	struct komeda_component *c;
-	u32 id, changed_comps = 0;
+	u32 id;
+	unsigned long changed_comps;
 
 	old = komeda_pipeline_get_old_state(pipe, old_state);
 
 	changed_comps = new->active_comps | old->active_comps;
 
-	DRM_DEBUG_ATOMIC("PIPE%d: active_comps: 0x%x, changed: 0x%x.\n",
+	DRM_DEBUG_ATOMIC("PIPE%d: active_comps: 0x%x, changed: 0x%lx.\n",
 			 pipe->id, new->active_comps, changed_comps);
 
-	dp_for_each_set_bit(id, changed_comps) {
+	for_each_set_bit(id, &changed_comps, 32) {
 		c = komeda_pipeline_get_component(pipe, id);
 
 		if (new->active_comps & BIT(c->id))
-- 
2.30.2



