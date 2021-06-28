Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CF03B62D0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhF1Ote (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235749AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E0DD61CF9;
        Mon, 28 Jun 2021 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890857;
        bh=MnprVsjcDNme5Gpfh1oV6pStlfxFLtl7Cdn1rsEoE6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhEF0+ZiD2tiUghFVcta8Q9BgIQzuI8jgPRqgnJZGCOJRw5NNJdNhpbJ/7QpZ66ql
         lsF2jW77G5oyaU52IkCb/eb680ONaB4SMZ1CMKi/qmaNQJneNVYjiBict0Ci7Ho3oc
         8jOI9PZtNKeoPLkmsnWBdI24047BGbqJhqIsS2VclvPlHwm5c9/U8RdQhCoWSlJqJl
         +q5Em7mLeAWd2KOWXVH5UWPo5ixZoJG+msc6HK4L7yMIRRlvFLvwfdCShzy+fS4Keb
         33VTBxXU1MEd9T9WFDKiFW4UEQAoGL5GED9RlD2acQK9POP+rj+1YkrVQEWPhjjl24
         qcJsqnd75floQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Pham <jackp@codeaurora.org>,
        Peter Chen <peter.chen@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 080/109] usb: dwc3: debugfs: Add and remove endpoint dirs dynamically
Date:   Mon, 28 Jun 2021 10:32:36 -0400
Message-Id: <20210628143305.32978-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit 8d396bb0a5b62b326f6be7594d8bd46b088296bd upstream.

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
index 4f75ab3505b7..069db13f3a10 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -653,9 +653,12 @@ static inline const char *dwc3_gadget_generic_cmd_status_string(int status)
 
 
 #ifdef CONFIG_DEBUG_FS
+extern void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep);
 extern void dwc3_debugfs_init(struct dwc3 *);
 extern void dwc3_debugfs_exit(struct dwc3 *);
 #else
+static inline void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
+{  }
 static inline void dwc3_debugfs_init(struct dwc3 *d)
 {  }
 static inline void dwc3_debugfs_exit(struct dwc3 *d)
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index 04ce7c01a09e..58a2479d8e6a 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -725,30 +725,14 @@ static void dwc3_debugfs_create_endpoint_files(struct dwc3_ep *dep,
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
@@ -777,7 +761,6 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 				    &dwc3_testmode_fops);
 		debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root, dwc,
 				    &dwc3_link_state_fops);
-		dwc3_debugfs_create_endpoint_dirs(dwc, root);
 	}
 }
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1396ee529792..c93bed41d988 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2255,6 +2255,8 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
 	INIT_LIST_HEAD(&dep->started_list);
 	INIT_LIST_HEAD(&dep->cancelled_list);
 
+	dwc3_debugfs_create_endpoint_dir(dep);
+
 	return 0;
 }
 
@@ -2298,6 +2300,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 			list_del(&dep->endpoint.ep_list);
 		}
 
+		debugfs_remove_recursive(debugfs_lookup(dep->name, dwc->root));
 		kfree(dep);
 	}
 }
-- 
2.30.2

