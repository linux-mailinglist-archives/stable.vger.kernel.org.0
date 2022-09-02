Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99135AB172
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiIBNdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiIBNcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8231166F1;
        Fri,  2 Sep 2022 06:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFC66B82AA0;
        Fri,  2 Sep 2022 12:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F66EC433D7;
        Fri,  2 Sep 2022 12:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122084;
        bh=y6yjcDAQIF/vTOtSaLQE2XI/MgtWHSZ9+6YQP0ofuCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhZef+Wh69GKqbD+xm55mmdxeCdUr7YkdKFG9YGyTMzv7W3FcIgBee2QmfwDKvS9l
         o0r6VdAN7qehtaZnFVeZyYFqJzUbhIUzY80OwVzP0H194sSDbywLVZva2lBzoTy4R9
         qikSbQnIF7tCSLVhFv6AlbhlSFR0enpVGEA+kZo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/73] ksmbd: dont remove dos attribute xattr on O_TRUNC open
Date:   Fri,  2 Sep 2022 14:19:23 +0200
Message-Id: <20220902121406.369495113@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 17661ecf6a64eb11ae7f1108fe88686388b2acd5 ]

When smb client open file in ksmbd share with O_TRUNC, dos attribute
xattr is removed as well as data in file. This cause the FSCTL_SET_SPARSE
request from the client fails because ksmbd can't update the dos attribute
after setting ATTR_SPARSE_FILE. And this patch fix xfstests generic/469
test also.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 824f17a101a9e..55ee639703ff0 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2319,15 +2319,15 @@ static int smb2_remove_smb_xattrs(struct path *path)
 			name += strlen(name) + 1) {
 		ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
 
-		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], DOS_ATTRIBUTE_PREFIX,
-			    DOS_ATTRIBUTE_PREFIX_LEN) &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX, STREAM_PREFIX_LEN))
-			continue;
-
-		err = ksmbd_vfs_remove_xattr(user_ns, path->dentry, name);
-		if (err)
-			ksmbd_debug(SMB, "remove xattr failed : %s\n", name);
+		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
+		    !strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
+			     STREAM_PREFIX_LEN)) {
+			err = ksmbd_vfs_remove_xattr(user_ns, path->dentry,
+						     name);
+			if (err)
+				ksmbd_debug(SMB, "remove xattr failed : %s\n",
+					    name);
+		}
 	}
 out:
 	kvfree(xattr_list);
-- 
2.35.1



