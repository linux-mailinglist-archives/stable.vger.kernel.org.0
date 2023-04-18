Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4433C6E620D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjDRM3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjDRM3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:29:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF7BB9A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ADD5631CD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A815C433EF;
        Tue, 18 Apr 2023 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820953;
        bh=s5/biCfFXquLVPcaqrhw01kfeVd7SnWNXrUzIWjpJjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKo2j6Z5+2XpMkrQRxDthLbo/7QW2qUJzsfrHMW+s+0ZU9rldcWsbwiG8GZPQCIcA
         jv30INLM7Rwjq3WF7u93kWXM3/2Du5ttwwwwBc2za8F8TdOWxlLIPQNytro20wlVPe
         gJCR35au2Q2vqAp5ovd+uQw4OTmKDZL/tBPlLdfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.4 06/92] smb3: fix problem with null cifs super block with previous patch
Date:   Tue, 18 Apr 2023 14:20:41 +0200
Message-Id: <20230418120304.957869543@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 87f93d82e0952da18af4d978e7d887b4c5326c0b upstream.

Add check for null cifs_sb to create_options helper

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/smb2ops.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -602,7 +602,7 @@ static inline int get_dfs_path(const uns
 
 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 {
-	if (backup_cred(cifs_sb))
+	if (cifs_sb && (backup_cred(cifs_sb)))
 		return options | CREATE_OPEN_BACKUP_INTENT;
 	else
 		return options;
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2343,7 +2343,7 @@ smb2_queryfs(const unsigned int xid, str
 				      FS_FULL_SIZE_INFORMATION,
 				      SMB2_O_INFO_FILESYSTEM,
 				      sizeof(struct smb2_fs_full_size_info),
-				      &rsp_iov, &buftype, NULL);
+				      &rsp_iov, &buftype, cifs_sb);
 	if (rc)
 		goto qfs_exit;
 


