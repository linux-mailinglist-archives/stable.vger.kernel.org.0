Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2F4FD543
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbiDLHXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353781AbiDLHQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:16:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB933AA6F;
        Mon, 11 Apr 2022 23:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A55A3B81B44;
        Tue, 12 Apr 2022 06:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D37C385A6;
        Tue, 12 Apr 2022 06:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746644;
        bh=UB/tJv4/q5zkVk/rlbowu6zqsWnia8C3Gg5X6fFnLH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrZ2y9b/To5DTUnjC2TxunR1zE7Ie4mjh0UazNruScjK53wWic3WAJoCD9pOpSN3q
         Mt/NVoSE5W6iC2CX2cT42Qh4BctY5k21gnayw2P+4YCfxHwgammRnC2HEgeu7LdV2J
         LiA9ctKeGN8HUvRcr96qeLNqz/0k8NgKwjqg/XAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 080/285] scsi: hisi_sas: Limit users changing debugfs BIST count value
Date:   Tue, 12 Apr 2022 08:28:57 +0200
Message-Id: <20220412062945.973138703@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 286ce4c65fbdf5eb9d4d5f4e4997c4e32bf1b073 ]

Add a file operation for "cnt" file under bist directory, so users can only
read "cnt" or clear "cnt" to zero, but cannot randomly modify.

Link: https://lore.kernel.org/r/1645703489-87194-6-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 52 +++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8392463d57de..20763f187886 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3968,6 +3968,54 @@ static const struct file_operations debugfs_bist_phy_v3_hw_fops = {
 	.owner = THIS_MODULE,
 };
 
+static ssize_t debugfs_bist_cnt_v3_hw_write(struct file *filp,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	unsigned int cnt;
+	int val;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	val = kstrtouint_from_user(buf, count, 0, &cnt);
+	if (val)
+		return val;
+
+	if (cnt)
+		return -EINVAL;
+
+	hisi_hba->debugfs_bist_cnt = 0;
+	return count;
+}
+
+static int debugfs_bist_cnt_v3_hw_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+
+	seq_printf(s, "%u\n", hisi_hba->debugfs_bist_cnt);
+
+	return 0;
+}
+
+static int debugfs_bist_cnt_v3_hw_open(struct inode *inode,
+					  struct file *filp)
+{
+	return single_open(filp, debugfs_bist_cnt_v3_hw_show,
+			   inode->i_private);
+}
+
+static const struct file_operations debugfs_bist_cnt_v3_hw_ops = {
+	.open = debugfs_bist_cnt_v3_hw_open,
+	.read = seq_read,
+	.write = debugfs_bist_cnt_v3_hw_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static const struct {
 	int		value;
 	char		*name;
@@ -4605,8 +4653,8 @@ static void debugfs_bist_init_v3_hw(struct hisi_hba *hisi_hba)
 	debugfs_create_file("phy_id", 0600, hisi_hba->debugfs_bist_dentry,
 			    hisi_hba, &debugfs_bist_phy_v3_hw_fops);
 
-	debugfs_create_u32("cnt", 0600, hisi_hba->debugfs_bist_dentry,
-			   &hisi_hba->debugfs_bist_cnt);
+	debugfs_create_file("cnt", 0600, hisi_hba->debugfs_bist_dentry,
+			    hisi_hba, &debugfs_bist_cnt_v3_hw_ops);
 
 	debugfs_create_file("loopback_mode", 0600,
 			    hisi_hba->debugfs_bist_dentry,
-- 
2.35.1



