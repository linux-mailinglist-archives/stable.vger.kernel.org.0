Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A22591FEF
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 15:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiHNNxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 09:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiHNNxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 09:53:33 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F81D1CB3C;
        Sun, 14 Aug 2022 06:53:31 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id 130so4532372pfy.6;
        Sun, 14 Aug 2022 06:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=utZ1rRS2VelBBcZCNQ0k31JiYpajbtip7iGwxaNmv2Q=;
        b=BOf/cD/U5CI/m/fQcjh73aL0WDn2NG9s427nx3RLu2DV2WqckzcD8r2K18K0YPO0eJ
         VoRjXoyUORLltNPCaM63x4o3U7Qn7VcqFoJa24HMNogSRwxyGDshs143djVyvlw5GXXl
         KPQYrgJciX3fGduo9y/8M0NEfP1sCoaXHmJw/OTH5wLJo/dHVNf6pGDFhVExP/tVm6oY
         heda9kazn2pJPS1aN/5z1YCRF3T/7+C5ABqj5cUhwUZ6BeiDVsofDGBeHQjHRttFLvpI
         DCsw05bB7cr7f00qZJci5rP+q4+PBemBbk0ihfJHjAtyN8F31NdCHS26tj4tPQOjzr/a
         zQ4Q==
X-Gm-Message-State: ACgBeo3qnGMPXBFN6lERP3k0aVsS2eVX5sWNjZSWRqodw/tCvNzpBYST
        zEQAYyYbeFePS407nROkcRHoQy2ptZ4=
X-Google-Smtp-Source: AA6agR4x0e1X08iqk7P8KjSQg4jEyVwwZsnOfkigty/2/bgUu6z/xCrnJGpSGXHuO3/1qQnkFU48Kw==
X-Received: by 2002:a05:6a02:286:b0:422:f1ba:745 with SMTP id bk6-20020a056a02028600b00422f1ba0745mr7176652pgb.569.1660485210728;
        Sun, 14 Aug 2022 06:53:30 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a4a0700b001f327021900sm3161814pjh.1.2022.08.14.06.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 06:53:30 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3] ksmbd: don't remove dos attribute xattr on O_TRUNC open
Date:   Sun, 14 Aug 2022 22:52:56 +0900
Message-Id: <20220814135256.5247-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When smb client open file in ksmbd share with O_TRUNC, dos attribute
xattr is removed as well as data in file. This cause the FSCTL_SET_SPARSE
request from the client fails because ksmbd can't update the dos attribute
after setting ATTR_SPARSE_FILE. And this patch fix xfstests generic/469
test also.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - don't remove other xattr class also.
   - add fixes and stable tags.
 v3:
   - Change to more simpler check.

 fs/ksmbd/smb2pdu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a136d5e4943b..19412ac701a6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2330,15 +2330,15 @@ static int smb2_remove_smb_xattrs(struct path *path)
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
2.25.1

