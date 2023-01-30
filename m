Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B65C68108D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbjA3OEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbjA3OEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1324DE3BB
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A425F61049
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B341BC433D2;
        Mon, 30 Jan 2023 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087463;
        bh=a1CuucqzvtiC7qVxZGxrEI9PDlQBfwrCUQy8TOiw01o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR8vTjjbxIn0Cni6RlNYcsRpR36aZAZiHUr7FZ0OQ+4EQgbuqxvwnuzNzPpL+X7Xm
         TdNlsD+o0kulFDK714brOIfqbu0rU6mrW2E1DL8rW87ZGEMX4Ocyv8lfl5kvVUabdr
         lT0RIvQv+F19nFtCh126u177YUITC/wrVZTQo9co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 217/313] ksmbd: do not sign response to session request for guest login
Date:   Mon, 30 Jan 2023 14:50:52 +0100
Message-Id: <20230130134346.815235688@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
@@ -8657,6 +8657,7 @@ int smb3_decrypt_req(struct ksmbd_work *
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	struct smb2_hdr *rsp = smb2_get_msg(work->response_buf);
 
 	if (conn->dialect < SMB30_PROT_ID)
@@ -8666,6 +8667,7 @@ bool smb3_11_final_sess_setup_resp(struc
 		rsp = ksmbd_resp_buf_next(work);
 
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE &&
+	    sess->user && !user_guest(sess->user) &&
 	    rsp->Status == STATUS_SUCCESS)
 		return true;
 	return false;


