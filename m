Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953CE60B787
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiJXTZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiJXTYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:24:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD8F3F316;
        Mon, 24 Oct 2022 10:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D5C1CE1677;
        Mon, 24 Oct 2022 12:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD3AC433C1;
        Mon, 24 Oct 2022 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614978;
        bh=5of1Olx1A+AaRrxi8YE6LOXyOeDWn95p5vYiMDeZUi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoMQ8aNhsKdiBm3zzFcv8tkwymS33VYJsz0R4sd5slHEtTdTabRXS1xKkEQ4YatSf
         ENHuAeU45gFTy2fJPGUDawm+aorl1rLJpgCufac37Rrrogd0q67xLi7VjMBZqulXEB
         k30e07UKi6FMzerBlLCOQYkz5GeSP1wgU6bZORhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 076/530] ksmbd: Fix wrong return value and message length check in smb2_ioctl()
Date:   Mon, 24 Oct 2022 13:27:00 +0200
Message-Id: <20221024113048.459889622@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit b1763d265af62800ec96eeb79803c4c537dcef3a upstream.

Commit c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock
break, and move its struct to smbfs_common") use the defination
of 'struct validate_negotiate_info_req' in smbfs_common, the
array length of 'Dialects' changed from 1 to 4, but the protocol
does not require the client to send all 4. This lead the request
which satisfied with protocol and server to fail.

So just ensure the request payload has the 'DialectCount' in
smb2_ioctl(), then fsctl_validate_negotiate_info() will use it
to validate the payload length and each dialect.

Also when the {in, out}_buf_len is less than the required, should
goto out to initialize the status in the response header.

Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7617,11 +7617,16 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
-			return -EINVAL;
+		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
+					  Dialects)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
-			return -EINVAL;
+		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		ret = fsctl_validate_negotiate_info(conn,
 			(struct validate_negotiate_info_req *)&req->Buffer[0],


