Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6907369CDB7
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjBTNwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjBTNwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15EC1E5EA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61079B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C572CC4339B;
        Mon, 20 Feb 2023 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901119;
        bh=DyfMsKxO7PzLaLXkYzrXcYrQ21wzF822oqmwtjjaNI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ts9FzucwG7d3Un9qbeUkFzzgLGe2htPdlSeZXllztsW7EM8TR3nD2bJbAbXm+m+L0
         q5G6AOOQEEvf9yazQAjwb+phpGiqUEaWQvsVhIcHpKJpAIyJeLayEhp62Hx10qrF8C
         UqvsBFNnlHteMLxm8jFf8vDouuprWzQmtBINoGQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sanket Goswami <Sanket.Goswami@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 37/83] platform/x86: amd-pmc: Export Idlemask values based on the APU
Date:   Mon, 20 Feb 2023 14:36:10 +0100
Message-Id: <20230220133554.953960850@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Sanket Goswami <Sanket.Goswami@amd.com>

commit f6045de1f53268131ea75a99b210b869dcc150b2 upstream.

IdleMask is the metric used by the PM firmware to know the status of each
of the Hardware IP blocks monitored by the PM firmware.

Knowing this value is key to get the information of s2idle suspend/resume
status. This value is mapped to PMC scratch registers, retrieve them
accordingly based on the CPU family and the underlying firmware support.

Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20210916124002.2529-1-Sanket.Goswami@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |   76 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -29,6 +29,10 @@
 #define AMD_PMC_REGISTER_RESPONSE	0x980
 #define AMD_PMC_REGISTER_ARGUMENT	0x9BC
 
+/* PMC Scratch Registers */
+#define AMD_PMC_SCRATCH_REG_CZN		0x94
+#define AMD_PMC_SCRATCH_REG_YC		0xD14
+
 /* Base address of SMU for mapping physical address to virtual address */
 #define AMD_PMC_SMU_INDEX_ADDRESS	0xB8
 #define AMD_PMC_SMU_INDEX_DATA		0xBC
@@ -110,6 +114,10 @@ struct amd_pmc_dev {
 	u32 base_addr;
 	u32 cpu_id;
 	u32 active_ips;
+/* SMU version information */
+	u16 major;
+	u16 minor;
+	u16 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -201,6 +209,66 @@ static int s0ix_stats_show(struct seq_fi
 }
 DEFINE_SHOW_ATTRIBUTE(s0ix_stats);
 
+static int amd_pmc_get_smu_version(struct amd_pmc_dev *dev)
+{
+	int rc;
+	u32 val;
+
+	rc = amd_pmc_send_cmd(dev, 0, &val, SMU_MSG_GETSMUVERSION, 1);
+	if (rc)
+		return rc;
+
+	dev->major = (val >> 16) & GENMASK(15, 0);
+	dev->minor = (val >> 8) & GENMASK(7, 0);
+	dev->rev = (val >> 0) & GENMASK(7, 0);
+
+	dev_dbg(dev->dev, "SMU version is %u.%u.%u\n", dev->major, dev->minor, dev->rev);
+
+	return 0;
+}
+
+static int amd_pmc_idlemask_read(struct amd_pmc_dev *pdev, struct device *dev,
+				 struct seq_file *s)
+{
+	u32 val;
+
+	switch (pdev->cpu_id) {
+	case AMD_CPU_ID_CZN:
+		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_CZN);
+		break;
+	case AMD_CPU_ID_YC:
+		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_YC);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (dev)
+		dev_dbg(pdev->dev, "SMU idlemask s0i3: 0x%x\n", val);
+
+	if (s)
+		seq_printf(s, "SMU idlemask : 0x%x\n", val);
+
+	return 0;
+}
+
+static int amd_pmc_idlemask_show(struct seq_file *s, void *unused)
+{
+	struct amd_pmc_dev *dev = s->private;
+	int rc;
+
+	if (dev->major > 56 || (dev->major >= 55 && dev->minor >= 37)) {
+		rc = amd_pmc_idlemask_read(dev, NULL, s);
+		if (rc)
+			return rc;
+	} else {
+		seq_puts(s, "Unsupported SMU version for Idlemask\n");
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(amd_pmc_idlemask);
+
 static void amd_pmc_dbgfs_unregister(struct amd_pmc_dev *dev)
 {
 	debugfs_remove_recursive(dev->dbgfs_dir);
@@ -213,6 +281,8 @@ static void amd_pmc_dbgfs_register(struc
 			    &smu_fw_info_fops);
 	debugfs_create_file("s0ix_stats", 0644, dev->dbgfs_dir, dev,
 			    &s0ix_stats_fops);
+	debugfs_create_file("amd_pmc_idlemask", 0644, dev->dbgfs_dir, dev,
+			    &amd_pmc_idlemask_fops);
 }
 #else
 static inline void amd_pmc_dbgfs_register(struct amd_pmc_dev *dev)
@@ -349,6 +419,8 @@ static int __maybe_unused amd_pmc_suspen
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_RESET, 0);
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_START, 0);
 
+	/* Dump the IdleMask before we send hint to SMU */
+	amd_pmc_idlemask_read(pdev, dev, NULL);
 	msg = amd_pmc_get_os_hint(pdev);
 	rc = amd_pmc_send_cmd(pdev, 1, NULL, msg, 0);
 	if (rc)
@@ -371,6 +443,9 @@ static int __maybe_unused amd_pmc_resume
 	if (rc)
 		dev_err(pdev->dev, "resume failed\n");
 
+	/* Dump the IdleMask to see the blockers */
+	amd_pmc_idlemask_read(pdev, dev, NULL);
+
 	return 0;
 }
 
@@ -458,6 +533,7 @@ static int amd_pmc_probe(struct platform
 	if (err)
 		dev_err(dev->dev, "SMU debugging info not supported on this platform\n");
 
+	amd_pmc_get_smu_version(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
 	return 0;


