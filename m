Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D3F4BE522
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351458AbiBUJt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352870AbiBUJr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161BB3137C;
        Mon, 21 Feb 2022 01:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9824060EDF;
        Mon, 21 Feb 2022 09:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547B0C340E9;
        Mon, 21 Feb 2022 09:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435238;
        bh=D5Zet3fWd1I0mhDm7rhLOoBPxdtRFwoGV+a1WtIhFSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMmMwKgthJMxGXALETfOrV9u9gxk6EjtDy/QC0bRNyi1b4NXWRt/HqHIJqu/KQdqq
         +M06TE3YjPnPUGKNnDXJmCZu/LZtjZ3shQ2GnpS917KREkQeB/eGwKbgmmNOcbrrZd
         UaaxLFzSTgN40Df6SLAtBzNgS3YC4nUENHfmP+Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.16 076/227] iwlwifi: remove deprecated broadcast filtering feature
Date:   Mon, 21 Feb 2022 09:48:15 +0100
Message-Id: <20220221084937.399520230@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Luca Coelho <luciano.coelho@intel.com>

commit 92883a524ae918736a7b8acef98698075507b8c1 upstream.

This feature has been deprecated and should not be used anymore.  With
newer firmwares, namely *-67.ucode and above, trying to use it causes an
assertion failure in the FW, similar to this:

[Tue Jan 11 20:05:24 2022] iwlwifi 0000:04:00.0: 0x00001062 | ADVANCED_SYSASSERT

In order to prevent this feature from being used, remove it entirely
and get rid of the Kconfig option that
enables it (IWLWIFI_BCAST_FILTERING).

Fixes: cbaa6aeedee5 ("iwlwifi: bump FW API to 67 for AX devices")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215488
Cc: stable@vger.kernel.org # 5.16.x
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20220128144623.9241e049f13e.Ia4f282813ca2ddd24c13427823519113f2bbebf2@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig           |   13 -
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |    5 
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h   |   88 ------
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  203 ----------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  240 -------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   13 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |    1 
 8 files changed, 565 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -79,19 +79,6 @@ config IWLWIFI_OPMODE_MODULAR
 comment "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"
 	depends on IWLDVM=n && IWLMVM=n
 
-config IWLWIFI_BCAST_FILTERING
-	bool "Enable broadcast filtering"
-	depends on IWLMVM
-	help
-	  Say Y here to enable default bcast filtering configuration.
-
-	  Enabling broadcast filtering will drop any incoming wireless
-	  broadcast frames, except some very specific predefined
-	  patterns (e.g. incoming arp requests).
-
-	  If unsure, don't enable this option, as some programs might
-	  expect incoming broadcasts for their normal operations.
-
 menu "Debugging Options"
 
 config IWLWIFI_DEBUG
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -506,11 +506,6 @@ enum iwl_legacy_cmds {
 	DEBUG_LOG_MSG = 0xf7,
 
 	/**
-	 * @BCAST_FILTER_CMD: &struct iwl_bcast_filter_cmd
-	 */
-	BCAST_FILTER_CMD = 0xcf,
-
-	/**
 	 * @MCAST_FILTER_CMD: &struct iwl_mcast_filter_cmd
 	 */
 	MCAST_FILTER_CMD = 0xd0,
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
@@ -36,92 +36,4 @@ struct iwl_mcast_filter_cmd {
 	u8 addr_list[0];
 } __packed; /* MCAST_FILTERING_CMD_API_S_VER_1 */
 
-#define MAX_BCAST_FILTERS 8
-#define MAX_BCAST_FILTER_ATTRS 2
-
-/**
- * enum iwl_mvm_bcast_filter_attr_offset - written by fw for each Rx packet
- * @BCAST_FILTER_OFFSET_PAYLOAD_START: offset is from payload start.
- * @BCAST_FILTER_OFFSET_IP_END: offset is from ip header end (i.e.
- *	start of ip payload).
- */
-enum iwl_mvm_bcast_filter_attr_offset {
-	BCAST_FILTER_OFFSET_PAYLOAD_START = 0,
-	BCAST_FILTER_OFFSET_IP_END = 1,
-};
-
-/**
- * struct iwl_fw_bcast_filter_attr - broadcast filter attribute
- * @offset_type:	&enum iwl_mvm_bcast_filter_attr_offset.
- * @offset:	starting offset of this pattern.
- * @reserved1:	reserved
- * @val:	value to match - big endian (MSB is the first
- *		byte to match from offset pos).
- * @mask:	mask to match (big endian).
- */
-struct iwl_fw_bcast_filter_attr {
-	u8 offset_type;
-	u8 offset;
-	__le16 reserved1;
-	__be32 val;
-	__be32 mask;
-} __packed; /* BCAST_FILTER_ATT_S_VER_1 */
-
-/**
- * enum iwl_mvm_bcast_filter_frame_type - filter frame type
- * @BCAST_FILTER_FRAME_TYPE_ALL: consider all frames.
- * @BCAST_FILTER_FRAME_TYPE_IPV4: consider only ipv4 frames
- */
-enum iwl_mvm_bcast_filter_frame_type {
-	BCAST_FILTER_FRAME_TYPE_ALL = 0,
-	BCAST_FILTER_FRAME_TYPE_IPV4 = 1,
-};
-
-/**
- * struct iwl_fw_bcast_filter - broadcast filter
- * @discard: discard frame (1) or let it pass (0).
- * @frame_type: &enum iwl_mvm_bcast_filter_frame_type.
- * @reserved1: reserved
- * @num_attrs: number of valid attributes in this filter.
- * @attrs: attributes of this filter. a filter is considered matched
- *	only when all its attributes are matched (i.e. AND relationship)
- */
-struct iwl_fw_bcast_filter {
-	u8 discard;
-	u8 frame_type;
-	u8 num_attrs;
-	u8 reserved1;
-	struct iwl_fw_bcast_filter_attr attrs[MAX_BCAST_FILTER_ATTRS];
-} __packed; /* BCAST_FILTER_S_VER_1 */
-
-/**
- * struct iwl_fw_bcast_mac - per-mac broadcast filtering configuration.
- * @default_discard: default action for this mac (discard (1) / pass (0)).
- * @reserved1: reserved
- * @attached_filters: bitmap of relevant filters for this mac.
- */
-struct iwl_fw_bcast_mac {
-	u8 default_discard;
-	u8 reserved1;
-	__le16 attached_filters;
-} __packed; /* BCAST_MAC_CONTEXT_S_VER_1 */
-
-/**
- * struct iwl_bcast_filter_cmd - broadcast filtering configuration
- * @disable: enable (0) / disable (1)
- * @max_bcast_filters: max number of filters (MAX_BCAST_FILTERS)
- * @max_macs: max number of macs (NUM_MAC_INDEX_DRIVER)
- * @reserved1: reserved
- * @filters: broadcast filters
- * @macs: broadcast filtering configuration per-mac
- */
-struct iwl_bcast_filter_cmd {
-	u8 disable;
-	u8 max_bcast_filters;
-	u8 max_macs;
-	u8 reserved1;
-	struct iwl_fw_bcast_filter filters[MAX_BCAST_FILTERS];
-	struct iwl_fw_bcast_mac macs[NUM_MAC_INDEX_DRIVER];
-} __packed; /* BCAST_FILTERING_HCMD_API_S_VER_1 */
-
 #endif /* __iwl_fw_api_filter_h__ */
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -182,7 +182,6 @@ struct iwl_ucode_capa {
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
  * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: General support for uAPSD
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
- * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
  * @IWL_UCODE_TLV_FLAGS_EBS_SUPPORT: this uCode image supports EBS.
  */
 enum iwl_ucode_tlv_flag {
@@ -197,7 +196,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_EBS_SUPPORT		= BIT(25),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
-	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
 };
 
 typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1361,189 +1361,6 @@ static ssize_t iwl_dbgfs_dbg_time_point_
 	return count;
 }
 
-#define ADD_TEXT(...) pos += scnprintf(buf + pos, bufsz - pos, __VA_ARGS__)
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-static ssize_t iwl_dbgfs_bcast_filters_read(struct file *file,
-					    char __user *user_buf,
-					    size_t count, loff_t *ppos)
-{
-	struct iwl_mvm *mvm = file->private_data;
-	struct iwl_bcast_filter_cmd cmd;
-	const struct iwl_fw_bcast_filter *filter;
-	char *buf;
-	int bufsz = 1024;
-	int i, j, pos = 0;
-	ssize_t ret;
-
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	mutex_lock(&mvm->mutex);
-	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd)) {
-		ADD_TEXT("None\n");
-		mutex_unlock(&mvm->mutex);
-		goto out;
-	}
-	mutex_unlock(&mvm->mutex);
-
-	for (i = 0; cmd.filters[i].attrs[0].mask; i++) {
-		filter = &cmd.filters[i];
-
-		ADD_TEXT("Filter [%d]:\n", i);
-		ADD_TEXT("\tDiscard=%d\n", filter->discard);
-		ADD_TEXT("\tFrame Type: %s\n",
-			 filter->frame_type ? "IPv4" : "Generic");
-
-		for (j = 0; j < ARRAY_SIZE(filter->attrs); j++) {
-			const struct iwl_fw_bcast_filter_attr *attr;
-
-			attr = &filter->attrs[j];
-			if (!attr->mask)
-				break;
-
-			ADD_TEXT("\tAttr [%d]: offset=%d (from %s), mask=0x%x, value=0x%x reserved=0x%x\n",
-				 j, attr->offset,
-				 attr->offset_type ? "IP End" :
-						     "Payload Start",
-				 be32_to_cpu(attr->mask),
-				 be32_to_cpu(attr->val),
-				 le16_to_cpu(attr->reserved1));
-		}
-	}
-out:
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_bcast_filters_write(struct iwl_mvm *mvm, char *buf,
-					     size_t count, loff_t *ppos)
-{
-	int pos, next_pos;
-	struct iwl_fw_bcast_filter filter = {};
-	struct iwl_bcast_filter_cmd cmd;
-	u32 filter_id, attr_id, mask, value;
-	int err = 0;
-
-	if (sscanf(buf, "%d %hhi %hhi %n", &filter_id, &filter.discard,
-		   &filter.frame_type, &pos) != 3)
-		return -EINVAL;
-
-	if (filter_id >= ARRAY_SIZE(mvm->dbgfs_bcast_filtering.cmd.filters) ||
-	    filter.frame_type > BCAST_FILTER_FRAME_TYPE_IPV4)
-		return -EINVAL;
-
-	for (attr_id = 0; attr_id < ARRAY_SIZE(filter.attrs);
-	     attr_id++) {
-		struct iwl_fw_bcast_filter_attr *attr =
-				&filter.attrs[attr_id];
-
-		if (pos >= count)
-			break;
-
-		if (sscanf(&buf[pos], "%hhi %hhi %i %i %n",
-			   &attr->offset, &attr->offset_type,
-			   &mask, &value, &next_pos) != 4)
-			return -EINVAL;
-
-		attr->mask = cpu_to_be32(mask);
-		attr->val = cpu_to_be32(value);
-		if (mask)
-			filter.num_attrs++;
-
-		pos += next_pos;
-	}
-
-	mutex_lock(&mvm->mutex);
-	memcpy(&mvm->dbgfs_bcast_filtering.cmd.filters[filter_id],
-	       &filter, sizeof(filter));
-
-	/* send updated bcast filtering configuration */
-	if (iwl_mvm_firmware_running(mvm) &&
-	    mvm->dbgfs_bcast_filtering.override &&
-	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
-		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
-					   sizeof(cmd), &cmd);
-	mutex_unlock(&mvm->mutex);
-
-	return err ?: count;
-}
-
-static ssize_t iwl_dbgfs_bcast_filters_macs_read(struct file *file,
-						 char __user *user_buf,
-						 size_t count, loff_t *ppos)
-{
-	struct iwl_mvm *mvm = file->private_data;
-	struct iwl_bcast_filter_cmd cmd;
-	char *buf;
-	int bufsz = 1024;
-	int i, pos = 0;
-	ssize_t ret;
-
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	mutex_lock(&mvm->mutex);
-	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd)) {
-		ADD_TEXT("None\n");
-		mutex_unlock(&mvm->mutex);
-		goto out;
-	}
-	mutex_unlock(&mvm->mutex);
-
-	for (i = 0; i < ARRAY_SIZE(cmd.macs); i++) {
-		const struct iwl_fw_bcast_mac *mac = &cmd.macs[i];
-
-		ADD_TEXT("Mac [%d]: discard=%d attached_filters=0x%x\n",
-			 i, mac->default_discard, mac->attached_filters);
-	}
-out:
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_bcast_filters_macs_write(struct iwl_mvm *mvm,
-						  char *buf, size_t count,
-						  loff_t *ppos)
-{
-	struct iwl_bcast_filter_cmd cmd;
-	struct iwl_fw_bcast_mac mac = {};
-	u32 mac_id, attached_filters;
-	int err = 0;
-
-	if (!mvm->bcast_filters)
-		return -ENOENT;
-
-	if (sscanf(buf, "%d %hhi %i", &mac_id, &mac.default_discard,
-		   &attached_filters) != 3)
-		return -EINVAL;
-
-	if (mac_id >= ARRAY_SIZE(cmd.macs) ||
-	    mac.default_discard > 1 ||
-	    attached_filters >= BIT(ARRAY_SIZE(cmd.filters)))
-		return -EINVAL;
-
-	mac.attached_filters = cpu_to_le16(attached_filters);
-
-	mutex_lock(&mvm->mutex);
-	memcpy(&mvm->dbgfs_bcast_filtering.cmd.macs[mac_id],
-	       &mac, sizeof(mac));
-
-	/* send updated bcast filtering configuration */
-	if (iwl_mvm_firmware_running(mvm) &&
-	    mvm->dbgfs_bcast_filtering.override &&
-	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
-		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
-					   sizeof(cmd), &cmd);
-	mutex_unlock(&mvm->mutex);
-
-	return err ?: count;
-}
-#endif
-
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -1873,11 +1690,6 @@ MVM_DEBUGFS_WRITE_FILE_OPS(inject_beacon
 
 MVM_DEBUGFS_READ_FILE_OPS(uapsd_noagg_bssids);
 
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
-#endif
-
 #ifdef CONFIG_ACPI
 MVM_DEBUGFS_READ_FILE_OPS(sar_geo_profile);
 #endif
@@ -2088,21 +1900,6 @@ void iwl_mvm_dbgfs_register(struct iwl_m
 
 	MVM_DEBUGFS_ADD_FILE(uapsd_noagg_bssids, mvm->debugfs_dir, S_IRUSR);
 
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
-		bcast_dir = debugfs_create_dir("bcast_filtering",
-					       mvm->debugfs_dir);
-
-		debugfs_create_bool("override", 0600, bcast_dir,
-				    &mvm->dbgfs_bcast_filtering.override);
-
-		MVM_DEBUGFS_ADD_FILE_ALIAS("filters", bcast_filters,
-					   bcast_dir, 0600);
-		MVM_DEBUGFS_ADD_FILE_ALIAS("macs", bcast_filters_macs,
-					   bcast_dir, 0600);
-	}
-#endif
-
 #ifdef CONFIG_PM_SLEEP
 	MVM_DEBUGFS_ADD_FILE(d3_test, mvm->debugfs_dir, 0400);
 	debugfs_create_bool("d3_wake_sysassert", 0600, mvm->debugfs_dir,
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -55,79 +55,6 @@ static const struct ieee80211_iface_comb
 	},
 };
 
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-/*
- * Use the reserved field to indicate magic values.
- * these values will only be used internally by the driver,
- * and won't make it to the fw (reserved will be 0).
- * BC_FILTER_MAGIC_IP - configure the val of this attribute to
- *	be the vif's ip address. in case there is not a single
- *	ip address (0, or more than 1), this attribute will
- *	be skipped.
- * BC_FILTER_MAGIC_MAC - set the val of this attribute to
- *	the LSB bytes of the vif's mac address
- */
-enum {
-	BC_FILTER_MAGIC_NONE = 0,
-	BC_FILTER_MAGIC_IP,
-	BC_FILTER_MAGIC_MAC,
-};
-
-static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
-	{
-		/* arp */
-		.discard = 0,
-		.frame_type = BCAST_FILTER_FRAME_TYPE_ALL,
-		.attrs = {
-			{
-				/* frame type - arp, hw type - ethernet */
-				.offset_type =
-					BCAST_FILTER_OFFSET_PAYLOAD_START,
-				.offset = sizeof(rfc1042_header),
-				.val = cpu_to_be32(0x08060001),
-				.mask = cpu_to_be32(0xffffffff),
-			},
-			{
-				/* arp dest ip */
-				.offset_type =
-					BCAST_FILTER_OFFSET_PAYLOAD_START,
-				.offset = sizeof(rfc1042_header) + 2 +
-					  sizeof(struct arphdr) +
-					  ETH_ALEN + sizeof(__be32) +
-					  ETH_ALEN,
-				.mask = cpu_to_be32(0xffffffff),
-				/* mark it as special field */
-				.reserved1 = cpu_to_le16(BC_FILTER_MAGIC_IP),
-			},
-		},
-	},
-	{
-		/* dhcp offer bcast */
-		.discard = 0,
-		.frame_type = BCAST_FILTER_FRAME_TYPE_IPV4,
-		.attrs = {
-			{
-				/* udp dest port - 68 (bootp client)*/
-				.offset_type = BCAST_FILTER_OFFSET_IP_END,
-				.offset = offsetof(struct udphdr, dest),
-				.val = cpu_to_be32(0x00440000),
-				.mask = cpu_to_be32(0xffff0000),
-			},
-			{
-				/* dhcp - lsb bytes of client hw address */
-				.offset_type = BCAST_FILTER_OFFSET_IP_END,
-				.offset = 38,
-				.mask = cpu_to_be32(0xffffffff),
-				/* mark it as special field */
-				.reserved1 = cpu_to_le16(BC_FILTER_MAGIC_MAC),
-			},
-		},
-	},
-	/* last filter must be empty */
-	{},
-};
-#endif
-
 static const struct cfg80211_pmsr_capabilities iwl_mvm_pmsr_capa = {
 	.max_peers = IWL_MVM_TOF_MAX_APS,
 	.report_ap_tsf = 1,
@@ -683,11 +610,6 @@ int iwl_mvm_mac_setup_register(struct iw
 	}
 #endif
 
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-	/* assign default bcast filtering configuration */
-	mvm->bcast_filters = iwl_mvm_default_bcast_filters;
-#endif
-
 	ret = iwl_mvm_leds_init(mvm);
 	if (ret)
 		return ret;
@@ -1803,162 +1725,6 @@ static void iwl_mvm_config_iface_filter(
 	mutex_unlock(&mvm->mutex);
 }
 
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-struct iwl_bcast_iter_data {
-	struct iwl_mvm *mvm;
-	struct iwl_bcast_filter_cmd *cmd;
-	u8 current_filter;
-};
-
-static void
-iwl_mvm_set_bcast_filter(struct ieee80211_vif *vif,
-			 const struct iwl_fw_bcast_filter *in_filter,
-			 struct iwl_fw_bcast_filter *out_filter)
-{
-	struct iwl_fw_bcast_filter_attr *attr;
-	int i;
-
-	memcpy(out_filter, in_filter, sizeof(*out_filter));
-
-	for (i = 0; i < ARRAY_SIZE(out_filter->attrs); i++) {
-		attr = &out_filter->attrs[i];
-
-		if (!attr->mask)
-			break;
-
-		switch (attr->reserved1) {
-		case cpu_to_le16(BC_FILTER_MAGIC_IP):
-			if (vif->bss_conf.arp_addr_cnt != 1) {
-				attr->mask = 0;
-				continue;
-			}
-
-			attr->val = vif->bss_conf.arp_addr_list[0];
-			break;
-		case cpu_to_le16(BC_FILTER_MAGIC_MAC):
-			attr->val = *(__be32 *)&vif->addr[2];
-			break;
-		default:
-			break;
-		}
-		attr->reserved1 = 0;
-		out_filter->num_attrs++;
-	}
-}
-
-static void iwl_mvm_bcast_filter_iterator(void *_data, u8 *mac,
-					  struct ieee80211_vif *vif)
-{
-	struct iwl_bcast_iter_data *data = _data;
-	struct iwl_mvm *mvm = data->mvm;
-	struct iwl_bcast_filter_cmd *cmd = data->cmd;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_fw_bcast_mac *bcast_mac;
-	int i;
-
-	if (WARN_ON(mvmvif->id >= ARRAY_SIZE(cmd->macs)))
-		return;
-
-	bcast_mac = &cmd->macs[mvmvif->id];
-
-	/*
-	 * enable filtering only for associated stations, but not for P2P
-	 * Clients
-	 */
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p ||
-	    !vif->bss_conf.assoc)
-		return;
-
-	bcast_mac->default_discard = 1;
-
-	/* copy all configured filters */
-	for (i = 0; mvm->bcast_filters[i].attrs[0].mask; i++) {
-		/*
-		 * Make sure we don't exceed our filters limit.
-		 * if there is still a valid filter to be configured,
-		 * be on the safe side and just allow bcast for this mac.
-		 */
-		if (WARN_ON_ONCE(data->current_filter >=
-				 ARRAY_SIZE(cmd->filters))) {
-			bcast_mac->default_discard = 0;
-			bcast_mac->attached_filters = 0;
-			break;
-		}
-
-		iwl_mvm_set_bcast_filter(vif,
-					 &mvm->bcast_filters[i],
-					 &cmd->filters[data->current_filter]);
-
-		/* skip current filter if it contains no attributes */
-		if (!cmd->filters[data->current_filter].num_attrs)
-			continue;
-
-		/* attach the filter to current mac */
-		bcast_mac->attached_filters |=
-				cpu_to_le16(BIT(data->current_filter));
-
-		data->current_filter++;
-	}
-}
-
-bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
-				    struct iwl_bcast_filter_cmd *cmd)
-{
-	struct iwl_bcast_iter_data iter_data = {
-		.mvm = mvm,
-		.cmd = cmd,
-	};
-
-	if (IWL_MVM_FW_BCAST_FILTER_PASS_ALL)
-		return false;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->max_bcast_filters = ARRAY_SIZE(cmd->filters);
-	cmd->max_macs = ARRAY_SIZE(cmd->macs);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	/* use debugfs filters/macs if override is configured */
-	if (mvm->dbgfs_bcast_filtering.override) {
-		memcpy(cmd->filters, &mvm->dbgfs_bcast_filtering.cmd.filters,
-		       sizeof(cmd->filters));
-		memcpy(cmd->macs, &mvm->dbgfs_bcast_filtering.cmd.macs,
-		       sizeof(cmd->macs));
-		return true;
-	}
-#endif
-
-	/* if no filters are configured, do nothing */
-	if (!mvm->bcast_filters)
-		return false;
-
-	/* configure and attach these filters for each associated sta vif */
-	ieee80211_iterate_active_interfaces(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_bcast_filter_iterator, &iter_data);
-
-	return true;
-}
-
-static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm)
-{
-	struct iwl_bcast_filter_cmd cmd;
-
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING))
-		return 0;
-
-	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
-		return 0;
-
-	return iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
-				    sizeof(cmd), &cmd);
-}
-#else
-static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm)
-{
-	return 0;
-}
-#endif
-
 static int iwl_mvm_update_mu_groups(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif)
 {
@@ -2469,7 +2235,6 @@ static void iwl_mvm_bss_info_changed_sta
 		}
 
 		iwl_mvm_recalc_multicast(mvm);
-		iwl_mvm_configure_bcast_filter(mvm);
 
 		/* reset rssi values */
 		mvmvif->bf_data.ave_beacon_signal = 0;
@@ -2519,11 +2284,6 @@ static void iwl_mvm_bss_info_changed_sta
 		}
 	}
 
-	if (changes & BSS_CHANGED_ARP_FILTER) {
-		IWL_DEBUG_MAC80211(mvm, "arp filter changed\n");
-		iwl_mvm_configure_bcast_filter(mvm);
-	}
-
 	if (changes & BSS_CHANGED_BANDWIDTH)
 		iwl_mvm_apply_fw_smps_request(vif);
 }
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -872,17 +872,6 @@ struct iwl_mvm {
 	/* rx chain antennas set through debugfs for the scan command */
 	u8 scan_rx_ant;
 
-#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-	/* broadcast filters to configure for each associated station */
-	const struct iwl_fw_bcast_filter *bcast_filters;
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	struct {
-		bool override;
-		struct iwl_bcast_filter_cmd cmd;
-	} dbgfs_bcast_filtering;
-#endif
-#endif
-
 	/* Internal station */
 	struct iwl_mvm_int_sta aux_sta;
 	struct iwl_mvm_int_sta snif_sta;
@@ -1570,8 +1559,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm);
 int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm);
 
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm);
-bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
-				    struct iwl_bcast_filter_cmd *cmd);
 
 /*
  * FW notifications / CMD responses handlers
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -474,7 +474,6 @@ static const struct iwl_hcmd_names iwl_m
 	HCMD_NAME(MCC_CHUB_UPDATE_CMD),
 	HCMD_NAME(MARKER_CMD),
 	HCMD_NAME(BT_PROFILE_NOTIFICATION),
-	HCMD_NAME(BCAST_FILTER_CMD),
 	HCMD_NAME(MCAST_FILTER_CMD),
 	HCMD_NAME(REPLY_SF_CFG_CMD),
 	HCMD_NAME(REPLY_BEACON_FILTERING_CMD),


