Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5520D66450F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjAJPjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjAJPjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:39:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2111A1F5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 07:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC1CF61791
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 15:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B0CC433D2;
        Tue, 10 Jan 2023 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673365170;
        bh=Tl4jwBaAq/imqbjySHqi6hGcQD4xu8r1au7FFizlBf0=;
        h=Subject:To:Cc:From:Date:From;
        b=CfSjIAp6lcCUtukDim1CA2r/dKLYaK/KvlU/wnCYxHDtRH6GVYUlhBrBMYJGfsww1
         OyhuaAK+6GrJzJaYrXUXLE1k9p2wmCg4tTQ8HT983zyk12FSk6GzurfSlFSwqgqcSB
         CCHk6ot2IljPt147e+wxzqpedAJpRTfmOus05hx4=
Subject: FAILED: patch "[PATCH] ksmbd: send proper error response in smb2_tree_connect()" failed to apply to 5.15-stable tree
To:     mmakassikis@freebox.fr, linkinjeon@kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 16:39:18 +0100
Message-ID: <167336515815380@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cdfb2fef522d ("ksmbd: send proper error response in smb2_tree_connect()")
cb4517201b8a ("ksmbd: remove smb2_buf_length in smb2_hdr")
341b16014bf8 ("ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cdfb2fef522d0c3f9cf293db51de88e9b3d46846 Mon Sep 17 00:00:00 2001
From: Marios Makassikis <mmakassikis@freebox.fr>
Date: Fri, 23 Dec 2022 11:59:31 +0100
Subject: [PATCH] ksmbd: send proper error response in smb2_tree_connect()

Currently, smb2_tree_connect doesn't send an error response packet on
error.

This causes libsmb2 to skip the specific error code and fail with the
following:
 smb2_service failed with : Failed to parse fixed part of command
 payload. Unexpected size of Error reply. Expected 9, got 8

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 14d7f3599c63..38fbda52e06f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1928,13 +1928,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (conn->posix_ext_supported)
 		status.tree_conn->posix_extensions = true;
 
-out_err1:
 	rsp->StructureSize = cpu_to_le16(16);
+	inc_rfc1001_len(work->response_buf, 16);
+out_err1:
 	rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
-	inc_rfc1001_len(work->response_buf, 16);
 
 	if (!IS_ERR(treename))
 		kfree(treename);
@@ -1967,6 +1967,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	}
 
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		smb2_set_err_rsp(work);
+
 	return rc;
 }
 

