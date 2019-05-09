Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23A31917C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfEIS5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbfEISyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3F2204FD;
        Thu,  9 May 2019 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428050;
        bh=3X5YdOqJHbz8Jj1Su7duO+N7W/wIastC3yBPuBnU54Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQ9RQ6Q98sh1+bLrTzwOiD+cK8c1QrMqUUiQRFDzhxfgOSFtGoLVkjFxeYxs+8alu
         FkEU5yONx6IYPpryWzYpj2bVBWso4GRFxXRQixriL2L/dwR1U1mJi9gW+8r+JSEmtb
         +7gFUyvJPK1vkQp+E8mh/zgDKeiOY0QXjxU14fh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Minwoo Im <minwoo.im@samsung.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 68/95] nvmet: fix discover log page when offsets are used
Date:   Thu,  9 May 2019 20:42:25 +0200
Message-Id: <20190509181314.210243549@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d808b7f759b50acf0784ce6230ffa63e12ef465d ]

The nvme target hadn't been taking the Get Log Page offset parameter
into consideration, and so has been returning corrupted log pages when
offsets are used. Since many tools, including nvme-cli, split the log
request to 4k, we've been breaking discovery log responses when more
than 3 subsystems exist.

Fix the returned data by internally generating the entire discovery
log page and copying only the requested bytes into the user buffer. The
command log page offset type has been modified to a native __le64 to
make it easier to extract the value from a command.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Tested-by: Minwoo Im <minwoo.im@samsung.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c |  5 +++
 drivers/nvme/target/discovery.c | 68 ++++++++++++++++++++++-----------
 drivers/nvme/target/nvmet.h     |  1 +
 include/linux/nvme.h            |  9 ++++-
 4 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 11baeb14c3881..8fdae510c5ac0 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -32,6 +32,11 @@ u32 nvmet_get_log_page_len(struct nvme_command *cmd)
 	return len;
 }
 
+u64 nvmet_get_log_page_offset(struct nvme_command *cmd)
+{
+	return le64_to_cpu(cmd->get_log_page.lpo);
+}
+
 static void nvmet_execute_get_log_page_noop(struct nvmet_req *req)
 {
 	nvmet_req_complete(req, nvmet_zero_sgl(req, 0, req->data_len));
diff --git a/drivers/nvme/target/discovery.c b/drivers/nvme/target/discovery.c
index d2cb71a0b419d..389c1a90197d9 100644
--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -139,54 +139,76 @@ static void nvmet_set_disc_traddr(struct nvmet_req *req, struct nvmet_port *port
 		memcpy(traddr, port->disc_addr.traddr, NVMF_TRADDR_SIZE);
 }
 
+static size_t discovery_log_entries(struct nvmet_req *req)
+{
+	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	struct nvmet_subsys_link *p;
+	struct nvmet_port *r;
+	size_t entries = 0;
+
+	list_for_each_entry(p, &req->port->subsystems, entry) {
+		if (!nvmet_host_allowed(p->subsys, ctrl->hostnqn))
+			continue;
+		entries++;
+	}
+	list_for_each_entry(r, &req->port->referrals, entry)
+		entries++;
+	return entries;
+}
+
 static void nvmet_execute_get_disc_log_page(struct nvmet_req *req)
 {
 	const int entry_size = sizeof(struct nvmf_disc_rsp_page_entry);
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	struct nvmf_disc_rsp_page_hdr *hdr;
+	u64 offset = nvmet_get_log_page_offset(req->cmd);
 	size_t data_len = nvmet_get_log_page_len(req->cmd);
-	size_t alloc_len = max(data_len, sizeof(*hdr));
-	int residual_len = data_len - sizeof(*hdr);
+	size_t alloc_len;
 	struct nvmet_subsys_link *p;
 	struct nvmet_port *r;
 	u32 numrec = 0;
 	u16 status = 0;
+	void *buffer;
+
+	/* Spec requires dword aligned offsets */
+	if (offset & 0x3) {
+		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
+		goto out;
+	}
 
 	/*
 	 * Make sure we're passing at least a buffer of response header size.
 	 * If host provided data len is less than the header size, only the
 	 * number of bytes requested by host will be sent to host.
 	 */
-	hdr = kzalloc(alloc_len, GFP_KERNEL);
-	if (!hdr) {
+	down_read(&nvmet_config_sem);
+	alloc_len = sizeof(*hdr) + entry_size * discovery_log_entries(req);
+	buffer = kzalloc(alloc_len, GFP_KERNEL);
+	if (!buffer) {
+		up_read(&nvmet_config_sem);
 		status = NVME_SC_INTERNAL;
 		goto out;
 	}
 
-	down_read(&nvmet_config_sem);
+	hdr = buffer;
 	list_for_each_entry(p, &req->port->subsystems, entry) {
+		char traddr[NVMF_TRADDR_SIZE];
+
 		if (!nvmet_host_allowed(p->subsys, ctrl->hostnqn))
 			continue;
-		if (residual_len >= entry_size) {
-			char traddr[NVMF_TRADDR_SIZE];
-
-			nvmet_set_disc_traddr(req, req->port, traddr);
-			nvmet_format_discovery_entry(hdr, req->port,
-					p->subsys->subsysnqn, traddr,
-					NVME_NQN_NVME, numrec);
-			residual_len -= entry_size;
-		}
+
+		nvmet_set_disc_traddr(req, req->port, traddr);
+		nvmet_format_discovery_entry(hdr, req->port,
+				p->subsys->subsysnqn, traddr,
+				NVME_NQN_NVME, numrec);
 		numrec++;
 	}
 
 	list_for_each_entry(r, &req->port->referrals, entry) {
-		if (residual_len >= entry_size) {
-			nvmet_format_discovery_entry(hdr, r,
-					NVME_DISC_SUBSYS_NAME,
-					r->disc_addr.traddr,
-					NVME_NQN_DISC, numrec);
-			residual_len -= entry_size;
-		}
+		nvmet_format_discovery_entry(hdr, r,
+				NVME_DISC_SUBSYS_NAME,
+				r->disc_addr.traddr,
+				NVME_NQN_DISC, numrec);
 		numrec++;
 	}
 
@@ -198,8 +220,8 @@ static void nvmet_execute_get_disc_log_page(struct nvmet_req *req)
 
 	up_read(&nvmet_config_sem);
 
-	status = nvmet_copy_to_sgl(req, 0, hdr, data_len);
-	kfree(hdr);
+	status = nvmet_copy_to_sgl(req, 0, buffer + offset, data_len);
+	kfree(buffer);
 out:
 	nvmet_req_complete(req, status);
 }
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 3e4719fdba854..d253c45c1aa6e 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -436,6 +436,7 @@ u16 nvmet_copy_from_sgl(struct nvmet_req *req, off_t off, void *buf,
 u16 nvmet_zero_sgl(struct nvmet_req *req, off_t off, size_t len);
 
 u32 nvmet_get_log_page_len(struct nvme_command *cmd);
+u64 nvmet_get_log_page_offset(struct nvme_command *cmd);
 
 extern struct list_head *nvmet_ports;
 void nvmet_port_disc_changed(struct nvmet_port *port,
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index bbcc83886899c..7ba0368f16e6e 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -975,8 +975,13 @@ struct nvme_get_log_page_command {
 	__le16			numdl;
 	__le16			numdu;
 	__u16			rsvd11;
-	__le32			lpol;
-	__le32			lpou;
+	union {
+		struct {
+			__le32 lpol;
+			__le32 lpou;
+		};
+		__le64 lpo;
+	};
 	__u32			rsvd14[2];
 };
 
-- 
2.20.1



