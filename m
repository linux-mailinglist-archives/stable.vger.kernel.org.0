Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A025937CB03
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbhELQdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241372AbhELQ1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88A3B61968;
        Wed, 12 May 2021 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834711;
        bh=9JiJsMH+EkRdphQ7ftzKtTJy5Fs5K8ebwSf/X9b/hfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EDkAwr4e0k9+yz3jctkUaYESk0LkHa6dX5tbX/rgcorz6b8P8iEbXcRwIfsnj2Vh
         35/YD4hcbuIaFn0qALTfTFNI68kA/+XBcgQxu4XsYKTYAN1lfv5aIDBgWADJLPQWj0
         NlCxOOaM/IXYZ4pqDXcfhUapn6QetTk9bGOcQwAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.12 053/677] selinux: add proper NULL termination to the secclass_map permissions
Date:   Wed, 12 May 2021 16:41:39 +0200
Message-Id: <20210512144838.965523655@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
 	{ "anon_inode",


