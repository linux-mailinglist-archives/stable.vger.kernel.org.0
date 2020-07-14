Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB19A21FB2E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbgGNS7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbgGNS7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB82207F5;
        Tue, 14 Jul 2020 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753172;
        bh=nDJc5vRd3K9zdIMpBjogFrF89tU+Gwn04dciJ4YtJfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVlKsBvI+lZ+avlYL26LOxV/+k/uB96wQmNx8XBotWSpXL+sfBNiW5NbUYE+95/e3
         jPGbu8z83ieHEk5PdGuWPri4cO3BVDBuHO7ZcSA7/PnQohOkZRp4k++NmR4jVaDeCu
         sKlymWdGoEerKX79/0iTGPKRYeKnZUm4244rb10s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.7 147/166] smb3: fix access denied on change notify request to some servers
Date:   Tue, 14 Jul 2020 20:45:12 +0200
Message-Id: <20200714184122.865978096@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 4ef9b4f1a76ea2370fbfe20e80fef141ab92b65e upstream.

read permission, not just read attributes permission, is required
on the directory.

See MS-SMB2 (protocol specification) section 3.3.5.19.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org> # v5.6+
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2119,7 +2119,7 @@ smb3_notify(const unsigned int xid, stru
 
 	tcon = cifs_sb_master_tcon(cifs_sb);
 	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
 	oparms.disposition = FILE_OPEN;
 	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;


