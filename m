Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793692F7BE5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbhAOMbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbhAOMbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1147323A31;
        Fri, 15 Jan 2021 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713839;
        bh=0o18BylfAXQSJpOfX7jEGImKjfKZ3pfLLPB3W9hTJqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+8EViD9RVdVNoeV6bPiPGw9fZofB5UKUhAkS8cGcPXy/q9KTWWmXmHN50LJhK0G0
         WKGPcEah1njwCpW9yggEY3UE7Ibrobn0k28YQip8PVpmK0EhvB0Ya+wB+Fsf1O5V2u
         Vk4bbQaiTZfpR0gp76mV/jJlorJBU2wR7ICg3wpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/25] xcopy: loop over devices using idr helper
Date:   Fri, 15 Jan 2021 13:27:35 +0100
Message-Id: <20210115121956.898162095@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

[ Upstream commit 6906d008b4b06e42cad393ac25bec76fbf31fabd ]

This converts the xcopy code to use the idr helper. The next patch
will drop the g_device_list and make g_device_mutex local to the
target_core_device.c file.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_xcopy.c | 70 +++++++++++++++++-------------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index b380f5e2af47d..065669f9ca8cc 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -52,48 +52,60 @@ static int target_xcopy_gen_naa_ieee(struct se_device *dev, unsigned char *buf)
 	return 0;
 }
 
-static int target_xcopy_locate_se_dev_e4(const unsigned char *dev_wwn,
-					struct se_device **found_dev)
+struct xcopy_dev_search_info {
+	const unsigned char *dev_wwn;
+	struct se_device *found_dev;
+};
+
+static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
+					      void *data)
 {
-	struct se_device *se_dev;
+	struct xcopy_dev_search_info *info = data;
 	unsigned char tmp_dev_wwn[XCOPY_NAA_IEEE_REGEX_LEN];
 	int rc;
 
-	mutex_lock(&g_device_mutex);
-	list_for_each_entry(se_dev, &g_device_list, g_dev_node) {
+	if (!se_dev->dev_attrib.emulate_3pc)
+		return 0;
 
-		if (!se_dev->dev_attrib.emulate_3pc)
-			continue;
+	memset(&tmp_dev_wwn[0], 0, XCOPY_NAA_IEEE_REGEX_LEN);
+	target_xcopy_gen_naa_ieee(se_dev, &tmp_dev_wwn[0]);
 
-		memset(&tmp_dev_wwn[0], 0, XCOPY_NAA_IEEE_REGEX_LEN);
-		target_xcopy_gen_naa_ieee(se_dev, &tmp_dev_wwn[0]);
+	rc = memcmp(&tmp_dev_wwn[0], info->dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
+	if (rc != 0)
+		return 0;
 
-		rc = memcmp(&tmp_dev_wwn[0], dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
-		if (rc != 0)
-			continue;
+	info->found_dev = se_dev;
+	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
 
-		*found_dev = se_dev;
-		pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
+	rc = target_depend_item(&se_dev->dev_group.cg_item);
+	if (rc != 0) {
+		pr_err("configfs_depend_item attempt failed: %d for se_dev: %p\n",
+		       rc, se_dev);
+		return rc;
+	}
 
-		rc = target_depend_item(&se_dev->dev_group.cg_item);
-		if (rc != 0) {
-			pr_err("configfs_depend_item attempt failed:"
-				" %d for se_dev: %p\n", rc, se_dev);
-			mutex_unlock(&g_device_mutex);
-			return rc;
-		}
+	pr_debug("Called configfs_depend_item for se_dev: %p se_dev->se_dev_group: %p\n",
+		 se_dev, &se_dev->dev_group);
+	return 1;
+}
+
+static int target_xcopy_locate_se_dev_e4(const unsigned char *dev_wwn,
+					struct se_device **found_dev)
+{
+	struct xcopy_dev_search_info info;
+	int ret;
 
-		pr_debug("Called configfs_depend_item for se_dev: %p"
-			" se_dev->se_dev_group: %p\n", se_dev,
-			&se_dev->dev_group);
+	memset(&info, 0, sizeof(info));
+	info.dev_wwn = dev_wwn;
 
-		mutex_unlock(&g_device_mutex);
+	ret = target_for_each_device(target_xcopy_locate_se_dev_e4_iter, &info);
+	if (ret == 1) {
+		*found_dev = info.found_dev;
 		return 0;
+	} else {
+		pr_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
+		return -EINVAL;
 	}
-	mutex_unlock(&g_device_mutex);
-
-	pr_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
-	return -EINVAL;
 }
 
 static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op *xop,
-- 
2.27.0



