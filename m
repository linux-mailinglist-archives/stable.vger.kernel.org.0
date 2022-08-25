Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A025A068E
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiHYBlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbiHYBki (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE8E97EE4;
        Wed, 24 Aug 2022 18:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9700E61ACA;
        Thu, 25 Aug 2022 01:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E93C433D7;
        Thu, 25 Aug 2022 01:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391472;
        bh=L4MKQTQwym98xpmAY4yKswzZFnAkBnYHc0eAUQZ+gkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4SderldP4B2ACzK4N0BsgWApUlcMJEpIK+SyNKQIhupVCRqt3X9/U2GAzOi0jWcp
         hxvgMHIWFTpFXG3lG97ss2kOMIUZ7COI3Nz8PGjL0+lwpk67nIhvPnnxyrML4qk7B+
         ol0mW3woGghtOUPPK5pJ2VRUa/9TyeMEq7dvxUTbGV7KSiCR5tyR8S6TgSwoYpuIZa
         LfM3WlWdiZJ/tvjodEhcMLHjX6PH1LluCpd4XVV8k6Jho3R287oYwirpKESVUAMBz1
         +u9pu9kQ0FtF3WqbxNgkINHba2Higxps4bL58M45eNmkHLm90iDQOHvm0FB6P2rcFo
         FC15QIzlSdVaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/20] ksmbd: don't remove dos attribute xattr on O_TRUNC open
Date:   Wed, 24 Aug 2022 21:37:02 -0400
Message-Id: <20220825013713.22656-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013713.22656-1-sashal@kernel.org>
References: <20220825013713.22656-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 824f17a101a9..55ee639703ff 100644
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

