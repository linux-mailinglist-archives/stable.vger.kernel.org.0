Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E671199164
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbgCaJRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731070AbgCaJRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F5AC2072E;
        Tue, 31 Mar 2020 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646224;
        bh=mJQ0BF9iUHKFsG4Vqthf273UpMIufUGa1gqjsyWZtUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBUk9ToLa7rtKLGVmvEfVmGCWJ2vEZAu2gLdfwQIAGl1frGZ4qqFKGch6bICZVKY+
         yfhhWj8eKMa3f92JxILOW+oZzHiEl0XVOyI2OOZ92XCLcmvM1aEjRDAffZhdcZy1/6
         ir3MBxMzccWgsUcL6qTpfeLJLV/adEFNHc6rOmlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 121/155] afs: Fix unpinned address list during probing
Date:   Tue, 31 Mar 2020 10:59:21 +0200
Message-Id: <20200331085431.974258624@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 9efcc4a129363187c9bf15338692f107c5c9b6f0 upstream.

When it's probing all of a fileserver's interfaces to find which one is
best to use, afs_do_probe_fileserver() takes a lock on the server record
and notes the pointer to the address list.

It doesn't, however, pin the address list, so as soon as it drops the
lock, there's nothing to stop the address list from being freed under
us.

Fix this by taking a ref on the address list inside the locked section
and dropping it at the end of the function.

Fixes: 3bf0fb6f33dd ("afs: Probe multiple fileservers simultaneously")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/fs_probe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -145,6 +145,7 @@ static int afs_do_probe_fileserver(struc
 	read_lock(&server->fs_lock);
 	ac.alist = rcu_dereference_protected(server->addresses,
 					     lockdep_is_held(&server->fs_lock));
+	afs_get_addrlist(ac.alist);
 	read_unlock(&server->fs_lock);
 
 	atomic_set(&server->probe_outstanding, ac.alist->nr_addrs);
@@ -163,6 +164,7 @@ static int afs_do_probe_fileserver(struc
 
 	if (!in_progress)
 		afs_fs_probe_done(server);
+	afs_put_addrlist(ac.alist);
 	return in_progress;
 }
 


