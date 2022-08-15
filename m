Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256555940FB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbiHOUt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346596AbiHOUs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80365DFFE;
        Mon, 15 Aug 2022 12:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DCF60693;
        Mon, 15 Aug 2022 19:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49252C433C1;
        Mon, 15 Aug 2022 19:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590545;
        bh=xMtcPeQKe46Skuop9aELY3NS1lc3uk2hAW+vMw8BryU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YV5sYK657DkVWGY0/yZFGn9sFyrBRuuonuWW22IQjXrRXXqAOw+dC1FGg2XpAYkUN
         gkP801xGnwMtLDE8Ymb9+PkJH+qaO5TclpXSHhBRs2OASey3eVJbr0XM6VeNWXtE/T
         pXNP0rEJ51puE75dLbMc4ktb/SsHQ1Fo1YNs8qFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0292/1095] scsi: nvme-fc: Add new routine nvme_fc_io_getuuid()
Date:   Mon, 15 Aug 2022 19:54:51 +0200
Message-Id: <20220815180441.871915550@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muneendra Kumar <muneendra.kumar@broadcom.com>

[ Upstream commit 827fc630e4c8087df5a8e8ee013b686bd6f13736 ]

Add nvme_fc_io_getuuid() to the nvme-fc transport. The routine is invoked
by the FC LLDD on a per-I/O request basis.  The routine translates from the
FC-specific request structure to the bio and the cgroup structure in order
to obtain the FC appid stored in the cgroup structure. If a value is not
set or a bio is not found, a NULL appid (aka uuid) will be returned to the
LLDD.

Link: https://lore.kernel.org/r/20220519123110.17361-2-jsmart2021@gmail.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c         | 18 ++++++++++++++++++
 include/linux/nvme-fc-driver.h | 14 ++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 080f85f4105f..05f9da251758 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1899,6 +1899,24 @@ nvme_fc_ctrl_ioerr_work(struct work_struct *work)
 	nvme_fc_error_recovery(ctrl, "transport detected io error");
 }
 
+/*
+ * nvme_fc_io_getuuid - Routine called to get the appid field
+ * associated with request by the lldd
+ * @req:IO request from nvme fc to driver
+ * Returns: UUID if there is an appid associated with VM or
+ * NULL if the user/libvirt has not set the appid to VM
+ */
+char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req)
+{
+	struct nvme_fc_fcp_op *op = fcp_req_to_fcp_op(req);
+	struct request *rq = op->rq;
+
+	if (!IS_ENABLED(CONFIG_BLK_CGROUP_FC_APPID) || !rq->bio)
+		return NULL;
+	return blkcg_get_fc_appid(rq->bio);
+}
+EXPORT_SYMBOL_GPL(nvme_fc_io_getuuid);
+
 static void
 nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 {
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 5358a5facdee..fa092b9be2fd 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -564,6 +564,15 @@ int nvme_fc_rcv_ls_req(struct nvme_fc_remote_port *remoteport,
 			void *lsreqbuf, u32 lsreqbuf_len);
 
 
+/*
+ * Routine called to get the appid field associated with request by the lldd
+ *
+ * If the return value is NULL : the user/libvirt has not set the appid to VM
+ * If the return value is non-zero: Returns the appid associated with VM
+ *
+ * @req: IO request from nvme fc to driver
+ */
+char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req);
 
 /*
  * ***************  LLDD FC-NVME Target/Subsystem API ***************
@@ -1048,5 +1057,10 @@ int nvmet_fc_rcv_fcp_req(struct nvmet_fc_target_port *tgtport,
 
 void nvmet_fc_rcv_fcp_abort(struct nvmet_fc_target_port *tgtport,
 			struct nvmefc_tgt_fcp_req *fcpreq);
+/*
+ * add a define, visible to the compiler, that indicates support
+ * for feature. Allows for conditional compilation in LLDDs.
+ */
+#define NVME_FC_FEAT_UUID	0x0001
 
 #endif /* _NVME_FC_DRIVER_H */
-- 
2.35.1



