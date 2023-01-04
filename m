Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6749765D88A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbjADQPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbjADQPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4676D42E16
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C32D61797
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5C5C433D2;
        Wed,  4 Jan 2023 16:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848911;
        bh=bD4MAlC7kSU5pT6G81b9StRTiVp5PW64Q40gwQlyRyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBMgdaWOwbfH30oyymZaWdhmaRcGHhVhNwkeQbFpJwa2YH0jgq9V7qUIv2y9TTfLY
         0LC48y+UJRX3tEL3i89ZBLX8IRLLno6IwBuHFbYX1wN3sFBbVjmd3NwQRadWNneCGg
         NZvDdKZ8VrzoA9OvgnD5IebUL1uZZRN9R9mQ0y7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 103/207] cifs: fix confusing debug message
Date:   Wed,  4 Jan 2023 17:06:01 +0100
Message-Id: <20230104160515.178374934@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit a85ceafd41927e41a4103d228a993df7edd8823b upstream.

Since rc was initialised to -ENOMEM in cifs_get_smb_ses(), when an
existing smb session was found, free_xid() would be called and then
print

  CIFS: fs/cifs/connect.c: Existing tcp session with server found
  CIFS: fs/cifs/connect.c: VFS: in cifs_get_smb_ses as Xid: 44 with uid: 0
  CIFS: fs/cifs/connect.c: Existing smb sess found (status=1)
  CIFS: fs/cifs/connect.c: VFS: leaving cifs_get_smb_ses (xid = 44) rc = -12

Fix this by initialising rc to 0 and then let free_xid() print this
instead

  CIFS: fs/cifs/connect.c: Existing tcp session with server found
  CIFS: fs/cifs/connect.c: VFS: in cifs_get_smb_ses as Xid: 14 with uid: 0
  CIFS: fs/cifs/connect.c: Existing smb sess found (status=1)
  CIFS: fs/cifs/connect.c: VFS: leaving cifs_get_smb_ses (xid = 14) rc = 0

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2157,7 +2157,7 @@ cifs_set_cifscreds(struct smb3_fs_contex
 struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	int rc = -ENOMEM;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2206,6 +2206,8 @@ cifs_get_smb_ses(struct TCP_Server_Info
 		return ses;
 	}
 
+	rc = -ENOMEM;
+
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)


