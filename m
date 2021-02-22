Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C656132160D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhBVMQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhBVMPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1714C64F0B;
        Mon, 22 Feb 2021 12:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996058;
        bh=9Mevd1pqlfBbH7qyUPIQhCmyTaayeN0Cn7Of5lzlY6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu+ik6HJooZAjxP6Jk+9kB2XTqynZXkvLIKEatlCSjpeXNdZ4mtMK1D4TkjMEH1mr
         DZNbiU0kc1FJ5jjCvxPvCw4aaFa+po1zbEjDvmiPYH49iaUYVnlMemJbKC6Aiwd9Yj
         wIuaR5s8QQTa7mNH8ybkwMRimps/DD9TIjFrK8TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/29] IB/isert: add module param to set sg_tablesize for IO cmd
Date:   Mon, 22 Feb 2021 13:13:00 +0100
Message-Id: <20210222121021.163596444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit dae7a75f1f19bffb579daf148f8d8addd2726772 ]

Currently, iser target support max IO size of 16MiB by default. For some
adapters, allocating this amount of resources might reduce the total
number of possible connections that can be created. For those adapters,
it's preferred to reduce the max IO size to be able to create more
connections. Since there is no handshake procedure for max IO size in iser
protocol, set the default max IO size to 1MiB and add a module parameter
for enabling the option to control it for suitable adapters.

Fixes: 317000b926b0 ("IB/isert: allocate RW ctxs according to max IO size")
Link: https://lore.kernel.org/r/20201019094628.17202-1-mgurtovoy@nvidia.com
Reported-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 27 ++++++++++++++++++++++++-
 drivers/infiniband/ulp/isert/ib_isert.h |  6 ++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 436e17f1d0e53..bd478947b93a5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -28,6 +28,18 @@ static int isert_debug_level;
 module_param_named(debug_level, isert_debug_level, int, 0644);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:0)");
 
+static int isert_sg_tablesize_set(const char *val,
+				  const struct kernel_param *kp);
+static const struct kernel_param_ops sg_tablesize_ops = {
+	.set = isert_sg_tablesize_set,
+	.get = param_get_int,
+};
+
+static int isert_sg_tablesize = ISCSI_ISER_DEF_SG_TABLESIZE;
+module_param_cb(sg_tablesize, &sg_tablesize_ops, &isert_sg_tablesize, 0644);
+MODULE_PARM_DESC(sg_tablesize,
+		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 256, max: 4096)");
+
 static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
 static struct workqueue_struct *isert_comp_wq;
@@ -47,6 +59,19 @@ static void isert_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
+static int isert_sg_tablesize_set(const char *val, const struct kernel_param *kp)
+{
+	int n = 0, ret;
+
+	ret = kstrtoint(val, 10, &n);
+	if (ret != 0 || n < ISCSI_ISER_MIN_SG_TABLESIZE ||
+	    n > ISCSI_ISER_MAX_SG_TABLESIZE)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+
 static inline bool
 isert_prot_cmd(struct isert_conn *conn, struct se_cmd *cmd)
 {
@@ -101,7 +126,7 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS + 1;
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
 	factor = rdma_rw_mr_factor(device->ib_device, cma_id->port_num,
-				   ISCSI_ISER_MAX_SG_TABLESIZE);
+				   isert_sg_tablesize);
 	attr.cap.max_rdma_ctxs = ISCSI_DEF_XMIT_CMDS_MAX * factor;
 	attr.cap.max_send_sge = device->ib_device->attrs.max_send_sge;
 	attr.cap.max_recv_sge = 1;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 7fee4a65e181a..6c5af13db4e0d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -65,6 +65,12 @@
  */
 #define ISER_RX_SIZE		(ISCSI_DEF_MAX_RECV_SEG_LEN + 1024)
 
+/* Default I/O size is 1MB */
+#define ISCSI_ISER_DEF_SG_TABLESIZE 256
+
+/* Minimum I/O size is 512KB */
+#define ISCSI_ISER_MIN_SG_TABLESIZE 128
+
 /* Maximum support is 16MB I/O size */
 #define ISCSI_ISER_MAX_SG_TABLESIZE	4096
 
-- 
2.27.0



