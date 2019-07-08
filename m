Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60FB6621AE
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbfGHPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733018AbfGHPSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C120F216E3;
        Mon,  8 Jul 2019 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599103;
        bh=NBp3141aUWRgutwla6lWbITEXfVZ+XUjm3uAkRmQhoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2Yw1ErroxgspGLPsRFkLr/hc4gcz1TB0DSSzItNcirTl1xpa9WxgY1R8LZ5r1WXc
         eT8C5JWqxiyj2W9mDdedXLBoOeV+gLDmrcWlK5uSlOfhWhL4dZbZjDKkbog2fglhR1
         e0eZXe7nrGTbqTHEWVW6+GUYXxtf8V+1MgUjYBDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 4.4 26/73] SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write
Date:   Mon,  8 Jul 2019 17:12:36 +0200
Message-Id: <20190708150522.379448483@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 8d526d62db907e786fd88948c75d1833d82bd80e upstream.

Some servers such as Windows 10 will return STATUS_INSUFFICIENT_RESOURCES
as the number of simultaneous SMB3 requests grows (even though the client
has sufficient credits).  Return EAGAIN on STATUS_INSUFFICIENT_RESOURCES
so that we can retry writes which fail with this status code.

This (for example) fixes large file copies to Windows 10 on fast networks.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2maperror.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -455,7 +455,7 @@ static const struct status_to_posix_erro
 	{STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
 	{STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
 	"STATUS_ALLOTTED_SPACE_EXCEEDED"},
-	{STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
+	{STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
 				"STATUS_INSUFFICIENT_RESOURCES"},
 	{STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
 	{STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},


