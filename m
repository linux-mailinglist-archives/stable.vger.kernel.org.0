Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD963289E1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbhCASHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237911AbhCASBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A9264E13;
        Mon,  1 Mar 2021 17:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620811;
        bh=uw18soxiEtcKB9GcffwrVw95126M26GGnv5NU7uwFyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KiaHmln1+Dc0ujZTR/VVN98RrhYK+PbkUz4nMjap06kkb05wrdV3LJ5/LFb5OpbD
         41vhTnB5KQzpKQD8RKUyGgnxMfQCcP6ohTmFeZn0zoxgTQIMkHJpY5xu/XYnMjMer6
         +RROUuXcsmYmRve/4B/75WU3S0GFJmicqX+dbAOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 288/775] nvmet: remove extra variable in identify ns
Date:   Mon,  1 Mar 2021 17:07:36 +0100
Message-Id: <20210301161215.852116642@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 3c7b224f1956ed232b24ed2eb2c54e4476c6acb2 ]

We remove the extra local variable struct nvmet_ns in
nvmet_execute_identify_ns() since req already has ns member that can be
reused, this also eliminates the explicit call to nvmet_put_namespace()
which is already present in the request completion path.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index dc1ea468b182b..de6aaa4c96e53 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -469,7 +469,6 @@ out:
 static void nvmet_execute_identify_ns(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
-	struct nvmet_ns *ns;
 	struct nvme_id_ns *id;
 	u16 status = 0;
 
@@ -486,20 +485,21 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 	}
 
 	/* return an all zeroed buffer if we can't find an active namespace */
-	ns = nvmet_find_namespace(ctrl, req->cmd->identify.nsid);
-	if (!ns) {
+	req->ns = nvmet_find_namespace(ctrl, req->cmd->identify.nsid);
+	if (!req->ns) {
 		status = NVME_SC_INVALID_NS;
 		goto done;
 	}
 
-	nvmet_ns_revalidate(ns);
+	nvmet_ns_revalidate(req->ns);
 
 	/*
 	 * nuse = ncap = nsze isn't always true, but we have no way to find
 	 * that out from the underlying device.
 	 */
-	id->ncap = id->nsze = cpu_to_le64(ns->size >> ns->blksize_shift);
-	switch (req->port->ana_state[ns->anagrpid]) {
+	id->ncap = id->nsze =
+		cpu_to_le64(req->ns->size >> req->ns->blksize_shift);
+	switch (req->port->ana_state[req->ns->anagrpid]) {
 	case NVME_ANA_INACCESSIBLE:
 	case NVME_ANA_PERSISTENT_LOSS:
 		break;
@@ -508,8 +508,8 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 		break;
         }
 
-	if (ns->bdev)
-		nvmet_bdev_set_limits(ns->bdev, id);
+	if (req->ns->bdev)
+		nvmet_bdev_set_limits(req->ns->bdev, id);
 
 	/*
 	 * We just provide a single LBA format that matches what the
@@ -523,25 +523,24 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 	 * controllers, but also with any other user of the block device.
 	 */
 	id->nmic = (1 << 0);
-	id->anagrpid = cpu_to_le32(ns->anagrpid);
+	id->anagrpid = cpu_to_le32(req->ns->anagrpid);
 
-	memcpy(&id->nguid, &ns->nguid, sizeof(id->nguid));
+	memcpy(&id->nguid, &req->ns->nguid, sizeof(id->nguid));
 
-	id->lbaf[0].ds = ns->blksize_shift;
+	id->lbaf[0].ds = req->ns->blksize_shift;
 
-	if (ctrl->pi_support && nvmet_ns_has_pi(ns)) {
+	if (ctrl->pi_support && nvmet_ns_has_pi(req->ns)) {
 		id->dpc = NVME_NS_DPC_PI_FIRST | NVME_NS_DPC_PI_LAST |
 			  NVME_NS_DPC_PI_TYPE1 | NVME_NS_DPC_PI_TYPE2 |
 			  NVME_NS_DPC_PI_TYPE3;
 		id->mc = NVME_MC_EXTENDED_LBA;
-		id->dps = ns->pi_type;
+		id->dps = req->ns->pi_type;
 		id->flbas = NVME_NS_FLBAS_META_EXT;
-		id->lbaf[0].ms = cpu_to_le16(ns->metadata_size);
+		id->lbaf[0].ms = cpu_to_le16(req->ns->metadata_size);
 	}
 
-	if (ns->readonly)
+	if (req->ns->readonly)
 		id->nsattr |= (1 << 0);
-	nvmet_put_namespace(ns);
 done:
 	if (!status)
 		status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
-- 
2.27.0



