Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6477B6AEC09
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjCGRv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCGRvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:51:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94118A42DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:45:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C20614B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27457C433D2;
        Tue,  7 Mar 2023 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211153;
        bh=uwtSjLBb7hT1blFUiP26qjx5yG7P0Jf5dKByOF6/nnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meFB9GoQS3keEcaGYh/11HEjY4GyA4KNMKzH8hBBTEsdid/A0y3/+gyZ8tpmCVZHg
         DBKVoZzGxDdaz8v3fxf2EgQkoET9QS3aOp8h7vEJ2XJHEsUKdsnDSKUbmbjqN5SOKX
         54YtHDMQXYAj21tkg6GiyEJ7KjJdPywFnzN3EKzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0771/1001] cifs: Fix uninitialized memory read in smb3_qfs_tcon()
Date:   Tue,  7 Mar 2023 17:59:03 +0100
Message-Id: <20230307170055.227245629@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volker Lendecke <vl@samba.org>

commit d447e794a37288ec7a080aa1b044a8d9deebbab7 upstream.

oparms was not fully initialized

Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -729,12 +729,13 @@ smb3_qfs_tcon(const unsigned int xid, st
 	struct cifs_fid fid;
 	struct cached_fid *cfid = NULL;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = open_cached_dir(xid, tcon, "", cifs_sb, false, &cfid);
 	if (rc == 0)


