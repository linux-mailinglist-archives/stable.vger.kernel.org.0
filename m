Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9387668120A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbjA3OSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbjA3ORf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E13F3E617
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D3ECCE16BA
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224AAC4339C;
        Mon, 30 Jan 2023 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088222;
        bh=BLPU/h1OVwpyyXRbJPfv6bho7zCl8sAoPAbsZxcMUWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4YEch/WFseDe8gqQNm5C/dJjIrzdzKfMqjSKeD7aJ846ugB2vByxtvxOlXXwvnsW
         7KZsP+6KCorJbP8dPYuilrkOCii/dG0bYjr5Hux93Xm8ffwgl7oyF9GcTIKeJ47+xi
         8iusNXUxn27tSkDdfetDTAfnA5cBginqLmo0/IWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 156/204] ksmbd: do not sign response to session request for guest login
Date:   Mon, 30 Jan 2023 14:52:01 +0100
Message-Id: <20230130134323.400272950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Makassikis <mmakassikis@freebox.fr>

commit 5fde3c21cf33830eda7bfd006dc7f4bf07ec9fe6 upstream.

If ksmbd.mountd is configured to assign unknown users to the guest account
("map to guest = bad user" in the config), ksmbd signs the response.

This is wrong according to MS-SMB2 3.3.5.5.3:
   12. If the SMB2_SESSION_FLAG_IS_GUEST bit is not set in the SessionFlags
   field, and Session.IsAnonymous is FALSE, the server MUST sign the
   final session setup response before sending it to the client, as
   follows:
    [...]

This fixes libsmb2 based applications failing to establish a session
("Wrong signature in received").

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8613,6 +8613,7 @@ int smb3_decrypt_req(struct ksmbd_work *
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	struct smb2_hdr *rsp = work->response_buf;
 
 	if (conn->dialect < SMB30_PROT_ID)
@@ -8622,6 +8623,7 @@ bool smb3_11_final_sess_setup_resp(struc
 		rsp = ksmbd_resp_buf_next(work);
 
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE &&
+	    sess->user && !user_guest(sess->user) &&
 	    rsp->Status == STATUS_SUCCESS)
 		return true;
 	return false;


