Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3252011E5A
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfEBP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfEBP2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC2321743;
        Thu,  2 May 2019 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810924;
        bh=ycWLMFE2XQW9iKBkq/OI1zu6AiL1FtXWMJkW9Ii0U3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=og4T5afRqYjY/n/7fBsa5ArotYAB/sgzt7cu0SVhZdI6elHDkxObfp+ky2Ox7JsdB
         gT5cVAIxrGWwyGerAFdutvW0Zwjai1O6THv3+EC30pkHb3PjQeZj0bwhBO9G4sdDuA
         cGNqIzeP3w2qy33r0AlbxeDbFgsKU4bkndt/Pq+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paulo Alcantara <paulo@paulo.ac>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.0 001/101] selinux: use kernel linux/socket.h for genheaders and mdp
Date:   Thu,  2 May 2019 17:20:03 +0200
Message-Id: <20190502143339.556875625@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <paulo@paulo.ac>

commit dfbd199a7cfe3e3cd8531e1353cdbd7175bfbc5e upstream.

When compiling genheaders and mdp from a newer host kernel, the
following error happens:

    In file included from scripts/selinux/genheaders/genheaders.c:18:
    ./security/selinux/include/classmap.h:238:2: error: #error New
    address family defined, please update secclass_map.  #error New
    address family defined, please update secclass_map.  ^~~~~
    make[3]: *** [scripts/Makefile.host:107:
    scripts/selinux/genheaders/genheaders] Error 1 make[2]: ***
    [scripts/Makefile.build:599: scripts/selinux/genheaders] Error 2
    make[1]: *** [scripts/Makefile.build:599: scripts/selinux] Error 2
    make[1]: *** Waiting for unfinished jobs....

Instead of relying on the host definition, include linux/socket.h in
classmap.h to have PF_MAX.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <paulo@paulo.ac>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
[PM: manually merge in mdp.c, subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/selinux/genheaders/genheaders.c |    1 -
 scripts/selinux/mdp/mdp.c               |    1 -
 security/selinux/include/classmap.h     |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/selinux/genheaders/genheaders.c
+++ b/scripts/selinux/genheaders/genheaders.c
@@ -9,7 +9,6 @@
 #include <string.h>
 #include <errno.h>
 #include <ctype.h>
-#include <sys/socket.h>
 
 struct security_class_mapping {
 	const char *name;
--- a/scripts/selinux/mdp/mdp.c
+++ b/scripts/selinux/mdp/mdp.c
@@ -32,7 +32,6 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
-#include <sys/socket.h>
 
 static void usage(char *name)
 {
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/capability.h>
+#include <linux/socket.h>
 
 #define COMMON_FILE_SOCK_PERMS "ioctl", "read", "write", "create", \
     "getattr", "setattr", "lock", "relabelfrom", "relabelto", "append", "map"


