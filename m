Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09463572E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbiKWJkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiKWJjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:39:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF929266E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F997B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8D0C433C1;
        Wed, 23 Nov 2022 09:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196247;
        bh=2m8LLEGJbLkwwTxqwEBxKbFXh8IYg7QgwVeifRWO8Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMw1adEyVm2/H/OJSidFTz1wxaS39bpw+2iZg7P43nEkuLQ26cmxlJ8aw5jkVyo9z
         jbXsAzQ/HHX7EF6R/nDrlCoaWKibGyR/u3mW+wl5nHr6qD2zzZ9SNpTkDOD0p4CSlu
         9NQk5oyYtEfp0LGTguJ3jXOjyYUo/uPI8K1m5HhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 158/181] nvme: ensure subsystem reset is single threaded
Date:   Wed, 23 Nov 2022 09:52:01 +0100
Message-Id: <20221123084609.178182029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 1e866afd4bcdd01a70a5eddb4371158d3035ce03 upstream.

The subsystem reset writes to a register, so we have to ensure the
device state is capable of handling that otherwise the driver may access
unmapped registers. Use the state machine to ensure the subsystem reset
doesn't try to write registers on a device already undergoing this type
of reset.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214771
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/nvme.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -558,11 +558,23 @@ static inline void nvme_fault_inject_fin
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -650,7 +662,6 @@ void nvme_cancel_tagset(struct nvme_ctrl
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -734,7 +745,6 @@ int nvme_set_queue_count(struct nvme_ctr
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 void nvme_queue_scan(struct nvme_ctrl *ctrl);
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,


