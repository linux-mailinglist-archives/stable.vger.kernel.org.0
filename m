Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC506499E57
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588490AbiAXWcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586030AbiAXWZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:25:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DF5C035454;
        Mon, 24 Jan 2022 12:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA3E2B812A4;
        Mon, 24 Jan 2022 20:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD6AC340E5;
        Mon, 24 Jan 2022 20:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057656;
        bh=l5GlaMQWhaM9tQ49nzfGO/tk9HkHi8Ff5Xjw5ttxKI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJzvl0d08y0/dI07MyYmLjb44i7kFuQT52ieEtYkowwFppM+k6/hrsgqSjajaR72z
         xDJn0dgnWdX+Ww33QGm6EMxSW+0VN+ICCsf3oXkZO4sIXvYChOcx1DltJOLWoadTPQ
         Owv3/PMEPGe6Fhb3/BkZHohc09KKtXyJ8GVuK2Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0036/1039] ksmbd: uninitialized variable in create_socket()
Date:   Mon, 24 Jan 2022 19:30:25 +0100
Message-Id: <20220124184126.345329838@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b207602fb04537cb21ac38fabd7577eca2fa05ae upstream.

The "ksmbd_socket" variable is not initialized on this error path.

Cc: stable@vger.kernel.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -404,7 +404,7 @@ static int create_socket(struct interfac
 				  &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
-			goto out_error;
+			goto out_clear;
 		}
 
 		sin.sin_family = PF_INET;
@@ -462,6 +462,7 @@ static int create_socket(struct interfac
 
 out_error:
 	tcp_destroy_socket(ksmbd_socket);
+out_clear:
 	iface->ksmbd_socket = NULL;
 	return ret;
 }


