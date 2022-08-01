Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA6D586E89
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiHAQ1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiHAQ1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 12:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8C8F313BF
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 09:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659371236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uKOVHziYsiU1y+MgVuXiBUXHStQJ8opX9xrQUMAXIJw=;
        b=buPu+cnon/CTmroGf07s72Dnd0ZkINaHG6WmURf7ESDGW/6mBDoNTtj7RjZ+ClV3MDE+3V
        hGlFyxifexCVof0+zl23is7b2BRX0fp3F3TvzHOEy5p1/YjA8MHiE1mRU9HR/yTdP9go42
        prKlbW0K0akd4K72xhgAW8QpgcMTMng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-d5Vbs5rFPZGodkSsEFNFVw-1; Mon, 01 Aug 2022 12:27:14 -0400
X-MC-Unique: d5Vbs5rFPZGodkSsEFNFVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F8228032F6;
        Mon,  1 Aug 2022 16:27:14 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16A812166B26;
        Mon,  1 Aug 2022 16:27:14 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     hch@lst.de, muneendra.kumar@broadcom.com, james.smart@broadcom.com,
        stable@vger.kernel.org
Subject: [PATCH] Revert "nvme-fc: fold t fc_update_appid into fc_appid_store"
Date:   Mon,  1 Aug 2022 12:27:13 -0400
Message-Id: <20220801162713.17324-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c814153c83a892dfd42026eaa661ae2c1f298792.

The commit c814153c83a8 "nvme-fc: fold t fc_update_appid into fc_appid_store"
changed the userspace interface, because the code that decrements "count"
to remove a trailing '\n' in the parsing results in the decremented value being
incorrectly be returned from the sysfs write.  Fix this by revering the commit.

Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/nvme/host/fc.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 9987797620b6..27f6dfad5d3b 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3873,10 +3873,12 @@ static int fc_parse_cgrpid(const char *buf, u64 *id)
 }
 
 /*
- * Parse and update the appid in the blkcg associated with the cgroupid.
+ * fc_update_appid: Parse and update the appid in the blkcg associated with
+ * cgroupid.
+ * @buf: buf contains both cgrpid and appid info
+ * @count: size of the buffer
  */
-static ssize_t fc_appid_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static int fc_update_appid(const char *buf, size_t count)
 {
 	u64 cgrp_id;
 	int appid_len = 0;
@@ -3904,6 +3906,17 @@ static ssize_t fc_appid_store(struct device *dev,
 		return ret;
 	return count;
 }
+
+static ssize_t fc_appid_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int ret  = 0;
+
+	ret = fc_update_appid(buf, count);
+	if (ret < 0)
+		return -EINVAL;
+	return count;
+}
 static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
 #endif /* CONFIG_BLK_CGROUP_FC_APPID */
 
-- 
2.20.1

