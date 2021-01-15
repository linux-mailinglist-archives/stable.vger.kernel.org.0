Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2B2F79E7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387842AbhAOMmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388278AbhAOMjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF7A23888;
        Fri, 15 Jan 2021 12:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714317;
        bh=HvGjlr0NkP8qDvvSuKBGgmWDMwrS+S6YdTC/8r9VMbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2reZjckTtULx3CGjU6F1nSOGjOxLjiHtfAKWwEy9lNzz1WQnHukFIxjuTDHB7LYu2
         Qj0Yc6j6lLXhg7sR2n3pOvGJ85aMh/kw+GNmbhPKyAL5JuCh7lKBSlFMDmeq8LhaiP
         KCRrXbCy9cDpwfQ/ngnggbxt/PsSU7dvpxJor+Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.10 082/103] bpftool: Fix compilation failure for net.o with older glibc
Date:   Fri, 15 Jan 2021 13:28:15 +0100
Message-Id: <20210115122009.988712427@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

commit 6f02b540d7597f357bc6ee711346761045d4e108 upstream.

For older glibc ~2.17, #include'ing both linux/if.h and net/if.h
fails due to complaints about redefinition of interface flags:

  CC       net.o
In file included from net.c:13:0:
/usr/include/linux/if.h:71:2: error: redeclaration of enumerator ‘IFF_UP’
  IFF_UP    = 1<<0,  /* sysfs */
  ^
/usr/include/net/if.h:44:5: note: previous definition of ‘IFF_UP’ was here
     IFF_UP = 0x1,  /* Interface is up.  */

The issue was fixed in kernel headers in [1], but since compilation
of net.c picks up system headers the problem can recur.

Dropping #include <linux/if.h> resolves the issue and it is
not needed for compilation anyhow.

[1] https://lore.kernel.org/netdev/1461512707-23058-1-git-send-email-mikko.rapeli__34748.27880641$1462831734$gmane$org@iki.fi/

Fixes: f6f3bac08ff9 ("tools/bpf: bpftool: add net support")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/1609948746-15369-1-git-send-email-alan.maguire@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/bpf/bpftool/net.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 #include <net/if.h>
-#include <linux/if.h>
 #include <linux/rtnetlink.h>
 #include <linux/socket.h>
 #include <linux/tc_act/tc_bpf.h>


