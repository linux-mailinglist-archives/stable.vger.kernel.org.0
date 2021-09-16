Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AD240E859
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354552AbhIPRoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355056AbhIPRlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D06E6324F;
        Thu, 16 Sep 2021 16:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811129;
        bh=IkSr81dmRKz8Vb0/fkgJQKts2MtDrWrqbK1Bm8mS7Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaNvHDVh+Mh4Aks/OsHHXpbC52L7E7Mp0GJ/4owDiGnVzpvKX+CNIfxLFs5/aXXTE
         67+5lTfmsw5/X7+DufmdLSAVZ6xXyVx2IYSAIYtCF4+0SM1QKhw2IVCeFQ3jtMwhYZ
         SlXHlp66CuIYD/lXRd8pufjYE/y9uhSpkR+bjZaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chenying <chenying.kernel@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.14 394/432] ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()
Date:   Thu, 16 Sep 2021 18:02:23 +0200
Message-Id: <20210916155824.163686275@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chenying <chenying.kernel@bytedance.com>

commit 52d5a0c6bd8a89f460243ed937856354f8f253a3 upstream.

If function ovl_instantiate() returns an error, ovl_cleanup will be called
and try to remove newdentry from wdir, but the newdentry has been moved to
udir at this time.  This will causes BUG_ON(victim->d_parent->d_inode !=
dir) in fs/namei.c:may_delete.

Signed-off-by: chenying <chenying.kernel@bytedance.com>
Fixes: 01b39dcc9568 ("ovl: use inode_insert5() to hash a newly created inode")
Link: https://lore.kernel.org/linux-unionfs/e6496a94-a161-dc04-c38a-d2544633acb4@bytedance.com/
Cc: <stable@vger.kernel.org> # v4.18
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -542,8 +542,10 @@ static int ovl_create_over_whiteout(stru
 			goto out_cleanup;
 	}
 	err = ovl_instantiate(dentry, inode, newdentry, hardlink);
-	if (err)
-		goto out_cleanup;
+	if (err) {
+		ovl_cleanup(udir, newdentry);
+		dput(newdentry);
+	}
 out_dput:
 	dput(upper);
 out_unlock:


