Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E674ABA77
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383777AbiBGLXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343882AbiBGLLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA5EC043181;
        Mon,  7 Feb 2022 03:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB09B80EE8;
        Mon,  7 Feb 2022 11:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CA3C004E1;
        Mon,  7 Feb 2022 11:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232289;
        bh=OKnCkyLU3qDEEgEn3emwG9Us2Es3B1OuFA9ZMv8oHJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzJ84KK5RMdlvVIINzl5sVhr0LwdefO3NZ8e2DA1ordyG/48fEdHCNwYQ8aj9kDLh
         iRGnF/HrUmiYhfk3NHzRPserOd2GbGOW01lSOcnb3ElceVo/KlK2GxJMkDhIEAtgdH
         1MOBmlq9UbKz1dTPQeAXPcZ8FzmVX68FciB71ALY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.14 30/69] NFSv4: nfs_atomic_open() can race when looking up a non-regular file
Date:   Mon,  7 Feb 2022 12:05:52 +0100
Message-Id: <20220207103756.612765793@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 1751fc1db36f6f411709e143d5393f92d12137a9 upstream.

If the file type changes back to being a regular file on the server
between the failed OPEN and our LOOKUP, then we need to re-run the OPEN.

Fixes: 0dd2b474d0b6 ("nfs: implement i_op->atomic_open()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1612,12 +1612,17 @@ no_open:
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
 		    !S_ISDIR(inode->i_mode))
 			res = ERR_PTR(-ENOTDIR);
+		else if (inode && S_ISREG(inode->i_mode))
+			res = ERR_PTR(-EOPENSTALE);
 	} else if (!IS_ERR(res)) {
 		inode = d_inode(res);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
 		    !S_ISDIR(inode->i_mode)) {
 			dput(res);
 			res = ERR_PTR(-ENOTDIR);
+		} else if (inode && S_ISREG(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-EOPENSTALE);
 		}
 	}
 	if (switched) {


