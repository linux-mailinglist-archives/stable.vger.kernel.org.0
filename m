Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270293962DE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhEaPBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhEaPAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 11:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E43661403;
        Mon, 31 May 2021 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469712;
        bh=+zHc6AgY64ZJHAGJnE+oOZyZ6Zb7emTltqoycBavkDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPqyY0cgUyddHl7Or1oIIMQgmesc8un/szfXNB2SisvUlwqW4QZwxWLFpYQuf+hl5
         jGEUiVUWFD+C1f9EHHOf2L4yIgBm4RN9bcydnL+ySxb827oNshHMKTlolDnz/l+gpx
         wSlXoPr5B33CjNXl0M/3dVQtY+jPRyaK3yi01Bmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH 5.12 291/296] bpftool: Add sock_release help info for cgroup attach/prog load command
Date:   Mon, 31 May 2021 15:15:46 +0200
Message-Id: <20210531130713.489512489@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

commit a8deba8547e39f26440101164a3bbc2899c5b305 upstream.

The help information was not added at the time when the function got added.
Fix this and add the missing information to its cli, documentation and bash
completion.

Fixes: db94cc0b4805 ("bpftool: Add support for BPF_CGROUP_INET_SOCK_RELEASE")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20210525014139.323859-1-liujian56@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    4 +++-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    6 +++---
 tools/bpf/bpftool/cgroup.c                         |    3 ++-
 tools/bpf/bpftool/prog.c                           |    2 +-
 5 files changed, 10 insertions(+), 7 deletions(-)

--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -30,7 +30,8 @@ CGROUP COMMANDS
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
 |               **getpeername4** | **getpeername6** | **getsockname4** | **getsockname6** | **sendmsg4** |
-|               **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** }
+|               **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** |
+|               **sock_release** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -106,6 +107,7 @@ DESCRIPTION
 		  **getpeername6** call to getpeername(2) for an inet6 socket (since 5.8);
 		  **getsockname4** call to getsockname(2) for an inet4 socket (since 5.8);
 		  **getsockname6** call to getsockname(2) for an inet6 socket (since 5.8).
+		  **sock_release** closing an userspace inet socket (since 5.9).
 
 	**bpftool cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 		  Detach *PROG* from the cgroup *CGROUP* and attach type
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -44,7 +44,7 @@ PROG COMMANDS
 |		**cgroup/connect4** | **cgroup/connect6** | **cgroup/getpeername4** | **cgroup/getpeername6** |
 |               **cgroup/getsockname4** | **cgroup/getsockname6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
 |		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl** |
-|		**cgroup/getsockopt** | **cgroup/setsockopt** |
+|		**cgroup/getsockopt** | **cgroup/setsockopt** | **cgroup/sock_release** |
 |		**struct_ops** | **fentry** | **fexit** | **freplace** | **sk_lookup**
 |	}
 |       *ATTACH_TYPE* := {
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -478,7 +478,7 @@ _bpftool()
                                 cgroup/recvmsg4 cgroup/recvmsg6 \
                                 cgroup/post_bind4 cgroup/post_bind6 \
                                 cgroup/sysctl cgroup/getsockopt \
-                                cgroup/setsockopt struct_ops \
+                                cgroup/setsockopt cgroup/sock_release struct_ops \
                                 fentry fexit freplace sk_lookup" -- \
                                                    "$cur" ) )
                             return 0
@@ -1008,7 +1008,7 @@ _bpftool()
                         device bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
                         getpeername4 getpeername6 getsockname4 getsockname6 \
                         sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl getsockopt \
-                        setsockopt'
+                        setsockopt sock_release'
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag name'
                     case $prev in
@@ -1019,7 +1019,7 @@ _bpftool()
                         ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
                         post_bind4|post_bind6|connect4|connect6|getpeername4|\
                         getpeername6|getsockname4|getsockname6|sendmsg4|sendmsg6|\
-                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt)
+                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt|sock_release)
                             COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
                                 "$cur" ) )
                             return 0
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -28,7 +28,8 @@
 	"                        connect6 | getpeername4 | getpeername6 |\n"   \
 	"                        getsockname4 | getsockname6 | sendmsg4 |\n"   \
 	"                        sendmsg6 | recvmsg4 | recvmsg6 |\n"           \
-	"                        sysctl | getsockopt | setsockopt }"
+	"                        sysctl | getsockopt | setsockopt |\n"	       \
+	"                        sock_release }"
 
 static unsigned int query_flags;
 
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2137,7 +2137,7 @@ static int do_help(int argc, char **argv
 		"                 cgroup/getpeername4 | cgroup/getpeername6 |\n"
 		"                 cgroup/getsockname4 | cgroup/getsockname6 | cgroup/sendmsg4 |\n"
 		"                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
-		"                 cgroup/getsockopt | cgroup/setsockopt |\n"
+		"                 cgroup/getsockopt | cgroup/setsockopt | cgroup/sock_release |\n"
 		"                 struct_ops | fentry | fexit | freplace | sk_lookup }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"


