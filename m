Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDEB226B64
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgGTPpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgGTPpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:45:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4AA020773;
        Mon, 20 Jul 2020 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259908;
        bh=dMQRb6eL3N6kbnSI06CwekLsUO6WeYv69PRx7EWIyCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlN8qXk34XmGeYEPFkaZPLgJvuRuo5QIYK0cX2B0mss0z+2hfRRdctPiPt6LM8HwT
         Rp2+Zy5BZajJpdkv8c/ERmxiteqsDJH3O9pRsUBxtfkLFDbvXak2/F8XijuV2WA2zU
         uVZPy2CJfM/kGiy1eBmz3OicrscBiIKHHbX1VPfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 037/125] dm: use noio when sending kobject event
Date:   Mon, 20 Jul 2020 17:36:16 +0200
Message-Id: <20200720152804.792063334@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 6958c1c640af8c3f40fa8a2eee3b5b905d95b677 upstream.

kobject_uevent may allocate memory and it may be called while there are dm
devices suspended. The allocation may recurse into a suspended device,
causing a deadlock. We must set the noio flag when sending a uevent.

The observed deadlock was reported here:
https://www.redhat.com/archives/dm-devel/2020-March/msg00025.html

Reported-by: Khazhismel Kumykov <khazhy@google.com>
Reported-by: Tahsin Erdogan <tahsin@google.com>
Reported-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/blkpg.h>
 #include <linux/bio.h>
@@ -2665,17 +2666,25 @@ EXPORT_SYMBOL_GPL(dm_internal_resume_fas
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		       unsigned cookie)
 {
+	int r;
+	unsigned noio_flag;
 	char udev_cookie[DM_COOKIE_LENGTH];
 	char *envp[] = { udev_cookie, NULL };
 
+	noio_flag = memalloc_noio_save();
+
 	if (!cookie)
-		return kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
+		r = kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
 	else {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		return kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
-					  action, envp);
+		r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
+				       action, envp);
 	}
+
+	memalloc_noio_restore(noio_flag);
+
+	return r;
 }
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)


