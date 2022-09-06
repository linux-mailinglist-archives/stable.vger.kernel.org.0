Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122875AECE6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241485AbiIFOOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241329AbiIFOMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15121876B1;
        Tue,  6 Sep 2022 06:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C9661555;
        Tue,  6 Sep 2022 13:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FA6C433C1;
        Tue,  6 Sep 2022 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471979;
        bh=gZPtUq3Oyj/etwkcxj2jiAiGJuFla+aQKtjsG3KEmD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ce3tTZfuAXbaGAXvPiGkvADfdqzN2MR5a5zSTKIscy4DBX0Kg37cTq5E6RVYMTCNU
         +e7oBJP7RVIhWqe2gQI423XuvHZuMaXQy5IAABaENOBPUTKbbUaKvYniW+1V7Bfd91
         c8MM9ZHsBVaCuuo6sDhi9kw8qTs3ipRsO64az8Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>
Subject: [PATCH 5.19 075/155] firmware_loader: Fix memory leak in firmware upload
Date:   Tue,  6 Sep 2022 15:30:23 +0200
Message-Id: <20220906132832.591349145@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Russ Weight <russell.h.weight@intel.com>

commit 789bba82f63c3e81dce426ba457fc7905b30ac6e upstream.

In the case of firmware-upload, an instance of struct fw_upload is
allocated in firmware_upload_register(). This data needs to be freed
in fw_dev_release(). Create a new fw_upload_free() function in
sysfs_upload.c to handle the firmware-upload specific memory frees
and incorporate the missing kfree call for the fw_upload structure.

Fixes: 97730bbb242c ("firmware_loader: Add firmware-upload support")
Cc: stable <stable@kernel.org>
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Link: https://lore.kernel.org/r/20220831002518.465274-1-russell.h.weight@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/sysfs.c        | 7 +++----
 drivers/base/firmware_loader/sysfs.h        | 5 +++++
 drivers/base/firmware_loader/sysfs_upload.c | 9 +++++++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/base/firmware_loader/sysfs.c b/drivers/base/firmware_loader/sysfs.c
index 77bad32c481a..5b66b3d1fa16 100644
--- a/drivers/base/firmware_loader/sysfs.c
+++ b/drivers/base/firmware_loader/sysfs.c
@@ -93,10 +93,9 @@ static void fw_dev_release(struct device *dev)
 {
 	struct fw_sysfs *fw_sysfs = to_fw_sysfs(dev);
 
-	if (fw_sysfs->fw_upload_priv) {
-		free_fw_priv(fw_sysfs->fw_priv);
-		kfree(fw_sysfs->fw_upload_priv);
-	}
+	if (fw_sysfs->fw_upload_priv)
+		fw_upload_free(fw_sysfs);
+
 	kfree(fw_sysfs);
 }
 
diff --git a/drivers/base/firmware_loader/sysfs.h b/drivers/base/firmware_loader/sysfs.h
index 5d8ff1675c79..df1d5add698f 100644
--- a/drivers/base/firmware_loader/sysfs.h
+++ b/drivers/base/firmware_loader/sysfs.h
@@ -106,12 +106,17 @@ extern struct device_attribute dev_attr_cancel;
 extern struct device_attribute dev_attr_remaining_size;
 
 int fw_upload_start(struct fw_sysfs *fw_sysfs);
+void fw_upload_free(struct fw_sysfs *fw_sysfs);
 umode_t fw_upload_is_visible(struct kobject *kobj, struct attribute *attr, int n);
 #else
 static inline int fw_upload_start(struct fw_sysfs *fw_sysfs)
 {
 	return 0;
 }
+
+static inline void fw_upload_free(struct fw_sysfs *fw_sysfs)
+{
+}
 #endif
 
 #endif /* __FIRMWARE_SYSFS_H */
diff --git a/drivers/base/firmware_loader/sysfs_upload.c b/drivers/base/firmware_loader/sysfs_upload.c
index 63e15bddd80c..a0af8f5f13d8 100644
--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -264,6 +264,15 @@ int fw_upload_start(struct fw_sysfs *fw_sysfs)
 	return 0;
 }
 
+void fw_upload_free(struct fw_sysfs *fw_sysfs)
+{
+	struct fw_upload_priv *fw_upload_priv = fw_sysfs->fw_upload_priv;
+
+	free_fw_priv(fw_sysfs->fw_priv);
+	kfree(fw_upload_priv->fw_upload);
+	kfree(fw_upload_priv);
+}
+
 /**
  * firmware_upload_register() - register for the firmware upload sysfs API
  * @module: kernel module of this device
-- 
2.37.3



