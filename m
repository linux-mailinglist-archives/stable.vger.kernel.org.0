Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECEE566DCC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbiGEM1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237646AbiGEMZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CC018345;
        Tue,  5 Jul 2022 05:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3A2AB817D3;
        Tue,  5 Jul 2022 12:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02910C341C7;
        Tue,  5 Jul 2022 12:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023488;
        bh=jBekvvBLi/0XyjyaoK/YXQahgVVMES0dJQueg5wVxRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaY3ywHebJb9aehJeQH12JdjczkCyeX6XLm7Va15aFIBRiUK2fCp9pAy3hsxraQ1A
         jk9WxVzQ/YbC50KSQl9AfT8r/PMhexItmX/exduw9YJ3zGkD84NWvm6yIMzjUsiCQE
         63EnKiXTxcwffHsc4JoBM1CB4Ig+StU8q2HPwiQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Adamson <alan.adamson@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.18 076/102] nvmet: add a clear_ids attribute for passthru targets
Date:   Tue,  5 Jul 2022 13:58:42 +0200
Message-Id: <20220705115620.568030143@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Adamson <alan.adamson@oracle.com>

commit 34ad61514c4c3657df21a058f9961c3bb2f84ff2 upstream.

If the clear_ids attribute is set to true, the EUI/GUID/UUID is cleared
for the passthru target.  By default, loop targets will set clear_ids to
true.

This resolves an issue where a connect to a passthru target fails when
using a trtype of 'loop' because EUI/GUID/UUID is not unique.

Fixes: 2079f41ec6ff ("nvme: check that EUI/GUID/UUID are globally unique")
Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/configfs.c |   20 ++++++++++++++
 drivers/nvme/target/core.c     |    6 ++++
 drivers/nvme/target/nvmet.h    |    1 
 drivers/nvme/target/passthru.c |   55 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+)

--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -773,11 +773,31 @@ static ssize_t nvmet_passthru_io_timeout
 }
 CONFIGFS_ATTR(nvmet_passthru_, io_timeout);
 
+static ssize_t nvmet_passthru_clear_ids_show(struct config_item *item,
+		char *page)
+{
+	return sprintf(page, "%u\n", to_subsys(item->ci_parent)->clear_ids);
+}
+
+static ssize_t nvmet_passthru_clear_ids_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_subsys *subsys = to_subsys(item->ci_parent);
+	unsigned int clear_ids;
+
+	if (kstrtouint(page, 0, &clear_ids))
+		return -EINVAL;
+	subsys->clear_ids = clear_ids;
+	return count;
+}
+CONFIGFS_ATTR(nvmet_passthru_, clear_ids);
+
 static struct configfs_attribute *nvmet_passthru_attrs[] = {
 	&nvmet_passthru_attr_device_path,
 	&nvmet_passthru_attr_enable,
 	&nvmet_passthru_attr_admin_timeout,
 	&nvmet_passthru_attr_io_timeout,
+	&nvmet_passthru_attr_clear_ids,
 	NULL,
 };
 
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1374,6 +1374,12 @@ u16 nvmet_alloc_ctrl(const char *subsysn
 	ctrl->port = req->port;
 	ctrl->ops = req->ops;
 
+#ifdef CONFIG_NVME_TARGET_PASSTHRU
+	/* By default, set loop targets to clear IDS by default */
+	if (ctrl->port->disc_addr.trtype == NVMF_TRTYPE_LOOP)
+		subsys->clear_ids = 1;
+#endif
+
 	INIT_WORK(&ctrl->async_event_work, nvmet_async_event_work);
 	INIT_LIST_HEAD(&ctrl->async_events);
 	INIT_RADIX_TREE(&ctrl->p2p_ns_map, GFP_KERNEL);
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -249,6 +249,7 @@ struct nvmet_subsys {
 	struct config_group	passthru_group;
 	unsigned int		admin_timeout;
 	unsigned int		io_timeout;
+	unsigned int		clear_ids;
 #endif /* CONFIG_NVME_TARGET_PASSTHRU */
 
 #ifdef CONFIG_BLK_DEV_ZONED
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -30,6 +30,53 @@ void nvmet_passthrough_override_cap(stru
 		ctrl->cap &= ~(1ULL << 43);
 }
 
+static u16 nvmet_passthru_override_id_descs(struct nvmet_req *req)
+{
+	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	u16 status = NVME_SC_SUCCESS;
+	int pos, len;
+	bool csi_seen = false;
+	void *data;
+	u8 csi;
+
+	if (!ctrl->subsys->clear_ids)
+		return status;
+
+	data = kzalloc(NVME_IDENTIFY_DATA_SIZE, GFP_KERNEL);
+	if (!data)
+		return NVME_SC_INTERNAL;
+
+	status = nvmet_copy_from_sgl(req, 0, data, NVME_IDENTIFY_DATA_SIZE);
+	if (status)
+		goto out_free;
+
+	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
+		struct nvme_ns_id_desc *cur = data + pos;
+
+		if (cur->nidl == 0)
+			break;
+		if (cur->nidt == NVME_NIDT_CSI) {
+			memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN);
+			csi_seen = true;
+			break;
+		}
+		len = sizeof(struct nvme_ns_id_desc) + cur->nidl;
+	}
+
+	memset(data, 0, NVME_IDENTIFY_DATA_SIZE);
+	if (csi_seen) {
+		struct nvme_ns_id_desc *cur = data;
+
+		cur->nidt = NVME_NIDT_CSI;
+		cur->nidl = NVME_NIDT_CSI_LEN;
+		memcpy(cur + 1, &csi, NVME_NIDT_CSI_LEN);
+	}
+	status = nvmet_copy_to_sgl(req, 0, data, NVME_IDENTIFY_DATA_SIZE);
+out_free:
+	kfree(data);
+	return status;
+}
+
 static u16 nvmet_passthru_override_id_ctrl(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
@@ -152,6 +199,11 @@ static u16 nvmet_passthru_override_id_ns
 	 */
 	id->mc = 0;
 
+	if (req->sq->ctrl->subsys->clear_ids) {
+		memset(id->nguid, 0, NVME_NIDT_NGUID_LEN);
+		memset(id->eui64, 0, NVME_NIDT_EUI64_LEN);
+	}
+
 	status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
 
 out_free:
@@ -176,6 +228,9 @@ static void nvmet_passthru_execute_cmd_w
 		case NVME_ID_CNS_NS:
 			nvmet_passthru_override_id_ns(req);
 			break;
+		case NVME_ID_CNS_NS_DESC_LIST:
+			nvmet_passthru_override_id_descs(req);
+			break;
 		}
 	} else if (status < 0)
 		status = NVME_SC_INTERNAL;


