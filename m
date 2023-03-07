Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161A26AF1A4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjCGSqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjCGSph (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ECDB7DB4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74DE6154C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF8EC4339B;
        Tue,  7 Mar 2023 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214037;
        bh=uwtSjLBb7hT1blFUiP26qjx5yG7P0Jf5dKByOF6/nnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3NwxTX0JeNKLH6YRPlSxSBOPAGSldPdF3GFVSxyOhFh5WLgOXRm55W63SUe/IA9A
         a00FbGoxBD7SibnKjayfP+ne0zQZCNjhy5S6R5X2to3fWj81hnQmna+1d0lF15pIxM
         cyfDdRhhGJ9ddwX9VWaKQhmjUjueKYjupQ97Rvo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 670/885] cifs: Fix uninitialized memory read in smb3_qfs_tcon()
Date:   Tue,  7 Mar 2023 18:00:04 +0100
Message-Id: <20230307170031.266533880@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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


