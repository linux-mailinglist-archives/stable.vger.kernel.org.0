Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2181C329B47
	for <lists+stable@lfdr.de>; Tue,  2 Mar 2021 12:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbhCBBTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 20:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344521AbhCBAUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 19:20:24 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1F4C061788;
        Mon,  1 Mar 2021 16:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=T+DlXRF5bBzpgRo6D9piJcBL+4Ne8yKqxm/gj/HQjiY=; b=cQYeaPzjgUUqWKvk+1OtVg8BC2
        Mv9wiJp0xIGGvGbpLqn4rlobqTpN32KFrM3nG7cgw9gPwwhF+CzAGiUdzhItBf3Bxtw8BOlPPUlzg
        tBEyfeQId+Nmgb5D5V+Ml4x/TA1yO80Nfewaa0MVzHQhBSbj6vNx7w4dB7EDaNdAqh3viGttaBD9N
        OVVvbFuc/rCGUwjy6KjoafF8Jv8bSM7s06d7WIuVMyPj9ULLmDlc66vW/8DV+Zd+xrKDHsBm25c7K
        u8fXUyPBo4TgCf4BvOnZcNGW1r8r63/812Hj43/v+KoGFv3aeKUXbJk8yUZheQ91jyYbjRYqU9jIs
        5llSPHdA==;
Received: from [2601:1c0:6280:3f0::3ba4] (helo=merlin.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lGslF-0007vO-Q6; Tue, 02 Mar 2021 00:19:38 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com,
        syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH] NFS: fs_context: validate UDP retrans to prevent shift out-of-bounds
Date:   Mon,  1 Mar 2021 16:19:30 -0800
Message-Id: <20210302001930.2253-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/nfs/fs_context.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- lnx-512-rc1.orig/fs/nfs/fs_context.c
+++ lnx-512-rc1/fs/nfs/fs_context.c
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
