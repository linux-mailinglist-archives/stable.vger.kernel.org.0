Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FF46648DF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbjAJSP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239026AbjAJSPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C8430579
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02ECB6184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194D0C433EF;
        Tue, 10 Jan 2023 18:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374404;
        bh=GCOfrC7m6pYAu24UJv8K1JA5/wcb32w0JVHKHlJHFhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igi93ro/Gt/bn6GJ9O9hHYfSTNoz4ahtRawR/PzrKKyma6jhDH4lgAZefLEha/2Es
         xj3XJ9xn9wGgTbA0nVQzksoR1r162DMlZSZg638QALeSpOPEAaXSxLkBuYy/eLxX2+
         GhXvb5Zbx7wBGLRI/OXX8ef/DvyviSSEBJa32aQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 144/148] ksmbd: send proper error response in smb2_tree_connect()
Date:   Tue, 10 Jan 2023 19:04:08 +0100
Message-Id: <20230110180021.746814939@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Marios Makassikis <mmakassikis@freebox.fr>

commit cdfb2fef522d0c3f9cf293db51de88e9b3d46846 upstream.

Currently, smb2_tree_connect doesn't send an error response packet on
error.

This causes libsmb2 to skip the specific error code and fail with the
following:
 smb2_service failed with : Failed to parse fixed part of command
 payload. Unexpected size of Error reply. Expected 9, got 8

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1926,13 +1926,13 @@ int smb2_tree_connect(struct ksmbd_work
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
@@ -1965,6 +1965,9 @@ out_err1:
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	}
 
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		smb2_set_err_rsp(work);
+
 	return rc;
 }
 


