Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050A14A96AF
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358023AbiBDJ21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357793AbiBDJ0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4968CC0613F5;
        Fri,  4 Feb 2022 01:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAF24612C8;
        Fri,  4 Feb 2022 09:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A91C004E1;
        Fri,  4 Feb 2022 09:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966774;
        bh=uIOOkmegQVgIMxeGdS22TVAxE7p78mJf/iAIGcpiIjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QT7myqCGhsYbHyy1wX9z6CF5JZxNJJy442uQ+9vtCflHl+9AxtkgqymuD04QThO0c
         P2HovkhhBRvm2uzzmNaK+TOi4KEFDOFt2ca0Vw3KemDNNIaglauWuHb/gJLfX3VDMl
         PNR67c0bMKiof2SbkkS6LJuAYHJPHgDhckz4lZPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.16 09/43] ovl: dont fail copy up if no fileattr support on upper
Date:   Fri,  4 Feb 2022 10:22:16 +0100
Message-Id: <20220204091917.486977077@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 94fd19752b28aa66c98e7991734af91dfc529f8f upstream.

Christoph Fritz is reporting that failure to copy up fileattr when upper
doesn't support fileattr or xattr results in a regression.

Return success in these failure cases; this reverts overlayfs to the old
behavior.

Add a pr_warn_once() in these cases to still let the user know about the
copy up failures.

Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Cc: <stable@vger.kernel.org> # v5.15
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -157,7 +157,9 @@ static int ovl_copy_fileattr(struct inod
 	 */
 	if (oldfa.flags & OVL_PROT_FS_FLAGS_MASK) {
 		err = ovl_set_protattr(inode, new->dentry, &oldfa);
-		if (err)
+		if (err == -EPERM)
+			pr_warn_once("copying fileattr: no xattr on upper\n");
+		else if (err)
 			return err;
 	}
 
@@ -167,6 +169,14 @@ static int ovl_copy_fileattr(struct inod
 
 	err = ovl_real_fileattr_get(new, &newfa);
 	if (err) {
+		/*
+		 * Returning an error if upper doesn't support fileattr will
+		 * result in a regression, so revert to the old behavior.
+		 */
+		if (err == -ENOTTY || err == -EINVAL) {
+			pr_warn_once("copying fileattr: no support on upper\n");
+			return 0;
+		}
 		pr_warn("failed to retrieve upper fileattr (%pd2, err=%i)\n",
 			new, err);
 		return err;


