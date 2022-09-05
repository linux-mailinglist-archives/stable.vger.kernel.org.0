Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2E5AD773
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiIEQau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 12:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiIEQat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 12:30:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F98527CDA
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 09:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 202C5B81218
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 16:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8913AC433D7;
        Mon,  5 Sep 2022 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662395445;
        bh=/vMuzxws7XHr8h5ubN9mgZYhdH37rp+dqR3HJjLW95s=;
        h=Subject:To:Cc:From:Date:From;
        b=N7o9YxIToFUUZVcdNV3tSMfz+R3NyxM/ewrQwBCTaNA8epBrPpthacf0j8oCkXfB4
         PPyTuGP1MYfk77pZXL4q1wv2HSbhiuLxeuLAIQG2Mt9eyVq/pWRZVaLyWEJLavZas+
         Erg/4i0IGV1psVd+Lqg4pZHvWMglXiREe7DW+J2E=
Subject: FAILED: patch "[PATCH] cifs: fix small mempool leak in SMB2_negotiate()" failed to apply to 5.4-stable tree
To:     ematsumiya@suse.de, lsahlber@redhat.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Sep 2022 18:30:31 +0200
Message-ID: <166239543121672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 27893dfc1285f80f80f46b3b8c95f5d15d2e66d0 Mon Sep 17 00:00:00 2001
From: Enzo Matsumiya <ematsumiya@suse.de>
Date: Tue, 30 Aug 2022 19:51:51 -0300
Subject: [PATCH] cifs: fix small mempool leak in SMB2_negotiate()

In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
the request is sent, the checks would return -EIO when they should be
rather setting rc = -EIO and jumping to neg_exit to free the response
buffer from mempool.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Cc: stable@vger.kernel.org
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 128e44e57528..6352ab32c7e7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -965,16 +965,17 @@ SMB2_negotiate(const unsigned int xid,
 	} else if (rc != 0)
 		goto neg_exit;
 
+	rc = -EIO;
 	if (strcmp(server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2.1 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb311_operations;
@@ -985,7 +986,7 @@ SMB2_negotiate(const unsigned int xid,
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb21_operations;
@@ -999,7 +1000,7 @@ SMB2_negotiate(const unsigned int xid,
 		/* if requested single dialect ensure returned dialect matched */
 		cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
 				le16_to_cpu(rsp->DialectRevision));
-		return -EIO;
+		goto neg_exit;
 	}
 
 	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
@@ -1017,9 +1018,10 @@ SMB2_negotiate(const unsigned int xid,
 	else {
 		cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
 				le16_to_cpu(rsp->DialectRevision));
-		rc = -EIO;
 		goto neg_exit;
 	}
+
+	rc = 0;
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
 	/*

