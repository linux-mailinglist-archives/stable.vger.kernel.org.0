Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268FB60AC33
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiJXODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbiJXOC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB03BEF94;
        Mon, 24 Oct 2022 05:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE24D61343;
        Mon, 24 Oct 2022 12:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9D6C433C1;
        Mon, 24 Oct 2022 12:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614976;
        bh=wQtvt0pQYSjjl8y2IQ9Sln7QvAgF+4ZI5oQv0B0dNBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdW02+ngbCBGaOo5zDreeRNWuE0iOGk7z1cu3LfKo1/RXin4oWcgF3Grxa+pGgOx4
         eKaqk+kEoe7wvGKjkRI/iAYsrjQNnpAYtBcTD2vxqWesfb+8UbBVx3ioiYFsGEpNKn
         99lN8EPv6Pp9XhLFT2elNezmruJZJaRkBRjlHiSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 075/530] ksmbd: fix endless loop when encryption for response fails
Date:   Mon, 24 Oct 2022 13:26:59 +0200
Message-Id: <20221024113048.419365208@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 360c8ee6fefdb496fffd2c18bb9a96a376a1a804 upstream.

If ->encrypt_resp return error, goto statement cause endless loop.
It send an error response immediately after removing it.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/server.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -235,10 +235,8 @@ send:
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
-		if (rc < 0) {
+		if (rc < 0)
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
-			goto send;
-		}
 	}
 
 	ksmbd_conn_write(work);


