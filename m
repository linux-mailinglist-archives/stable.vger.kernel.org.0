Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A155A4A2F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiH2Lek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiH2Ld1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:33:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEB17C762;
        Mon, 29 Aug 2022 04:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56F9EB80FA8;
        Mon, 29 Aug 2022 11:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA606C433C1;
        Mon, 29 Aug 2022 11:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771955;
        bh=Jxix6kCwkiFkX3V8J1xFG7Lljl6Yd+X7PX6y7zWZUOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe2XzlJOHf6bVlXSosts/2DtRh81YEceL0sOJcyH0hbIVScLtkcXiw0wJnIJa0rKA
         uCr36vmOipVTjsWJ8xnrkAc4HBrX/AxUHoblQyVv2MzypCZt0kySqeg6kgSYz4OtZk
         AVGo14rCetyxEZhmS+/he4kJUNCnEbsa9FH1yzj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 119/158] cifs: skip extra NULL byte in filenames
Date:   Mon, 29 Aug 2022 12:59:29 +0200
Message-Id: <20220829105814.102356825@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit a1d2eb51f0a33c28f5399a1610e66b3fbd24e884 upstream.

Since commit:
 cifs: alloc_path_with_tree_prefix: do not append sep. if the path is empty
alloc_path_with_tree_prefix() function was no longer including the
trailing separator when @path is empty, although @out_len was still
assuming a path separator thus adding an extra byte to the final
filename.

This has caused mount issues in some Synology servers due to the extra
NULL byte in filenames when sending SMB2_CREATE requests with
SMB2_FLAGS_DFS_OPERATIONS set.

Fix this by checking if @path is not empty and then add extra byte for
separator.  Also, do not include any trailing NULL bytes in filename
as MS-SMB2 requires it to be 8-byte aligned and not NULL terminated.

Cc: stable@vger.kernel.org
Fixes: 7eacba3b00a3 ("cifs: alloc_path_with_tree_prefix: do not append sep. if the path is empty")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2571,19 +2571,15 @@ alloc_path_with_tree_prefix(__le16 **out
 
 	path_len = UniStrnlen((wchar_t *)path, PATH_MAX);
 
-	/*
-	 * make room for one path separator between the treename and
-	 * path
-	 */
-	*out_len = treename_len + 1 + path_len;
+	/* make room for one path separator only if @path isn't empty */
+	*out_len = treename_len + (path[0] ? 1 : 0) + path_len;
 
 	/*
-	 * final path needs to be null-terminated UTF16 with a
-	 * size aligned to 8
+	 * final path needs to be 8-byte aligned as specified in
+	 * MS-SMB2 2.2.13 SMB2 CREATE Request.
 	 */
-
-	*out_size = roundup((*out_len+1)*2, 8);
-	*out_path = kzalloc(*out_size, GFP_KERNEL);
+	*out_size = roundup(*out_len * sizeof(__le16), 8);
+	*out_path = kzalloc(*out_size + sizeof(__le16) /* null */, GFP_KERNEL);
 	if (!*out_path)
 		return -ENOMEM;
 


