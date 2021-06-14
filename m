Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D693A6415
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhFNLUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235414AbhFNLSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E1DE6197F;
        Mon, 14 Jun 2021 10:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667833;
        bh=FTtg2GgJWJZiqrjJwkLxwLLW4J1bi2+7le+q9GIaniY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTjQW8DkeXywdU4QscCDj/sn1nw8FGlEWLuNsGX1Ph189ypaJ7Y2fHq3jFTK/D5YN
         dkHvgnoO12QiHHQtapDVenvxcsS31ecFaVAJQ3OeCajd83z22fux8x+aj74COnaS2P
         4yJLA0g5WSR7bx3925x/EuF5YOlxx3OHU1aVOpx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.12 091/173] usb: dwc3: debugfs: Add and remove endpoint dirs dynamically
Date:   Mon, 14 Jun 2021 12:27:03 +0200
Message-Id: <20210614102701.201298945@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/usb/dwc3/debug.h   |    3 +++
 drivers/usb/dwc3/debugfs.c |   21 ++-------------------
 drivers/usb/dwc3/gadget.c  |    3 +++
 3 files changed, 8 insertions(+), 19 deletions(-)

--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -413,9 +413,12 @@ static inline const char *dwc3_gadget_ge
 
 
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
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -890,30 +890,14 @@ static void dwc3_debugfs_create_endpoint
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
@@ -944,7 +928,6 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 				&dwc3_testmode_fops);
 		debugfs_create_file("link_state", 0644, root, dwc,
 				    &dwc3_link_state_fops);
-		dwc3_debugfs_create_endpoint_dirs(dwc, root);
 	}
 }
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2720,6 +2720,8 @@ static int dwc3_gadget_init_endpoint(str
 	INIT_LIST_HEAD(&dep->started_list);
 	INIT_LIST_HEAD(&dep->cancelled_list);
 
+	dwc3_debugfs_create_endpoint_dir(dep);
+
 	return 0;
 }
 
@@ -2763,6 +2765,7 @@ static void dwc3_gadget_free_endpoints(s
 			list_del(&dep->endpoint.ep_list);
 		}
 
+		debugfs_remove_recursive(debugfs_lookup(dep->name, dwc->root));
 		kfree(dep);
 	}
 }


