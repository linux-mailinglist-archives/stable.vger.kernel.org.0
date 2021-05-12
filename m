Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D094C37C6CC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhELPyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237495AbhELPup (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 915BA619CE;
        Wed, 12 May 2021 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833167;
        bh=r8a5BTMH7qyxIO+sw71RGuGghx4ZvLBEPOCJwjwPRZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO2cb/m4xEmFxmEAx4A57rkB5nVKbKd545qR3+wqOJe8dev548YJLQb95t562Vi06
         4TlR5b1JY5l2iRdRWAeecTfp1lzt/oDYngz550SBl24dJbd59ij5hN9ZG7DxQusPRu
         XuJvzjmqWz8IvWCAMzHXNTl9LDbCxOx9ZeA/pJYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.11 045/601] selinux: add proper NULL termination to the secclass_map permissions
Date:   Wed, 12 May 2021 16:42:02 +0200
Message-Id: <20210512144829.309712352@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit e4c82eafb609c2badc56f4e11bc50fcf44b8e9eb upstream.

This patch adds the missing NULL termination to the "bpf" and
"perf_event" object class permission lists.

This missing NULL termination should really only affect the tools
under scripts/selinux, with the most important being genheaders.c,
although in practice this has not been an issue on any of my dev/test
systems.  If the problem were to manifest itself it would likely
result in bogus permissions added to the end of the object class;
thankfully with no access control checks using these bogus
permissions and no policies defining these permissions the impact
would likely be limited to some noise about undefined permissions
during policy load.

Cc: stable@vger.kernel.org
Fixes: ec27c3568a34 ("selinux: bpf: Add selinux check for eBPF syscall operations")
Fixes: da97e18458fb ("perf_event: Add support for LSM and SELinux checks")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/include/classmap.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -242,11 +242,12 @@ struct security_class_mapping secclass_m
 	{ "infiniband_endport",
 	  { "manage_subnet", NULL } },
 	{ "bpf",
-	  {"map_create", "map_read", "map_write", "prog_load", "prog_run"} },
+	  { "map_create", "map_read", "map_write", "prog_load", "prog_run",
+	    NULL } },
 	{ "xdp_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
 	{ "perf_event",
-	  {"open", "cpu", "kernel", "tracepoint", "read", "write"} },
+	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
 	{ "lockdown",
 	  { "integrity", "confidentiality", NULL } },
 	{ NULL }


