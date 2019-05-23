Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47185286B6
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388324AbfEWTL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388313AbfEWTL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0DB52186A;
        Thu, 23 May 2019 19:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638718;
        bh=IfZLeQWRu8RqRyjidL5ftlvkVob/PoLcjw5qbPzYndg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2Mm24P3PIOiseeAEXtWjC4wmRBa2D6VuylV5u7HbX6RR/njyC/xjGTjBY0ZozU+i
         9N9jP3fR90sSlNBj1zUtmZm0q3RLD7NKj4cyhhkzmNdE1J4ZJQdtHEAZ3IdLlaQ0OM
         Bynwzy58RXRhhFnr8x11BZZk+CqJy37iAoYt4hTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Persson <lists@bofh.nu>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 22/77] Revert "cifs: fix memory leak in SMB2_read"
Date:   Thu, 23 May 2019 21:05:40 +0200
Message-Id: <20190523181723.408443846@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c54a881d793e3eea2a1b1460c5778b22128821ea which is
commit 05fd5c2c61732152a6bddc318aae62d7e436629b upstream.

Lars writes:
	This patch should not be in 4.14-stable because
	088aaf17aa79300cab14dbee2569c58cfafd7d6e was for 4.18+.

	Now we have a double-free crash in SMB2_read because there are 2
	calls to cifs_small_buf_release in the error path.

It was a mistake to backport it this far, so let's revert it.

Reported-by: Lars Persson <lists@bofh.nu>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Pavel Shilovsky <pshilov@microsoft.com>
Cc: Steve French <stfrench@microsoft.com>
Cc: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2699,7 +2699,6 @@ SMB2_read(const unsigned int xid, struct
 			cifs_dbg(VFS, "Send error in read = %d\n", rc);
 		}
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-		cifs_small_buf_release(req);
 		return rc == -ENODATA ? 0 : rc;
 	}
 


