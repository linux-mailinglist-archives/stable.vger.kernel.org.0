Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB3A38EF5F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhEXP5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234457AbhEXP4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5704761940;
        Mon, 24 May 2021 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870963;
        bh=Nzy5gzh1VjtU/TboU9DQW5QUBfsY8+VumZ6IfEyhaZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrijKivd8fT1NEKCE9D+MvTF1pjNbhcGRpIk01zdsTFIxOKRgfAenn31LhELICzuD
         H/l2t9miHLDWHmMcmdRDpi2kUKHACHAw/6mHfU/bWy7BaLB4Hd4BC1Eb+EE85GcCj7
         +iJSgI+7tV5H3AMg27g4eY4576PQR02SSmRZ0VU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 003/127] tee: amdtee: unload TA only when its refcount becomes 0
Date:   Mon, 24 May 2021 17:25:20 +0200
Message-Id: <20210524152334.975632947@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rijo Thomas <Rijo-john.Thomas@amd.com>

[ Upstream commit 9f015b3765bf593b3ed5d3b588e409dc0ffa9f85 ]

Same Trusted Application (TA) can be loaded in multiple TEE contexts.

If it is a single instance TA, the TA should not get unloaded from AMD
Secure Processor, while it is still in use in another TEE context.

Therefore reference count TA and unload it when the count becomes zero.

Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/amdtee/amdtee_private.h | 13 ++++
 drivers/tee/amdtee/call.c           | 94 ++++++++++++++++++++++++++---
 drivers/tee/amdtee/core.c           | 15 +++--
 3 files changed, 106 insertions(+), 16 deletions(-)

diff --git a/drivers/tee/amdtee/amdtee_private.h b/drivers/tee/amdtee/amdtee_private.h
index 337c8d82f74e..6d0f7062bb87 100644
--- a/drivers/tee/amdtee/amdtee_private.h
+++ b/drivers/tee/amdtee/amdtee_private.h
@@ -21,6 +21,7 @@
 #define TEEC_SUCCESS			0x00000000
 #define TEEC_ERROR_GENERIC		0xFFFF0000
 #define TEEC_ERROR_BAD_PARAMETERS	0xFFFF0006
+#define TEEC_ERROR_OUT_OF_MEMORY	0xFFFF000C
 #define TEEC_ERROR_COMMUNICATION	0xFFFF000E
 
 #define TEEC_ORIGIN_COMMS		0x00000002
@@ -93,6 +94,18 @@ struct amdtee_shm_data {
 	u32     buf_id;
 };
 
+/**
+ * struct amdtee_ta_data - Keeps track of all TAs loaded in AMD Secure
+ *			   Processor
+ * @ta_handle:	Handle to TA loaded in TEE
+ * @refcount:	Reference count for the loaded TA
+ */
+struct amdtee_ta_data {
+	struct list_head list_node;
+	u32 ta_handle;
+	u32 refcount;
+};
+
 #define LOWER_TWO_BYTE_MASK	0x0000FFFF
 
 /**
diff --git a/drivers/tee/amdtee/call.c b/drivers/tee/amdtee/call.c
index 096dd4d92d39..07f36ac834c8 100644
--- a/drivers/tee/amdtee/call.c
+++ b/drivers/tee/amdtee/call.c
@@ -121,15 +121,69 @@ static int amd_params_to_tee_params(struct tee_param *tee, u32 count,
 	return ret;
 }
 
+static DEFINE_MUTEX(ta_refcount_mutex);
+static struct list_head ta_list = LIST_HEAD_INIT(ta_list);
+
+static u32 get_ta_refcount(u32 ta_handle)
+{
+	struct amdtee_ta_data *ta_data;
+	u32 count = 0;
+
+	/* Caller must hold a mutex */
+	list_for_each_entry(ta_data, &ta_list, list_node)
+		if (ta_data->ta_handle == ta_handle)
+			return ++ta_data->refcount;
+
+	ta_data = kzalloc(sizeof(*ta_data), GFP_KERNEL);
+	if (ta_data) {
+		ta_data->ta_handle = ta_handle;
+		ta_data->refcount = 1;
+		count = ta_data->refcount;
+		list_add(&ta_data->list_node, &ta_list);
+	}
+
+	return count;
+}
+
+static u32 put_ta_refcount(u32 ta_handle)
+{
+	struct amdtee_ta_data *ta_data;
+	u32 count = 0;
+
+	/* Caller must hold a mutex */
+	list_for_each_entry(ta_data, &ta_list, list_node)
+		if (ta_data->ta_handle == ta_handle) {
+			count = --ta_data->refcount;
+			if (count == 0) {
+				list_del(&ta_data->list_node);
+				kfree(ta_data);
+				break;
+			}
+		}
+
+	return count;
+}
+
 int handle_unload_ta(u32 ta_handle)
 {
 	struct tee_cmd_unload_ta cmd = {0};
-	u32 status;
+	u32 status, count;
 	int ret;
 
 	if (!ta_handle)
 		return -EINVAL;
 
+	mutex_lock(&ta_refcount_mutex);
+
+	count = put_ta_refcount(ta_handle);
+
+	if (count) {
+		pr_debug("unload ta: not unloading %u count %u\n",
+			 ta_handle, count);
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	cmd.ta_handle = ta_handle;
 
 	ret = psp_tee_process_cmd(TEE_CMD_ID_UNLOAD_TA, (void *)&cmd,
@@ -137,8 +191,12 @@ int handle_unload_ta(u32 ta_handle)
 	if (!ret && status != 0) {
 		pr_err("unload ta: status = 0x%x\n", status);
 		ret = -EBUSY;
+	} else {
+		pr_debug("unloaded ta handle %u\n", ta_handle);
 	}
 
+unlock:
+	mutex_unlock(&ta_refcount_mutex);
 	return ret;
 }
 
@@ -340,7 +398,8 @@ int handle_open_session(struct tee_ioctl_open_session_arg *arg, u32 *info,
 
 int handle_load_ta(void *data, u32 size, struct tee_ioctl_open_session_arg *arg)
 {
-	struct tee_cmd_load_ta cmd = {0};
+	struct tee_cmd_unload_ta unload_cmd = {};
+	struct tee_cmd_load_ta load_cmd = {};
 	phys_addr_t blob;
 	int ret;
 
@@ -353,21 +412,36 @@ int handle_load_ta(void *data, u32 size, struct tee_ioctl_open_session_arg *arg)
 		return -EINVAL;
 	}
 
-	cmd.hi_addr = upper_32_bits(blob);
-	cmd.low_addr = lower_32_bits(blob);
-	cmd.size = size;
+	load_cmd.hi_addr = upper_32_bits(blob);
+	load_cmd.low_addr = lower_32_bits(blob);
+	load_cmd.size = size;
 
-	ret = psp_tee_process_cmd(TEE_CMD_ID_LOAD_TA, (void *)&cmd,
-				  sizeof(cmd), &arg->ret);
+	mutex_lock(&ta_refcount_mutex);
+
+	ret = psp_tee_process_cmd(TEE_CMD_ID_LOAD_TA, (void *)&load_cmd,
+				  sizeof(load_cmd), &arg->ret);
 	if (ret) {
 		arg->ret_origin = TEEC_ORIGIN_COMMS;
 		arg->ret = TEEC_ERROR_COMMUNICATION;
-	} else {
-		set_session_id(cmd.ta_handle, 0, &arg->session);
+	} else if (arg->ret == TEEC_SUCCESS) {
+		ret = get_ta_refcount(load_cmd.ta_handle);
+		if (!ret) {
+			arg->ret_origin = TEEC_ORIGIN_COMMS;
+			arg->ret = TEEC_ERROR_OUT_OF_MEMORY;
+
+			/* Unload the TA on error */
+			unload_cmd.ta_handle = load_cmd.ta_handle;
+			psp_tee_process_cmd(TEE_CMD_ID_UNLOAD_TA,
+					    (void *)&unload_cmd,
+					    sizeof(unload_cmd), &ret);
+		} else {
+			set_session_id(load_cmd.ta_handle, 0, &arg->session);
+		}
 	}
+	mutex_unlock(&ta_refcount_mutex);
 
 	pr_debug("load TA: TA handle = 0x%x, RO = 0x%x, ret = 0x%x\n",
-		 cmd.ta_handle, arg->ret_origin, arg->ret);
+		 load_cmd.ta_handle, arg->ret_origin, arg->ret);
 
 	return 0;
 }
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 8a6a8f30bb42..da6b88e80dc0 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -59,10 +59,9 @@ static void release_session(struct amdtee_session *sess)
 			continue;
 
 		handle_close_session(sess->ta_handle, sess->session_info[i]);
+		handle_unload_ta(sess->ta_handle);
 	}
 
-	/* Unload Trusted Application once all sessions are closed */
-	handle_unload_ta(sess->ta_handle);
 	kfree(sess);
 }
 
@@ -224,8 +223,6 @@ static void destroy_session(struct kref *ref)
 	struct amdtee_session *sess = container_of(ref, struct amdtee_session,
 						   refcount);
 
-	/* Unload the TA from TEE */
-	handle_unload_ta(sess->ta_handle);
 	mutex_lock(&session_list_mutex);
 	list_del(&sess->list_node);
 	mutex_unlock(&session_list_mutex);
@@ -238,7 +235,7 @@ int amdtee_open_session(struct tee_context *ctx,
 {
 	struct amdtee_context_data *ctxdata = ctx->data;
 	struct amdtee_session *sess = NULL;
-	u32 session_info;
+	u32 session_info, ta_handle;
 	size_t ta_size;
 	int rc, i;
 	void *ta;
@@ -259,11 +256,14 @@ int amdtee_open_session(struct tee_context *ctx,
 	if (arg->ret != TEEC_SUCCESS)
 		goto out;
 
+	ta_handle = get_ta_handle(arg->session);
+
 	mutex_lock(&session_list_mutex);
 	sess = alloc_session(ctxdata, arg->session);
 	mutex_unlock(&session_list_mutex);
 
 	if (!sess) {
+		handle_unload_ta(ta_handle);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -277,6 +277,7 @@ int amdtee_open_session(struct tee_context *ctx,
 
 	if (i >= TEE_NUM_SESSIONS) {
 		pr_err("reached maximum session count %d\n", TEE_NUM_SESSIONS);
+		handle_unload_ta(ta_handle);
 		kref_put(&sess->refcount, destroy_session);
 		rc = -ENOMEM;
 		goto out;
@@ -289,12 +290,13 @@ int amdtee_open_session(struct tee_context *ctx,
 		spin_lock(&sess->lock);
 		clear_bit(i, sess->sess_mask);
 		spin_unlock(&sess->lock);
+		handle_unload_ta(ta_handle);
 		kref_put(&sess->refcount, destroy_session);
 		goto out;
 	}
 
 	sess->session_info[i] = session_info;
-	set_session_id(sess->ta_handle, i, &arg->session);
+	set_session_id(ta_handle, i, &arg->session);
 out:
 	free_pages((u64)ta, get_order(ta_size));
 	return rc;
@@ -329,6 +331,7 @@ int amdtee_close_session(struct tee_context *ctx, u32 session)
 
 	/* Close the session */
 	handle_close_session(ta_handle, session_info);
+	handle_unload_ta(ta_handle);
 
 	kref_put(&sess->refcount, destroy_session);
 
-- 
2.30.2



