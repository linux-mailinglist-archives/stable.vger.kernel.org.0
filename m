Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FA85A485A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiH2LJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiH2LI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:08:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79E767457;
        Mon, 29 Aug 2022 04:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0AC4B80EF6;
        Mon, 29 Aug 2022 11:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B25C433C1;
        Mon, 29 Aug 2022 11:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771075;
        bh=jk/U9yqftALlcHtMMTeFmMseUiD4o7QesRU+OAonEdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WB7iPpguWY68sR9SGH9vDSH1KAIWz3Eb3iGCFeCpgt5iasnzDknFqwqZkD/J6gbd1
         IDWx1oEzIdjkG2HViA7TASCHsdJDWfyL54x535V+POduaBn345M4zRiElpzb1EodPs
         tAt45E7j/MCeMIqInHc+8qWWBmIpErKO0UAR7l6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/86] NFSv4.2 fix problems with __nfs42_ssc_open
Date:   Mon, 29 Aug 2022 12:58:43 +0200
Message-Id: <20220829105757.226673734@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit fcfc8be1e9cf2f12b50dce8b579b3ae54443a014 ]

A destination server while doing a COPY shouldn't accept using the
passed in filehandle if its not a regular filehandle.

If alloc_file_pseudo() has failed, we need to decrement a reference
on the newly created inode, otherwise it leaks.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: ec4b092508982 ("NFS: inter ssc open")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 4928eaa0d4c02..70cd0d764c447 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -341,6 +341,11 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		goto out;
 	}
 
+	if (!S_ISREG(fattr->mode)) {
+		res = ERR_PTR(-EBADF);
+		goto out;
+	}
+
 	res = ERR_PTR(-ENOMEM);
 	len = strlen(SSC_READ_NAME_BODY) + 16;
 	read_name = kzalloc(len, GFP_NOFS);
@@ -359,6 +364,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 				     r_ino->i_fop);
 	if (IS_ERR(filep)) {
 		res = ERR_CAST(filep);
+		iput(r_ino);
 		goto out_free_name;
 	}
 	filep->f_mode |= FMODE_READ;
-- 
2.35.1



