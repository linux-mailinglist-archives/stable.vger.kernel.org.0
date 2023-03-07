Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A151E6AEC31
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCGRxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjCGRwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52CDA6777
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E7D16151B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA6BC4339B;
        Tue,  7 Mar 2023 17:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211231;
        bh=Vt50qn9QXzHBD1d98z5YTIIG1iwrwNBEt14aBdeiHqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfPesqKa/70rWsKTqggey7gHTseKEAvbmD6sEDh/5MtjU0lfvDliTcv1MTzLatBQ2
         K85TziX/jvQjWDs/SGQ1/3YPnV+wx6t7vaaqSXpMZpRzIsCrPqOQru16OPwomGAgB2
         K8gXuH+1VAV8D6b5d2POMIKMGCn7lYngTPpZtVbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH 6.2 0765/1001] s390/ipl: add DEFINE_GENERIC_LOADPARM()
Date:   Tue,  7 Mar 2023 17:58:57 +0100
Message-Id: <20230307170054.955967900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit c676aac66f5b2b03a1090bc6b1891486255f7159 upstream.

In the current code each reipl type implements its own pair of loadparm
show/store functions. Add a macro to deduplicate the code a bit.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Fixes: 87fd22e0ae92 ("s390/ipl: add eckd support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ipl.c | 91 ++++++++++--------------------------------
 1 file changed, 20 insertions(+), 71 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 406766c894fb..d7b433261145 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -888,23 +888,26 @@ static ssize_t reipl_generic_loadparm_store(struct ipl_parameter_block *ipb,
 	return len;
 }
 
-/* FCP wrapper */
-static ssize_t reipl_fcp_loadparm_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *page)
-{
-	return reipl_generic_loadparm_show(reipl_block_fcp, page);
-}
-
-static ssize_t reipl_fcp_loadparm_store(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					const char *buf, size_t len)
-{
-	return reipl_generic_loadparm_store(reipl_block_fcp, buf, len);
-}
-
-static struct kobj_attribute sys_reipl_fcp_loadparm_attr =
-	__ATTR(loadparm, 0644, reipl_fcp_loadparm_show,
-	       reipl_fcp_loadparm_store);
+#define DEFINE_GENERIC_LOADPARM(name)							\
+static ssize_t reipl_##name##_loadparm_show(struct kobject *kobj,			\
+					    struct kobj_attribute *attr, char *page)	\
+{											\
+	return reipl_generic_loadparm_show(reipl_block_##name, page);			\
+}											\
+static ssize_t reipl_##name##_loadparm_store(struct kobject *kobj,			\
+					     struct kobj_attribute *attr,		\
+					     const char *buf, size_t len)		\
+{											\
+	return reipl_generic_loadparm_store(reipl_block_##name, buf, len);		\
+}											\
+static struct kobj_attribute sys_reipl_##name##_loadparm_attr =				\
+	__ATTR(loadparm, 0644, reipl_##name##_loadparm_show,				\
+	       reipl_##name##_loadparm_store)
+
+DEFINE_GENERIC_LOADPARM(fcp);
+DEFINE_GENERIC_LOADPARM(nvme);
+DEFINE_GENERIC_LOADPARM(ccw);
+DEFINE_GENERIC_LOADPARM(nss);
 
 static ssize_t reipl_fcp_clear_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *page)
@@ -994,24 +997,6 @@ DEFINE_IPL_ATTR_RW(reipl_nvme, bootprog, "%lld\n", "%lld\n",
 DEFINE_IPL_ATTR_RW(reipl_nvme, br_lba, "%lld\n", "%lld\n",
 		   reipl_block_nvme->nvme.br_lba);
 
-/* nvme wrapper */
-static ssize_t reipl_nvme_loadparm_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *page)
-{
-	return reipl_generic_loadparm_show(reipl_block_nvme, page);
-}
-
-static ssize_t reipl_nvme_loadparm_store(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					const char *buf, size_t len)
-{
-	return reipl_generic_loadparm_store(reipl_block_nvme, buf, len);
-}
-
-static struct kobj_attribute sys_reipl_nvme_loadparm_attr =
-	__ATTR(loadparm, 0644, reipl_nvme_loadparm_show,
-	       reipl_nvme_loadparm_store);
-
 static struct attribute *reipl_nvme_attrs[] = {
 	&sys_reipl_nvme_fid_attr.attr,
 	&sys_reipl_nvme_nsid_attr.attr,
@@ -1047,38 +1032,6 @@ static struct kobj_attribute sys_reipl_nvme_clear_attr =
 /* CCW reipl device attributes */
 DEFINE_IPL_CCW_ATTR_RW(reipl_ccw, device, reipl_block_ccw->ccw);
 
-/* NSS wrapper */
-static ssize_t reipl_nss_loadparm_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *page)
-{
-	return reipl_generic_loadparm_show(reipl_block_nss, page);
-}
-
-static ssize_t reipl_nss_loadparm_store(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					const char *buf, size_t len)
-{
-	return reipl_generic_loadparm_store(reipl_block_nss, buf, len);
-}
-
-/* CCW wrapper */
-static ssize_t reipl_ccw_loadparm_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *page)
-{
-	return reipl_generic_loadparm_show(reipl_block_ccw, page);
-}
-
-static ssize_t reipl_ccw_loadparm_store(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					const char *buf, size_t len)
-{
-	return reipl_generic_loadparm_store(reipl_block_ccw, buf, len);
-}
-
-static struct kobj_attribute sys_reipl_ccw_loadparm_attr =
-	__ATTR(loadparm, 0644, reipl_ccw_loadparm_show,
-	       reipl_ccw_loadparm_store);
-
 static ssize_t reipl_ccw_clear_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *page)
 {
@@ -1251,10 +1204,6 @@ static struct kobj_attribute sys_reipl_nss_name_attr =
 	__ATTR(name, 0644, reipl_nss_name_show,
 	       reipl_nss_name_store);
 
-static struct kobj_attribute sys_reipl_nss_loadparm_attr =
-	__ATTR(loadparm, 0644, reipl_nss_loadparm_show,
-	       reipl_nss_loadparm_store);
-
 static struct attribute *reipl_nss_attrs[] = {
 	&sys_reipl_nss_name_attr.attr,
 	&sys_reipl_nss_loadparm_attr.attr,
-- 
2.39.2



