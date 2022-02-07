Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878B44ABDA1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388857AbiBGLpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385679AbiBGLcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27452C0401D1;
        Mon,  7 Feb 2022 03:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B774160A67;
        Mon,  7 Feb 2022 11:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1232C004E1;
        Mon,  7 Feb 2022 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233505;
        bh=F68DvOu11U/2Izi/Om2gsPqtu/mO84SiK259QUL0IZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF9j0nENq4C7nqbR1fLvWKTxfu31z4UzteH2CfdwLVKyi6UbKmO1McZ4MENy8UGbk
         FgMOFoctl/W3AAOtnKfS+3hbDKUAzxZPE9sQe7OLT0TxEKqqN3c1fCEMSRWubcQrzF
         1D0hZ0LKN1tzkBkbEwgjYpb/6P9/3Ch8dh3NAxNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ryan Bair <ryandbair@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 034/126] cifs: fix workstation_name for multiuser mounts
Date:   Mon,  7 Feb 2022 12:06:05 +0100
Message-Id: <20220207103805.320263296@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Ryan Bair <ryandbair@gmail.com>

commit d3b331fb51f326d5b5326010bf2b5841bb86cdc6 upstream.

Set workstation_name from the master_tcon for multiuser mounts.

Just in case, protect size_of_ntlmssp_blob against a NULL workstation_name.

Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session setup")
Cc: stable@vger.kernel.org # 5.16
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Ryan Bair <ryandbair@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   13 +++++++++++++
 fs/cifs/sess.c    |    6 +++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1945,6 +1945,19 @@ cifs_set_cifscreds(struct smb3_fs_contex
 		}
 	}
 
+	ctx->workstation_name = kstrdup(ses->workstation_name, GFP_KERNEL);
+	if (!ctx->workstation_name) {
+		cifs_dbg(FYI, "Unable to allocate memory for workstation_name\n");
+		rc = -ENOMEM;
+		kfree(ctx->username);
+		ctx->username = NULL;
+		kfree_sensitive(ctx->password);
+		ctx->password = NULL;
+		kfree(ctx->domainname);
+		ctx->domainname = NULL;
+		goto out_key_put;
+	}
+
 out_key_put:
 	up_read(&key->sem);
 	key_put(key);
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -675,7 +675,11 @@ static int size_of_ntlmssp_blob(struct c
 	else
 		sz += sizeof(__le16);
 
-	sz += sizeof(__le16) * strnlen(ses->workstation_name, CIFS_MAX_WORKSTATION_LEN);
+	if (ses->workstation_name)
+		sz += sizeof(__le16) * strnlen(ses->workstation_name,
+			CIFS_MAX_WORKSTATION_LEN);
+	else
+		sz += sizeof(__le16);
 
 	return sz;
 }


