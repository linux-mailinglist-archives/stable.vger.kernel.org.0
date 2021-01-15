Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB922F7BFC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbhAOMat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732214AbhAOMat (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2976223370;
        Fri, 15 Jan 2021 12:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713788;
        bh=ZuQboh6gdy7fBB0NZFtfHFJ+8D8Z+kY0IYsRUmcNjSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrX3dWiS0juzX/82VkadiqwBdOnwzH3YMJ962ncv8mYIp3++pYrq39GfkquZUxWUu
         s2JecdshOYssUzdAJwSx9GjNM6tCTdtoweESCmX72KWmWLO/+QWe5Q6E04psYSFn/S
         VaxK9B50DOkI6nckq7lVdD5j7aFD0oVY+9B4IRbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        David Disseldorp <ddiss@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/18] scsi: target: Fix XCOPY NAA identifier lookup
Date:   Fri, 15 Jan 2021 13:27:34 +0100
Message-Id: <20210115121955.423464201@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 2896c93811e39d63a4d9b63ccf12a8fbc226e5e4 ]

When attempting to match EXTENDED COPY CSCD descriptors with corresponding
se_devices, target_xcopy_locate_se_dev_e4() currently iterates over LIO's
global devices list which includes all configured backstores.

This change ensures that only initiator-accessible backstores are
considered during CSCD descriptor lookup, according to the session's
se_node_acl LUN list.

To avoid LUN removal race conditions, device pinning is changed from being
configfs based to instead using the se_node_acl lun_ref.

Reference: CVE-2020-28374
Fixes: cbf031f425fd ("target: Add support for EXTENDED_COPY copy offload emulation")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_xcopy.c | 119 +++++++++++++++++------------
 drivers/target/target_core_xcopy.h |   1 +
 2 files changed, 71 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index b0e8f432c7205..9587375122295 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -52,60 +52,83 @@ static int target_xcopy_gen_naa_ieee(struct se_device *dev, unsigned char *buf)
 	return 0;
 }
 
-struct xcopy_dev_search_info {
-	const unsigned char *dev_wwn;
-	struct se_device *found_dev;
-};
-
+/**
+ * target_xcopy_locate_se_dev_e4_iter - compare XCOPY NAA device identifiers
+ *
+ * @se_dev: device being considered for match
+ * @dev_wwn: XCOPY requested NAA dev_wwn
+ * @return: 1 on match, 0 on no-match
+ */
 static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
-					      void *data)
+					      const unsigned char *dev_wwn)
 {
-	struct xcopy_dev_search_info *info = data;
 	unsigned char tmp_dev_wwn[XCOPY_NAA_IEEE_REGEX_LEN];
 	int rc;
 
-	if (!se_dev->dev_attrib.emulate_3pc)
+	if (!se_dev->dev_attrib.emulate_3pc) {
+		pr_debug("XCOPY: emulate_3pc disabled on se_dev %p\n", se_dev);
 		return 0;
+	}
 
 	memset(&tmp_dev_wwn[0], 0, XCOPY_NAA_IEEE_REGEX_LEN);
 	target_xcopy_gen_naa_ieee(se_dev, &tmp_dev_wwn[0]);
 
-	rc = memcmp(&tmp_dev_wwn[0], info->dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
-	if (rc != 0)
-		return 0;
-
-	info->found_dev = se_dev;
-	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
-
-	rc = target_depend_item(&se_dev->dev_group.cg_item);
+	rc = memcmp(&tmp_dev_wwn[0], dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
 	if (rc != 0) {
-		pr_err("configfs_depend_item attempt failed: %d for se_dev: %p\n",
-		       rc, se_dev);
-		return rc;
+		pr_debug("XCOPY: skip non-matching: %*ph\n",
+			 XCOPY_NAA_IEEE_REGEX_LEN, tmp_dev_wwn);
+		return 0;
 	}
+	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
 
-	pr_debug("Called configfs_depend_item for se_dev: %p se_dev->se_dev_group: %p\n",
-		 se_dev, &se_dev->dev_group);
 	return 1;
 }
 
-static int target_xcopy_locate_se_dev_e4(const unsigned char *dev_wwn,
-					struct se_device **found_dev)
+static int target_xcopy_locate_se_dev_e4(struct se_session *sess,
+					const unsigned char *dev_wwn,
+					struct se_device **_found_dev,
+					struct percpu_ref **_found_lun_ref)
 {
-	struct xcopy_dev_search_info info;
-	int ret;
-
-	memset(&info, 0, sizeof(info));
-	info.dev_wwn = dev_wwn;
-
-	ret = target_for_each_device(target_xcopy_locate_se_dev_e4_iter, &info);
-	if (ret == 1) {
-		*found_dev = info.found_dev;
-		return 0;
-	} else {
-		pr_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
-		return -EINVAL;
+	struct se_dev_entry *deve;
+	struct se_node_acl *nacl;
+	struct se_lun *this_lun = NULL;
+	struct se_device *found_dev = NULL;
+
+	/* cmd with NULL sess indicates no associated $FABRIC_MOD */
+	if (!sess)
+		goto err_out;
+
+	pr_debug("XCOPY 0xe4: searching for: %*ph\n",
+		 XCOPY_NAA_IEEE_REGEX_LEN, dev_wwn);
+
+	nacl = sess->se_node_acl;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		struct se_device *this_dev;
+		int rc;
+
+		this_lun = rcu_dereference(deve->se_lun);
+		this_dev = rcu_dereference_raw(this_lun->lun_se_dev);
+
+		rc = target_xcopy_locate_se_dev_e4_iter(this_dev, dev_wwn);
+		if (rc) {
+			if (percpu_ref_tryget_live(&this_lun->lun_ref))
+				found_dev = this_dev;
+			break;
+		}
 	}
+	rcu_read_unlock();
+	if (found_dev == NULL)
+		goto err_out;
+
+	pr_debug("lun_ref held for se_dev: %p se_dev->se_dev_group: %p\n",
+		 found_dev, &found_dev->dev_group);
+	*_found_dev = found_dev;
+	*_found_lun_ref = &this_lun->lun_ref;
+	return 0;
+err_out:
+	pr_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
+	return -EINVAL;
 }
 
 static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op *xop,
@@ -248,12 +271,16 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 
 	switch (xop->op_origin) {
 	case XCOL_SOURCE_RECV_OP:
-		rc = target_xcopy_locate_se_dev_e4(xop->dst_tid_wwn,
-						&xop->dst_dev);
+		rc = target_xcopy_locate_se_dev_e4(se_cmd->se_sess,
+						xop->dst_tid_wwn,
+						&xop->dst_dev,
+						&xop->remote_lun_ref);
 		break;
 	case XCOL_DEST_RECV_OP:
-		rc = target_xcopy_locate_se_dev_e4(xop->src_tid_wwn,
-						&xop->src_dev);
+		rc = target_xcopy_locate_se_dev_e4(se_cmd->se_sess,
+						xop->src_tid_wwn,
+						&xop->src_dev,
+						&xop->remote_lun_ref);
 		break;
 	default:
 		pr_err("XCOPY CSCD descriptor IDs not found in CSCD list - "
@@ -397,18 +424,12 @@ static int xcopy_pt_get_cmd_state(struct se_cmd *se_cmd)
 
 static void xcopy_pt_undepend_remotedev(struct xcopy_op *xop)
 {
-	struct se_device *remote_dev;
-
 	if (xop->op_origin == XCOL_SOURCE_RECV_OP)
-		remote_dev = xop->dst_dev;
+		pr_debug("putting dst lun_ref for %p\n", xop->dst_dev);
 	else
-		remote_dev = xop->src_dev;
-
-	pr_debug("Calling configfs_undepend_item for"
-		  " remote_dev: %p remote_dev->dev_group: %p\n",
-		  remote_dev, &remote_dev->dev_group.cg_item);
+		pr_debug("putting src lun_ref for %p\n", xop->src_dev);
 
-	target_undepend_item(&remote_dev->dev_group.cg_item);
+	percpu_ref_put(xop->remote_lun_ref);
 }
 
 static void xcopy_pt_release_cmd(struct se_cmd *se_cmd)
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 700a981c7b415..7db8d0c9223f8 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -19,6 +19,7 @@ struct xcopy_op {
 	struct se_device *dst_dev;
 	unsigned char dst_tid_wwn[XCOPY_NAA_IEEE_REGEX_LEN];
 	unsigned char local_dev_wwn[XCOPY_NAA_IEEE_REGEX_LEN];
+	struct percpu_ref *remote_lun_ref;
 
 	sector_t src_lba;
 	sector_t dst_lba;
-- 
2.27.0



