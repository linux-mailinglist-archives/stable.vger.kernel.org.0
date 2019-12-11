Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBCA11B7F7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfLKPLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbfLKPLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52EE1208C3;
        Wed, 11 Dec 2019 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077063;
        bh=iyuGJf9G6EmqN8jHkMhWfFG9XlRJQLrcIUlcEYQCP1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=likJcpMjbebq1FTXUJnvhjyi8toiJyHvozbofpbWIP3WbIfjxJ6mYqDXc49/jGsN7
         O2z3mah4zMXyBSiIdeMrDe+LsseihilvAekBC/GyFwSqFV+92nAaKHqnf2GiMkg4DY
         4eQ5QNOpSYXdWvAcELy6zTxy0CN4OFDDaEWVwzHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 83/92] rfkill: allocate static minor
Date:   Wed, 11 Dec 2019 16:06:14 +0100
Message-Id: <20191211150300.973343815@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

commit 8670b2b8b029a6650d133486be9d2ace146fd29a upstream.

udev has a feature of creating /dev/<node> device-nodes if it finds
a devnode:<node> modalias. This allows for auto-loading of modules that
provide the node. This requires to use a statically allocated minor
number for misc character devices.

However, rfkill uses dynamic minor numbers and prevents auto-loading
of the module. So allocate the next static misc minor number and use
it for rfkill.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Link: https://lore.kernel.org/r/20191024174042.19851-1-marcel@holtmann.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>

---
 include/linux/miscdevice.h |    1 +
 net/rfkill/core.c          |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -57,6 +57,7 @@
 #define UHID_MINOR		239
 #define USERIO_MINOR		240
 #define VHOST_VSOCK_MINOR	241
+#define RFKILL_MINOR		242
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1316,10 +1316,12 @@ static const struct file_operations rfki
 	.llseek		= no_llseek,
 };
 
+#define RFKILL_NAME "rfkill"
+
 static struct miscdevice rfkill_miscdev = {
-	.name	= "rfkill",
 	.fops	= &rfkill_fops,
-	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= RFKILL_NAME,
+	.minor	= RFKILL_MINOR,
 };
 
 static int __init rfkill_init(void)
@@ -1371,3 +1373,6 @@ static void __exit rfkill_exit(void)
 	class_unregister(&rfkill_class);
 }
 module_exit(rfkill_exit);
+
+MODULE_ALIAS_MISCDEV(RFKILL_MINOR);
+MODULE_ALIAS("devname:" RFKILL_NAME);


