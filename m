Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C692B374B7
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfFFNBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:01:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36655 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFNBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 09:01:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so2347492wmm.1
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 06:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=surgut.co.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ybXb/jnfS9f1fII5E7PwPCfGODKC3fugkDh59k3ef3g=;
        b=HpAJM0bcSkIwEsihEGbmENgIesQSRWPHlLq5y3CRN11+FyN7wYJNTl5gl3yEh3Toqc
         g1GbQsFrc/Lovp8APS7cFHqGaJBQ72fGqoKVZcUOFUc8vYE+lAGrA36Zjj0DZBFq6s2j
         KCse1OxYb7uQF0G1yuwaT1/iXMRwTp/io0xxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ybXb/jnfS9f1fII5E7PwPCfGODKC3fugkDh59k3ef3g=;
        b=gQAUi2RfueqUqVvBo7ZQ1G9uTwy8kMhNm6vDAdjuOv5ur82QLOoZFmUn3QmA7RF9n6
         Ip7ce9R0e3PD49XPvEJ9SD8F8jD7KWFn7eiuMJWQ2rYADbQaDS1beHIfW2D5UG9lxfpt
         HgpCMyxtFwBqV5aVz4Q7MRQj9SsjVl9Ej6HeD/PHOrkF0ezFb1praldsfiIU2Ub20VUa
         XqJTzHA+fyZcM3RfzCmF2vYxpeKrRJtq3Xvaa4PHs0qnJ27hui6CprrCS0eG+41cWRDc
         SpZQJ/zGthECN0R6DQKcj+aE/0+kbZNitUB5T5qB+1vEoaAbWbSEm5SgkrouTW/meCpp
         qEUg==
X-Gm-Message-State: APjAAAWBjskQTziiwu8edCMSw7DsItiJREV24JiO1Q+PCtN9W70dCq/M
        /N3mr5FLYHcFEdLW4K/JYgnJYinqVknrEQ==
X-Google-Smtp-Source: APXvYqwdoljEyQU7m9QpBEeUo5sCqQfF8p32N0fk5GYjjwsHT3+zbwXiF098orMEmIWQ37K3N+bpQQ==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr13318094wmc.89.1559826062336;
        Thu, 06 Jun 2019 06:01:02 -0700 (PDT)
Received: from localhost (9.a.8.f.7.f.e.f.f.f.2.3.f.4.a.1.1.4.e.1.c.6.e.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:de6c:1e41:1a4f:32ff:fef7:f8a9])
        by smtp.gmail.com with ESMTPSA id 34sm1179008wre.32.2019.06.06.06.01.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:01:01 -0700 (PDT)
From:   Dimitri John Ledkov <xnox@ubuntu.com>
To:     kernel-team@lists.ubuntu.com
Cc:     Paulo Alcantara <paulo@paulo.ac>, stable@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>
Subject: [SRU][Bionic][PATCH] selinux: use kernel linux/socket.h for genheaders and mdp
Date:   Thu,  6 Jun 2019 14:01:00 +0100
Message-Id: <20190606130100.30278-1-xnox@ubuntu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <paulo@paulo.ac>

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1823429

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
(cherry picked from commit dfbd199a7cfe3e3cd8531e1353cdbd7175bfbc5e)
Signed-off-by: Dimitri John Ledkov <xnox@ubuntu.com>
---
 scripts/selinux/genheaders/genheaders.c | 1 -
 scripts/selinux/mdp/mdp.c               | 1 -
 security/selinux/include/classmap.h     | 1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/selinux/genheaders/genheaders.c b/scripts/selinux/genheaders/genheaders.c
index fa48fabcb330..3cc4893d98cc 100644
--- a/scripts/selinux/genheaders/genheaders.c
+++ b/scripts/selinux/genheaders/genheaders.c
@@ -9,7 +9,6 @@
 #include <string.h>
 #include <errno.h>
 #include <ctype.h>
-#include <sys/socket.h>
 
 struct security_class_mapping {
 	const char *name;
diff --git a/scripts/selinux/mdp/mdp.c b/scripts/selinux/mdp/mdp.c
index ffe8179f5d41..c29fa4a6228d 100644
--- a/scripts/selinux/mdp/mdp.c
+++ b/scripts/selinux/mdp/mdp.c
@@ -32,7 +32,6 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
-#include <sys/socket.h>
 
 static void usage(char *name)
 {
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index acdee7795297..5ae315ab060b 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/capability.h>
+#include <linux/socket.h>
 
 #define COMMON_FILE_SOCK_PERMS "ioctl", "read", "write", "create", \
     "getattr", "setattr", "lock", "relabelfrom", "relabelto", "append", "map"
-- 
2.20.1

