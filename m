Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F48A39AA03
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhFCSbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 14:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhFCSbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 14:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BAF8613B1;
        Thu,  3 Jun 2021 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622744965;
        bh=PPKw50Xjz1VvI2AUNDtffDF4rwrV0zBsJwp53KN50TY=;
        h=Subject:To:From:Date:From;
        b=FmCM6FtN20xaCYMWjPWqXeiGwg9ccXXo/quRODaW55076x0cDYEyPDrU+fOLtqQ09
         EQnjEqSSaVQoNXBxCHPnprqZHmKZF9ubKOvf3cdQ0oNPaPFevwoFEYL5ysko00U+gV
         So0A6vXMhOKvqH5tzhgo31FuV1Z63kDACqARDvjk=
Subject: patch "usb: dwc3: debugfs: Add and remove endpoint dirs dynamically" added to usb-linus
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Jun 2021 20:29:22 +0200
Message-ID: <162274496225441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8d396bb0a5b62b326f6be7594d8bd46b088296bd Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Sat, 29 May 2021 12:29:32 -0700
Subject: usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

The DWC3 DebugFS directory and files are currently created once
during probe.  This includes creation of subdirectories for each
of the gadget's endpoints.  This works fine for peripheral-only
controllers, as dwc3_core_init_mode() calls dwc3_gadget_init()
just prior to calling dwc3_debugfs_init().

However, for dual-role controllers, dwc3_core_init_mode() will
instead call dwc3_drd_init() which is problematic in a few ways.
First, the initial state must be determined, then dwc3_set_mode()
will have to schedule drd_work and by then dwc3_debugfs_init()
could have already been invoked.  Even if the initial mode is
peripheral, dwc3_gadget_init() happens after the DebugFS files
are created, and worse so if the initial state is host and the
controller switches to peripheral much later.  And secondly,
even if the gadget endpoints' debug entries were successfully
created, if the controller exits peripheral mode, its dwc3_eps
are freed so the debug files would now hold stale references.

So it is best if the DebugFS endpoint entries are created and
removed dynamically at the same time the underlying dwc3_eps are.
Do this by calling dwc3_debugfs_create_endpoint_dir() as each
endpoint is created, and conversely remove the DebugFS entry when
the endpoint is freed.

Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210529192932.22912-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/debug.h   |  3 +++
 drivers/usb/dwc3/debugfs.c | 21 ++-------------------
 drivers/usb/dwc3/gadget.c  |  3 +++
 3 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index d0ac89c5b317..d223c54115f4 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -413,9 +413,12 @@ static inline const char *dwc3_gadget_generic_cmd_status_string(int status)
 
 
 #ifdef CONFIG_DEBUG_FS
+extern void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep);
 extern void dwc3_debugfs_init(struct dwc3 *d);
 extern void dwc3_debugfs_exit(struct dwc3 *d);
 #else
+static inline void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
+{  }
 static inline void dwc3_debugfs_init(struct dwc3 *d)
 {  }
 static inline void dwc3_debugfs_exit(struct dwc3 *d)
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index 7146ee2ac057..5dbbe53269d3 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -886,30 +886,14 @@ static void dwc3_debugfs_create_endpoint_files(struct dwc3_ep *dep,
 	}
 }
 
-static void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep,
-		struct dentry *parent)
+void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
 {
 	struct dentry		*dir;
 
-	dir = debugfs_create_dir(dep->name, parent);
+	dir = debugfs_create_dir(dep->name, dep->dwc->root);
 	dwc3_debugfs_create_endpoint_files(dep, dir);
 }
 
-static void dwc3_debugfs_create_endpoint_dirs(struct dwc3 *dwc,
-		struct dentry *parent)
-{
-	int			i;
-
-	for (i = 0; i < dwc->num_eps; i++) {
-		struct dwc3_ep	*dep = dwc->eps[i];
-
-		if (!dep)
-			continue;
-
-		dwc3_debugfs_create_endpoint_dir(dep, parent);
-	}
-}
-
 void dwc3_debugfs_init(struct dwc3 *dwc)
 {
 	struct dentry		*root;
@@ -940,7 +924,6 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 				&dwc3_testmode_fops);
 		debugfs_create_file("link_state", 0644, root, dwc,
 				    &dwc3_link_state_fops);
-		dwc3_debugfs_create_endpoint_dirs(dwc, root);
 	}
 }
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 88270eee8a48..f14c2aa83759 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2753,6 +2753,8 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
 	INIT_LIST_HEAD(&dep->started_list);
 	INIT_LIST_HEAD(&dep->cancelled_list);
 
+	dwc3_debugfs_create_endpoint_dir(dep);
+
 	return 0;
 }
 
@@ -2796,6 +2798,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 			list_del(&dep->endpoint.ep_list);
 		}
 
+		debugfs_remove_recursive(debugfs_lookup(dep->name, dwc->root));
 		kfree(dep);
 	}
 }
-- 
2.31.1


