Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D75E3788DD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhEJLYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhEJLLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10B216192A;
        Mon, 10 May 2021 11:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644973;
        bh=79VM/OOuYJbqaRc+zfcvIsTNDJKV6sK5o0e9mKn0K+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnHvmkAgPFQWZyJfOpFlX+vFghCMu8O3qUfUPaTuTmi9twTt5pp3a9vo/h4Ta0Pkq
         BZZtFzuJyj2vbcJQC1EuRwXm/SqgZTBE5bmNvsfd7+SDBBddns/psO7aMj9Y2yn261
         8I6s1f1vyUDy7j51/wN4v7jkGXNi/bs7m74Di09M=
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
Subject: [PATCH 5.12 298/384] NFS: fs_context: validate UDP retrans to prevent shift out-of-bounds
Date:   Mon, 10 May 2021 12:21:27 +0200
Message-Id: <20210510102024.630129669@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
@@ -974,6 +974,15 @@ static int nfs23_parse_monolithic(struct
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
@@ -1073,6 +1082,9 @@ out_no_address:
 
 out_invalid_fh:
 	return nfs_invalf(fc, "NFS: invalid root filehandle");
+
+out_invalid_data:
+	return nfs_invalf(fc, "NFS: invalid binary mount data");
 }
 
 #if IS_ENABLED(CONFIG_NFS_V4)


