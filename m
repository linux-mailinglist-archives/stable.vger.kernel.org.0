Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3E637849E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhEJKx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhEJKwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71FDD61876;
        Mon, 10 May 2021 10:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643254;
        bh=SqM/N6JzNeVkkCEtOVfKCgRU/lkUPfSXPQSHx4t8blo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl1wi8pcg2zcxMzIkIUxD7b5ml4BmEEJvZjQKXhkuPtJ1N0M6Aaw0wvyi2SUtM3t1
         zsB+BDKWFoUf9RUab1eROh3/KXwGoRlw/PcFBwuK9OIQO/YZALKpTUjxr+qzaO4mrv
         KvZPTBaN2jarxa0lANnHl8inAKJfqSDqOQeB9Me0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com,
        syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 233/299] NFS: fs_context: validate UDP retrans to prevent shift out-of-bounds
Date:   Mon, 10 May 2021 12:20:30 +0200
Message-Id: <20210510102012.656313062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit c09f11ef35955785f92369e25819bf0629df2e59 upstream.

Fix shift out-of-bounds in xprt_calc_majortimeo(). This is caused
by a garbage timeout (retrans) mount option being passed to nfs mount,
in this case from syzkaller.

If the protocol is XPRT_TRANSPORT_UDP, then 'retrans' is a shift
value for a 64-bit long integer, so 'retrans' cannot be >= 64.
If it is >= 64, fail the mount and return an error.

Fixes: 9954bf92c0cd ("NFS: Move mount parameterisation bits into their own file")
Reported-by: syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com
Reported-by: syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/fs_context.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -938,6 +938,15 @@ static int nfs23_parse_monolithic(struct
 			       sizeof(mntfh->data) - mntfh->size);
 
 		/*
+		 * for proto == XPRT_TRANSPORT_UDP, which is what uses
+		 * to_exponential, implying shift: limit the shift value
+		 * to BITS_PER_LONG (majortimeo is unsigned long)
+		 */
+		if (!(data->flags & NFS_MOUNT_TCP)) /* this will be UDP */
+			if (data->retrans >= 64) /* shift value is too large */
+				goto out_invalid_data;
+
+		/*
 		 * Translate to nfs_fs_context, which nfs_fill_super
 		 * can deal with.
 		 */
@@ -1037,6 +1046,9 @@ out_no_address:
 
 out_invalid_fh:
 	return nfs_invalf(fc, "NFS: invalid root filehandle");
+
+out_invalid_data:
+	return nfs_invalf(fc, "NFS: invalid binary mount data");
 }
 
 #if IS_ENABLED(CONFIG_NFS_V4)


