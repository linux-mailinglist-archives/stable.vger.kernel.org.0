Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE79430C002
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhBBNr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhBBNpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6AAF64F75;
        Tue,  2 Feb 2021 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273232;
        bh=ixEoOD4jkCzseN3kj0WMPriJN4qWxoxRMhcouJBB820=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zWjGdxXjkSE1vSZfylERNvW6L89eUFXS68bHBrDd9jXF6rlnhephIfH1sLEBhqlu
         16kFhHzXXxMVK/oBlYGj8jse14WEjCJASewY0mvOeYehIyVuVPtIEa1GfUPrUsh6aq
         vDymjUOrYvmMEWtTOqHYcDYNllhMN2XMZZaZLc20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 029/142] s390: uv: Fix sysfs max number of VCPUs reporting
Date:   Tue,  2 Feb 2021 14:36:32 +0100
Message-Id: <20210202132958.914356931@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

commit e82080e1f456467cc185fe65ee69fe9f9bd0b576 upstream.

The number reported by the query is N-1 and I think people reading the
sysfs file would expect N instead. For users creating VMs there's no
actual difference because KVM's limit is currently below the UV's
limit.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
Cc: stable@vger.kernel.org
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index a15c033f53ca..87641dd65ccf 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -35,7 +35,7 @@ void uv_query_info(void)
 		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
 		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
-		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
+		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0325fc0469b7..7b98d4caee77 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -96,7 +96,7 @@ struct uv_cb_qui {
 	u32 max_num_sec_conf;
 	u64 max_guest_stor_addr;
 	u8  reserved88[158 - 136];
-	u16 max_guest_cpus;
+	u16 max_guest_cpu_id;
 	u8  reserveda0[200 - 160];
 } __packed __aligned(8);
 
@@ -273,7 +273,7 @@ struct uv_info {
 	unsigned long guest_cpu_stor_len;
 	unsigned long max_sec_stor_addr;
 	unsigned int max_num_sec_conf;
-	unsigned short max_guest_cpus;
+	unsigned short max_guest_cpu_id;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 883bfed9f5c2..b2d2ad153067 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -368,7 +368,7 @@ static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
 {
 	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_guest_cpus);
+			uv_info.max_guest_cpu_id + 1);
 }
 
 static struct kobj_attribute uv_query_max_guest_cpus_attr =


