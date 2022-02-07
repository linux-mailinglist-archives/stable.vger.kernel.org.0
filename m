Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7594ABC66
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357487AbiBGLfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239982AbiBGL2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B392C03E900;
        Mon,  7 Feb 2022 03:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 947466006F;
        Mon,  7 Feb 2022 11:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A4FC004E1;
        Mon,  7 Feb 2022 11:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233209;
        bh=Iak8vh7ApDqC2sn/lpRa3bbrO/W7x/7fol5Si/xzUNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE+8cg2r36/4Am6hDIf7yIV4gsX6Iwxpx37xRFYlKvdY6S6zhwFuNwk9VjXo2nSYc
         d9smp3L4kIeSdDS0gqGN9L715yIafCLdB1nO/me5OmKI5y806PSIpH1hyFtMiP+N1n
         sGXOs7rKSTG4B7r+AWtBJF4G7msZf04oN2PO4kjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ron minnich <rminnich@gmail.com>,
        ng@0x80.stream, Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.15 020/110] Revert "fs/9p: search open fids first"
Date:   Mon,  7 Feb 2022 12:05:53 +0100
Message-Id: <20220207103802.942555907@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 22e424feb6658c5d6789e45121830357809c59cb upstream.

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

Link: https://lkml.kernel.org/r/20220130130651.712293-1-asmadeus@codewreck.org
Fixes: 478ba09edc1f ("fs/9p: search open fids first")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: ron minnich <rminnich@gmail.com>
Reported-by: ng@0x80.stream
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/fid.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -96,12 +96,8 @@ static struct p9_fid *v9fs_fid_find(stru
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
 		hlist_for_each_entry(fid, h, dlist) {
@@ -112,6 +108,9 @@ static struct p9_fid *v9fs_fid_find(stru
 			}
 		}
 		spin_unlock(&dentry->d_lock);
+	} else {
+		if (dentry->d_inode)
+			ret = v9fs_fid_find_inode(dentry->d_inode, uid);
 	}
 
 	return ret;


