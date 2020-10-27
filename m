Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6076829B704
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797615AbgJ0P2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796935AbgJ0PUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:20:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4063821527;
        Tue, 27 Oct 2020 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812040;
        bh=MaddujSPcZsokRStR96/3MyPWWYKC/w8YF4UrqRo8fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjYZ4D3GffKcdpK+mBAbpObolDDc0/+7T4Po59Sv8ud8ujMrdAvr4BeGDK5BzP7jA
         cXXA299ofBuhcqd2BokTbJptqtynF/7sEbiAQkTpbHnFiYbMuUrrIA8I7m3DYgGgho
         ImlsA29KIo3M83FgG++2/in0+YXAVPpZYBBYxSIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 070/757] smb3: do not try to cache root directory if dir leases not supported
Date:   Tue, 27 Oct 2020 14:45:20 +0100
Message-Id: <20201027135453.831501205@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 3c6e65e679182d55779ef6f8582f0945af4319b0 upstream.

To servers which do not support directory leases (e.g. Samba)
it is wasteful to try to open_shroot (ie attempt to cache the
root directory handle).  Skip attempt to open_shroot when
server does not indicate support for directory leases.

Cuts the number of requests on mount from 17 to 15, and
cuts the number of requests on stat of the root directory
from 4 to 3.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org> # v5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3595,7 +3595,10 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	 */
 	tcon->retry = volume_info->retry;
 	tcon->nocase = volume_info->nocase;
-	tcon->nohandlecache = volume_info->nohandlecache;
+	if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
+		tcon->nohandlecache = volume_info->nohandlecache;
+	else
+		tcon->nohandlecache = 1;
 	tcon->nodelete = volume_info->nodelete;
 	tcon->local_lease = volume_info->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);


