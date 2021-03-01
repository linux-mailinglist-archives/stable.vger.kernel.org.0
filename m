Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8191328B8F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbhCAShV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234878AbhCAS3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 830D364FD3;
        Mon,  1 Mar 2021 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621018;
        bh=oSmsppwOFSGJvRWs7tGyuh25TJzFvei7c3QfdnAwgs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZ1dZBzoMm+nMgE19eXlFFC/Lqg4zA4TYrGUa57drueAXOb5AR4y4xhZBeVabjPjO
         phZD9hWHfYhj2mgdkI1/nR9hw5ULDsJz5ou1q3jGrKuuZ6jST4SnwfxeOtiyWq8+VB
         48kza63VEQjY8MM25ONW8qnhLcYwPTdXqGPbT+Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ben Boeckel <mathstuf@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 362/775] watch_queue: Drop references to /dev/watch_queue
Date:   Mon,  1 Mar 2021 17:08:50 +0100
Message-Id: <20210301161219.515059996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 8fe62e0c0e2efa5437f3ee81b65d69e70a45ecd2 ]

The merged API doesn't use a watch_queue device, but instead relies on
pipes, so let the documentation reflect that.

Fixes: f7e47677e39a ("watch_queue: Add a key/keyring notification facility")
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Ben Boeckel <mathstuf@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/security/keys/core.rst | 4 ++--
 samples/Kconfig                      | 2 +-
 samples/watch_queue/watch_test.c     | 2 +-
 security/keys/Kconfig                | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/security/keys/core.rst b/Documentation/security/keys/core.rst
index aa0081685ee11..b3ed5c581034c 100644
--- a/Documentation/security/keys/core.rst
+++ b/Documentation/security/keys/core.rst
@@ -1040,8 +1040,8 @@ The keyctl syscall functions are:
 
      "key" is the ID of the key to be watched.
 
-     "queue_fd" is a file descriptor referring to an open "/dev/watch_queue"
-     which manages the buffer into which notifications will be delivered.
+     "queue_fd" is a file descriptor referring to an open pipe which
+     manages the buffer into which notifications will be delivered.
 
      "filter" is either NULL to remove a watch or a filter specification to
      indicate what events are required from the key.
diff --git a/samples/Kconfig b/samples/Kconfig
index 0ed6e4d71d87b..e76cdfc50e257 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -210,7 +210,7 @@ config SAMPLE_WATCHDOG
 	depends on CC_CAN_LINK
 
 config SAMPLE_WATCH_QUEUE
-	bool "Build example /dev/watch_queue notification consumer"
+	bool "Build example watch_queue notification API consumer"
 	depends on CC_CAN_LINK && HEADERS_INSTALL
 	help
 	  Build example userspace program to use the new mount_notify(),
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_test.c
index 46e618a897fef..8c6cb57d5cfc5 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Use /dev/watch_queue to watch for notifications.
+/* Use watch_queue API to watch for notifications.
  *
  * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index 83bc23409164a..c161642a84841 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -119,7 +119,7 @@ config KEY_NOTIFICATIONS
 	bool "Provide key/keyring change notifications"
 	depends on KEYS && WATCH_QUEUE
 	help
-	  This option provides support for getting change notifications on keys
-	  and keyrings on which the caller has View permission.  This makes use
-	  of the /dev/watch_queue misc device to handle the notification
-	  buffer and provides KEYCTL_WATCH_KEY to enable/disable watches.
+	  This option provides support for getting change notifications
+	  on keys and keyrings on which the caller has View permission.
+	  This makes use of pipes to handle the notification buffer and
+	  provides KEYCTL_WATCH_KEY to enable/disable watches.
-- 
2.27.0



