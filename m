Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78F410BD0A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfK0VAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbfK0VAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6452084B;
        Wed, 27 Nov 2019 21:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888435;
        bh=kvrgsIZ8Gymbi6c4WYY9shIxHq3UQvTGVVPm6yj3KAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEut9ZKAadiq6bgmAPSaAzNhWAjcDuk5rVlFg2l5+XmF6yuadiUwVjtuN2silL/Q2
         LKD6w9ilE+deqYfSwx+ucp3KS2kN/G6WXAZPAVdELbCexFZneMk2CAlaijEd/AP57o
         I1yOqci+4ozss+z44wpWB05A3tcBI2UJSqHn1kDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Garry McNulty <garrmcnu@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/306] fs/cifs: fix uninitialised variable warnings
Date:   Wed, 27 Nov 2019 21:29:42 +0100
Message-Id: <20191127203124.721719986@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Garry McNulty <garrmcnu@gmail.com>

[ Upstream commit ef2298a06d012973bbc592b86fe5ff730d4d0c63 ]

In some error conditions, resp_buftype can be passed uninitialised to
free_rsp_buf(), potentially resulting in a spurious debug message.
If resp_buftype randomly had the value 1 (CIFS_SMALL_BUFFER) then this
would log a debug message.
The rsp pointer is initialised to NULL so there is no other side-effect.

Detected by CoverityScan, CID 1438585 ("Uninitialized scalar variable")
Detected by CoverityScan, CID 1438667 ("Uninitialized scalar variable")
Detected by CoverityScan, CID 1438764 ("Uninitialized scalar variable")

Signed-off-by: Garry McNulty <garrmcnu@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b1f5d0d28335a..9194f17675c89 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2283,7 +2283,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
 
@@ -2570,7 +2570,7 @@ SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 
 	cifs_dbg(FYI, "Close\n");
@@ -2723,7 +2723,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int rc = 0;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
 
-- 
2.20.1



