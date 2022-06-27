Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E086455C223
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiF0Lnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiF0Lmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7F3E02;
        Mon, 27 Jun 2022 04:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B96B8111B;
        Mon, 27 Jun 2022 11:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A7DC3411D;
        Mon, 27 Jun 2022 11:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329895;
        bh=ya6NqRRRrlm7hZiwo+jdpCTe+xU8kmDhkrN5GWHursc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sghqqm/5oca0TJF5LZbsoT7WtEnKrDdDwjJvQsIZunL9yoGxbDBZpj7T/H0rUCZpx
         tC8udpWJIk4vHn2ru+YCWL+J970yajTd6IqLWeLxhxIbCuL8JNR4jw7Nb/JIpZDEAR
         kZu0HqQCnggA3C08GGrT1tmSjXzZkAERtqf5Bm3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.18 016/181] 9p: fix fid refcount leak in v9fs_vfs_get_link
Date:   Mon, 27 Jun 2022 13:19:49 +0200
Message-Id: <20220627111945.033453940@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit e5690f263208c5abce7451370b7786eb25b405eb upstream.

we check for protocol version later than required, after a fid has
been obtained. Just move the version check earlier.

Link: https://lkml.kernel.org/r/20220612085330.1451496-3-asmadeus@codewreck.org
Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
Cc: stable@vger.kernel.org
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1250,15 +1250,15 @@ static const char *v9fs_vfs_get_link(str
 		return ERR_PTR(-ECHILD);
 
 	v9ses = v9fs_dentry2v9ses(dentry);
-	fid = v9fs_fid_lookup(dentry);
+	if (!v9fs_proto_dotu(v9ses))
+		return ERR_PTR(-EBADF);
+
 	p9_debug(P9_DEBUG_VFS, "%pd\n", dentry);
+	fid = v9fs_fid_lookup(dentry);
 
 	if (IS_ERR(fid))
 		return ERR_CAST(fid);
 
-	if (!v9fs_proto_dotu(v9ses))
-		return ERR_PTR(-EBADF);
-
 	st = p9_client_stat(fid);
 	p9_client_clunk(fid);
 	if (IS_ERR(st))


