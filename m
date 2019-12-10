Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C891198AA
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfLJVdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbfLJVdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0AA24654;
        Tue, 10 Dec 2019 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013630;
        bh=tVWIOcwtsUD+cqMK4L1fGArHlYXqP6Xo+X7a3GHCS1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N93cUA3dn281JwfQJ9nsZYPKGo3gkGNAxNKO/A9PjIVz7DJBfa8397TFAKCraC3Pu
         x//QB31phQaUvY4sX/emynML4CQXwvF3BE0Kdh3brTk8BcynPUsUUF6MVTMSXC/DE0
         6T7qxhPd5kj94GPgcPmiRWM5W/AR6c/Y+V8D3+Bs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        tony camuso <tcamuso@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 072/177] ipmi: Don't allow device module unload when in use
Date:   Tue, 10 Dec 2019 16:30:36 -0500
Message-Id: <20191210213221.11921-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit cbb79863fc3175ed5ac506465948b02a893a8235 ]

If something has the IPMI driver open, don't allow the device
module to be unloaded.  Before it would unload and the user would
get errors on use.

This change is made on user request, and it makes it consistent
with the I2C driver, which has the same behavior.

It does change things a little bit with respect to kernel users.
If the ACPI or IPMI watchdog (or any other kernel user) has
created a user, then the device module cannot be unloaded.  Before
it could be unloaded,

This does not affect hot-plug.  If the device goes away (it's on
something removable that is removed or is hot-removed via sysfs)
then it still behaves as it did before.

Reported-by: tony camuso <tcamuso@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: tony camuso <tcamuso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 23 ++++++++++++++++-------
 include/linux/ipmi_smi.h            | 12 ++++++++----
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 84c17f936c09c..91f2d92194892 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -447,6 +447,8 @@ enum ipmi_stat_indexes {
 
 #define IPMI_IPMB_NUM_SEQ	64
 struct ipmi_smi {
+	struct module *owner;
+
 	/* What interface number are we? */
 	int intf_num;
 
@@ -1139,6 +1141,11 @@ int ipmi_create_user(unsigned int          if_num,
 	if (rv)
 		goto out_kfree;
 
+	if (!try_module_get(intf->owner)) {
+		rv = -ENODEV;
+		goto out_kfree;
+	}
+
 	/* Note that each existing user holds a refcount to the interface. */
 	kref_get(&intf->refcount);
 
@@ -1269,6 +1276,7 @@ static void _ipmi_destroy_user(struct ipmi_user *user)
 	}
 
 	kref_put(&intf->refcount, intf_free);
+	module_put(intf->owner);
 }
 
 int ipmi_destroy_user(struct ipmi_user *user)
@@ -2384,7 +2392,7 @@ static int __get_device_id(struct ipmi_smi *intf, struct bmc_device *bmc)
  * been recently fetched, this will just use the cached data.  Otherwise
  * it will run a new fetch.
  *
- * Except for the first time this is called (in ipmi_register_smi()),
+ * Except for the first time this is called (in ipmi_add_smi()),
  * this will always return good data;
  */
 static int __bmc_get_device_id(struct ipmi_smi *intf, struct bmc_device *bmc,
@@ -3304,10 +3312,11 @@ static void redo_bmc_reg(struct work_struct *work)
 	kref_put(&intf->refcount, intf_free);
 }
 
-int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
-		      void		       *send_info,
-		      struct device            *si_dev,
-		      unsigned char            slave_addr)
+int ipmi_add_smi(struct module         *owner,
+		 const struct ipmi_smi_handlers *handlers,
+		 void		       *send_info,
+		 struct device         *si_dev,
+		 unsigned char         slave_addr)
 {
 	int              i, j;
 	int              rv;
@@ -3333,7 +3342,7 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 		return rv;
 	}
 
-
+	intf->owner = owner;
 	intf->bmc = &intf->tmp_bmc;
 	INIT_LIST_HEAD(&intf->bmc->intfs);
 	mutex_init(&intf->bmc->dyn_mutex);
@@ -3440,7 +3449,7 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 
 	return rv;
 }
-EXPORT_SYMBOL(ipmi_register_smi);
+EXPORT_SYMBOL(ipmi_add_smi);
 
 static void deliver_smi_err_response(struct ipmi_smi *intf,
 				     struct ipmi_smi_msg *msg,
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 7d5fd38d5282a..1995ce1467890 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -211,10 +211,14 @@ static inline int ipmi_demangle_device_id(uint8_t netfn, uint8_t cmd,
  * is called, and the lower layer must get the interface from that
  * call.
  */
-int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
-		      void                     *send_info,
-		      struct device            *dev,
-		      unsigned char            slave_addr);
+int ipmi_add_smi(struct module            *owner,
+		 const struct ipmi_smi_handlers *handlers,
+		 void                     *send_info,
+		 struct device            *dev,
+		 unsigned char            slave_addr);
+
+#define ipmi_register_smi(handlers, send_info, dev, slave_addr) \
+	ipmi_add_smi(THIS_MODULE, handlers, send_info, dev, slave_addr)
 
 /*
  * Remove a low-level interface from the IPMI driver.  This will
-- 
2.20.1

