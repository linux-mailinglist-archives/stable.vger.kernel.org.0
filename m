Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811FE73CC6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392060AbfGXT5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392054AbfGXT5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F058206BA;
        Wed, 24 Jul 2019 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998261;
        bh=T/js2yY3PjgZPEfi3OtpxtXr6ZCEeDIG5lhr3PLXbMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otyzXOTAPI8Xoq5IuOGZCtJDMR7F8YViI3bTqXmPIwBJBp/GT46XqX5wX178Faest
         39GG8apVtFku/zqB8DVjihpaEB2HHky1S8AR6cMiRqYlOXYtlQYYRv47pdclPxi8Cu
         8IsRgFwFso+uGpC0DVHZnuEfBpWE7V5lFwnqSfVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 251/371] cifs: always add credits back for unsolicited PDUs
Date:   Wed, 24 Jul 2019 21:20:03 +0200
Message-Id: <20190724191743.564738540@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 3e2725796cbdfe4efc7eb7b27cacaeac2ddad1a5 upstream.

not just if CONFIG_CIFS_DEBUG2 is enabled.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1221,11 +1221,11 @@ next_pdu:
 					 atomic_read(&midCount));
 				cifs_dump_mem("Received Data is: ", bufs[i],
 					      HEADER_SIZE(server));
+				smb2_add_credits_from_hdr(bufs[i], server);
 #ifdef CONFIG_CIFS_DEBUG2
 				if (server->ops->dump_detail)
 					server->ops->dump_detail(bufs[i],
 								 server);
-				smb2_add_credits_from_hdr(bufs[i], server);
 				cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 			}


