Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACABB4A3672
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 14:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347076AbiA3NHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 08:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347045AbiA3NHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 08:07:10 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0974C061714;
        Sun, 30 Jan 2022 05:07:09 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 2C4C9C01E; Sun, 30 Jan 2022 14:07:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643548025; bh=WzIC+v4+UrPRQhCkj2dIOPEwY3tXxjMgRe2rgwvMEZY=;
        h=From:To:Cc:Subject:Date:From;
        b=A/eTCDAYeVJIxX5tbvB12/4/652HP6a+M3FpLRcse+Sc/SEjEpfTDPYqr1LDWJh1v
         mKGkEQeNIvKnL7zXo0of38hdfHCmurruuAq1RVuh/WRkZ29Azka74FfWZ2FMPKPa7E
         OFzMujNAmlWwYryiv62a1n0xCvaQolZw3yZ4TE8ZNDfbF1x4cKDIA1DmHKvN902c1R
         CHdTs98gR/dogx6TZ8YrpA42dOjVmuR57wwsv/Oe8z1gb3TAn8r2u07I6qF7QdICHx
         wkg7Bzw9y1kIem4Y6uVmScgtSqVubnftN4Gv2MpiYgmAfNmiW/4DcWSBnHarALyF7n
         aXKrUoaYdnxKQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C0393C01B;
        Sun, 30 Jan 2022 14:07:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643548024; bh=WzIC+v4+UrPRQhCkj2dIOPEwY3tXxjMgRe2rgwvMEZY=;
        h=From:To:Cc:Subject:Date:From;
        b=f92Lnoe7HN1ufdYJSbNXcyVI/iMnA8btHbNuPezzvvhOQa41J/nJcEc7dibLwCS/G
         YeXUlLJlorVVVAc8ayShvappXCEwRTXw5F+AqipPbYGKmZx4rMs4qqDYrNN1VLfrGX
         7MXSoeDVhEvNk6X/KUVxjalJXF/G5wdlvkpC3qhwkzyNBfkbF27SOy5jmqhZXFgqxK
         vFqD7IzAAuFQw0AF9Xnm5zcLo+PSxECkbrsiGK3GQGuYfpKbXdVW+/cyBgRvLoly8V
         I8r1O5bdT9amTUA81wljgpkQ72J2meQt5rJNlmxiy2rkVPoTm+p1o/tP2m6WtYBamU
         fmdHqvKGboAbA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b42ff00b;
        Sun, 30 Jan 2022 13:06:57 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     v9fs-developer@lists.sourceforge.net, ericvh@gmail.com,
        lucho@ionkov.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        stable@vger.kernel.org, ron minnich <rminnich@gmail.com>,
        ng@0x80.stream
Subject: [PATCH] Revert "fs/9p: search open fids first"
Date:   Sun, 30 Jan 2022 22:06:51 +0900
Message-Id: <20220130130651.712293-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 478ba09edc1f2f2ee27180a06150cb2d1a686f9c.

That commit was meant as a fix for setattrs with by fd (e.g. ftruncate)
to use an open fid instead of the first fid it found on lookup.
The proper fix for that is to use the fid associated with the open file
struct, available in iattr->ia_file for such operations, and was
actually done just before in 66246641609b ("9p: retrieve fid from file
when file instance exist.")
As such, this commit is no longer required.

Furthermore, changing lookup to return open fids first had unwanted side
effects, as it turns out the protocol forbids the use of open fids for
further walks (e.g. clone_fid) and we broke mounts for some servers
enforcing this rule.

Note this only reverts to the old working behaviour, but it's still
possible for lookup to return open fids if dentry->d_fsdata is not set,
so more work is needed to make sure we respect this rule in the future,
for example by adding a flag to the lookup functions to only match
certain fid open modes depending on caller requirements.

Fixes: 478ba09edc1f ("fs/9p: search open fids first")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: ron minnich <rminnich@gmail.com>
Reported-by: ng@0x80.stream
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

I'm sorry I didn't find time to check this properly fixes the clone
open fid issues, but Ron reported it did so I'll assume it did for now.
I'll try to find time to either implement the check in ganesha or use
another server -- if you have a suggestion that'd run either a ramfs or
export a local filesystem from linux I'm all ears, I couldn't get go9p
to work in the very little time I tried.

I did however check that Greg's original open/chmod 0/ftruncate pattern
works (while truncate was refused).
Also, before revert the truncate by path wasn't refused, and now is
again, so that's definitely good.

I've also tested open-unlink-ftruncate and it works properly with
ganesha, but not with qemu -- it looks like qemu tries to access the
file by path in setattr even if the fid has an associated fd, so that'd
be a qemu bug, but it's unrelated to this patch anyway.


Unless there are issues with this patch I'll send it to Linus around
Friday

 fs/9p/fid.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 6aab046c98e2..79df61fe0e59 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -96,12 +96,8 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 		 dentry, dentry, from_kuid(&init_user_ns, uid),
 		 any);
 	ret = NULL;
-
-	if (d_inode(dentry))
-		ret = v9fs_fid_find_inode(d_inode(dentry), uid);
-
 	/* we'll recheck under lock if there's anything to look in */
-	if (!ret && dentry->d_fsdata) {
+	if (dentry->d_fsdata) {
 		struct hlist_head *h = (struct hlist_head *)&dentry->d_fsdata;
 
 		spin_lock(&dentry->d_lock);
@@ -113,6 +109,9 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 			}
 		}
 		spin_unlock(&dentry->d_lock);
+	} else {
+		if (dentry->d_inode)
+			ret = v9fs_fid_find_inode(dentry->d_inode, uid);
 	}
 
 	return ret;
-- 
2.34.1

