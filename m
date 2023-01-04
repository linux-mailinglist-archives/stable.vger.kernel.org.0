Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3E165D8EE
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbjADQUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239979AbjADQTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:19:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5883AAA2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CCC66177C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DBDC433D2;
        Wed,  4 Jan 2023 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849189;
        bh=YfzktBIo7cJFZuRsJDMzUAaqAi2XWnwOYAwrGbu/8Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzvbtYyZ7f3JRah6YBUb3kCKVYns/ejE1WuIm+cTPs1XdP53sKuvj9hoq7U1KP2+r
         KECSbo1J/6uzhk7bHnQjktXvcEXNVoNpDVxr2vX8/X9Oh4SCZHD1ajDR29ohzSEUSZ
         XJnp3sglXb+ZbJT/O3yUBXuJI1p6fsapjfF3eIGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 080/177] cifs: fix confusing debug message
Date:   Wed,  4 Jan 2023 17:06:11 +0100
Message-Id: <20230104160510.075508621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -2155,7 +2155,7 @@ cifs_set_cifscreds(struct smb3_fs_contex
 struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	int rc = -ENOMEM;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2204,6 +2204,8 @@ cifs_get_smb_ses(struct TCP_Server_Info
 		return ses;
 	}
 
+	rc = -ENOMEM;
+
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)


