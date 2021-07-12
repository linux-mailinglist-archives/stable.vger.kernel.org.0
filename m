Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12943C4BEC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239771AbhGLHAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242360AbhGLHAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C515A61156;
        Mon, 12 Jul 2021 06:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073033;
        bh=tEL3krEBJM2K5rNwIGUtcm5FIQQZgrqjaj/HQA/dPiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+plEQALAJm8GzGplHXuAJSMCpLi/fiKgSZbhPkUisHeOgzEyUNL1Y/Qw05BLn1cl
         rO6xs7bB3+4zibRhmXEIKECyb6hDnWwEgJrYHZH7NhWIarJLKdOXUyOXIAI9ke0O9B
         UPDa2yPmMKPyRWYWAFDEC0WsAFjBnB2hQHt5wTCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.12 077/700] s390: mm: Fix secure storage access exception handling
Date:   Mon, 12 Jul 2021 08:02:40 +0200
Message-Id: <20210712060935.578094165@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

commit 85b18d7b5e7ffefb2f076186511d39c4990aa005 upstream.

Turns out that the bit 61 in the TEID is not always 1 and if that's
the case the address space ID and the address are
unpredictable. Without an address and its address space ID we can't
export memory and hence we can only send a SIGSEGV to the process or
panic the kernel depending on who caused the exception.

Unfortunately bit 61 is only reliable if we have the "misc" UV feature
bit.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions handlers")
Cc: stable@vger.kernel.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/boot/uv.c        |    1 +
 arch/s390/include/asm/uv.h |    8 +++++++-
 arch/s390/kernel/uv.c      |   10 ++++++++++
 arch/s390/mm/fault.c       |   26 ++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -36,6 +36,7 @@ void uv_query_info(void)
 		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
 		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
+		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -73,6 +73,10 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 };
 
+enum uv_feat_ind {
+	BIT_UV_FEAT_MISC = 0,
+};
+
 struct uv_cb_header {
 	u16 len;
 	u16 cmd;	/* Command Code */
@@ -97,7 +101,8 @@ struct uv_cb_qui {
 	u64 max_guest_stor_addr;
 	u8  reserved88[158 - 136];
 	u16 max_guest_cpu_id;
-	u8  reserveda0[200 - 160];
+	u64 uv_feature_indications;
+	u8  reserveda0[200 - 168];
 } __packed __aligned(8);
 
 /* Initialize Ultravisor */
@@ -274,6 +279,7 @@ struct uv_info {
 	unsigned long max_sec_stor_addr;
 	unsigned int max_num_sec_conf;
 	unsigned short max_guest_cpu_id;
+	unsigned long uv_feature_indications;
 };
 
 extern struct uv_info uv_info;
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -364,6 +364,15 @@ static ssize_t uv_query_facilities(struc
 static struct kobj_attribute uv_query_facilities_attr =
 	__ATTR(facilities, 0444, uv_query_facilities, NULL);
 
+static ssize_t uv_query_feature_indications(struct kobject *kobj,
+					    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lx\n", uv_info.uv_feature_indications);
+}
+
+static struct kobj_attribute uv_query_feature_indications_attr =
+	__ATTR(feature_indications, 0444, uv_query_feature_indications, NULL);
+
 static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
 {
@@ -396,6 +405,7 @@ static struct kobj_attribute uv_query_ma
 
 static struct attribute *uv_query_attrs[] = {
 	&uv_query_facilities_attr.attr,
+	&uv_query_feature_indications_attr.attr,
 	&uv_query_max_guest_cpus_attr.attr,
 	&uv_query_max_guest_vms_attr.attr,
 	&uv_query_max_guest_addr_attr.attr,
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -791,6 +791,32 @@ void do_secure_storage_access(struct pt_
 	struct page *page;
 	int rc;
 
+	/*
+	 * bit 61 tells us if the address is valid, if it's not we
+	 * have a major problem and should stop the kernel or send a
+	 * SIGSEGV to the process. Unfortunately bit 61 is not
+	 * reliable without the misc UV feature so we need to check
+	 * for that as well.
+	 */
+	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
+	    !test_bit_inv(61, &regs->int_parm_long)) {
+		/*
+		 * When this happens, userspace did something that it
+		 * was not supposed to do, e.g. branching into secure
+		 * memory. Trigger a segmentation fault.
+		 */
+		if (user_mode(regs)) {
+			send_sig(SIGSEGV, current, 0);
+			return;
+		}
+
+		/*
+		 * The kernel should never run into this case and we
+		 * have no way out of this situation.
+		 */
+		panic("Unexpected PGM 0x3d with TEID bit 61=0");
+	}
+
 	switch (get_fault_type(regs)) {
 	case USER_FAULT:
 		mm = current->mm;


