Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D61F42CB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgFIRry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732173AbgFIRrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8218020812;
        Tue,  9 Jun 2020 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724872;
        bh=uSmy0MUZExD4KLwvodL3hKiqYAcr+JzEVorki8ODvb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EgZ3u9qvt2kkqOyyl7/4rNv26P5iSfS9f8kOgfrJ4+lpMB4Rk0s7reB6M2wyjjxr
         Ql1TA+ELoNnCcv2TcQgveYW1KJjV7dCzUllKa+iyz+P6TBaWV4Rco2/TqqnDMBAYY2
         1TqLi/j3veOTiKOpk5Yzyq1jvcUACNc8Y57QnkVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1e925b4b836afe85a1c6@syzkaller-ppc64.appspotmail.com,
        syzbot+587b2421926808309d21@syzkaller-ppc64.appspotmail.com,
        syzbot+58320b7171734bf79d26@syzkaller.appspotmail.com,
        syzbot+d6074fb08bdb2e010520@syzkaller.appspotmail.com,
        Daniel Axtens <dja@axtens.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Akash Goel <akash.goel@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 16/42] kernel/relay.c: handle alloc_percpu returning NULL in relay_open
Date:   Tue,  9 Jun 2020 19:44:22 +0200
Message-Id: <20200609174017.236710601@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit 54e200ab40fc14c863bcc80a51e20b7906608fce upstream.

alloc_percpu() may return NULL, which means chan->buf may be set to NULL.
In that case, when we do *per_cpu_ptr(chan->buf, ...), we dereference an
invalid pointer:

  BUG: Unable to handle kernel data access at 0x7dae0000
  Faulting instruction address: 0xc0000000003f3fec
  ...
  NIP relay_open+0x29c/0x600
  LR relay_open+0x270/0x600
  Call Trace:
     relay_open+0x264/0x600 (unreliable)
     __blk_trace_setup+0x254/0x600
     blk_trace_setup+0x68/0xa0
     sg_ioctl+0x7bc/0x2e80
     do_vfs_ioctl+0x13c/0x1300
     ksys_ioctl+0x94/0x130
     sys_ioctl+0x48/0xb0
     system_call+0x5c/0x68

Check if alloc_percpu returns NULL.

This was found by syzkaller both on x86 and powerpc, and the reproducer
it found on powerpc is capable of hitting the issue as an unprivileged
user.

Fixes: 017c59c042d0 ("relay: Use per CPU constructs for the relay channel buffer pointers")
Reported-by: syzbot+1e925b4b836afe85a1c6@syzkaller-ppc64.appspotmail.com
Reported-by: syzbot+587b2421926808309d21@syzkaller-ppc64.appspotmail.com
Reported-by: syzbot+58320b7171734bf79d26@syzkaller.appspotmail.com
Reported-by: syzbot+d6074fb08bdb2e010520@syzkaller.appspotmail.com
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Akash Goel <akash.goel@intel.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: <stable@vger.kernel.org>	[4.10+]
Link: http://lkml.kernel.org/r/20191219121256.26480-1-dja@axtens.net
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/relay.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -578,6 +578,11 @@ struct rchan *relay_open(const char *bas
 		return NULL;
 
 	chan->buf = alloc_percpu(struct rchan_buf *);
+	if (!chan->buf) {
+		kfree(chan);
+		return NULL;
+	}
+
 	chan->version = RELAYFS_CHANNEL_VERSION;
 	chan->n_subbufs = n_subbufs;
 	chan->subbuf_size = subbuf_size;


