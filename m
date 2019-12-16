Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B42121936
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfLPRx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbfLPRx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED5E920733;
        Mon, 16 Dec 2019 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518806;
        bh=dDBDlbf091Mgq77WY0ie6J14Z/JMU3bD7FbbkoZrOnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrCrMviGdpzol3YP/oMpPmj1E/MJENrFANC/4iB8OiOVLuaWg6Kol43Cc6YqqQEFr
         QA49xfPX71P3PSwy2wNuqcTpLsqs/trufJA3l+cdlBIbrA4omMN4xZs7eidIzfDvQi
         Rk6oQiknEgidyYTVyvRaYtMx4jlMLLnTOiq1wrFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/267] lockd: fix decoding of TEST results
Date:   Mon, 16 Dec 2019 18:46:41 +0100
Message-Id: <20191216174856.855742103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit b8db159239b3f51e2b909859935cc25cb3ff3eed ]

We fail to advance the read pointer when reading the stat.oh field that
identifies the lock-holder in a TEST result.

This turns out not to matter if the server is knfsd, which always
returns a zero-length field.  But other servers (Ganesha is an example)
may not do this.  The result is bad values in fcntl F_GETLK results.

Fix this.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/clnt4xdr.c | 22 ++++++----------------
 fs/lockd/clntxdr.c  | 22 ++++++----------------
 2 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index 00d5ef5f99f73..214a2fa1f1e39 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -128,24 +128,14 @@ static void encode_netobj(struct xdr_stream *xdr,
 static int decode_netobj(struct xdr_stream *xdr,
 			 struct xdr_netobj *obj)
 {
-	u32 length;
-	__be32 *p;
+	ssize_t ret;
 
-	p = xdr_inline_decode(xdr, 4);
-	if (unlikely(p == NULL))
-		goto out_overflow;
-	length = be32_to_cpup(p++);
-	if (unlikely(length > XDR_MAX_NETOBJ))
-		goto out_size;
-	obj->len = length;
-	obj->data = (u8 *)p;
+	ret = xdr_stream_decode_opaque_inline(xdr, (void *)&obj->data,
+						XDR_MAX_NETOBJ);
+	if (unlikely(ret < 0))
+		return -EIO;
+	obj->len = ret;
 	return 0;
-out_size:
-	dprintk("NFS: returned netobj was too long: %u\n", length);
-	return -EIO;
-out_overflow:
-	print_overflow_msg(__func__, xdr);
-	return -EIO;
 }
 
 /*
diff --git a/fs/lockd/clntxdr.c b/fs/lockd/clntxdr.c
index 2c6176387143c..747b9c8c940ac 100644
--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -125,24 +125,14 @@ static void encode_netobj(struct xdr_stream *xdr,
 static int decode_netobj(struct xdr_stream *xdr,
 			 struct xdr_netobj *obj)
 {
-	u32 length;
-	__be32 *p;
+	ssize_t ret;
 
-	p = xdr_inline_decode(xdr, 4);
-	if (unlikely(p == NULL))
-		goto out_overflow;
-	length = be32_to_cpup(p++);
-	if (unlikely(length > XDR_MAX_NETOBJ))
-		goto out_size;
-	obj->len = length;
-	obj->data = (u8 *)p;
+	ret = xdr_stream_decode_opaque_inline(xdr, (void *)&obj->data,
+			XDR_MAX_NETOBJ);
+	if (unlikely(ret < 0))
+		return -EIO;
+	obj->len = ret;
 	return 0;
-out_size:
-	dprintk("NFS: returned netobj was too long: %u\n", length);
-	return -EIO;
-out_overflow:
-	print_overflow_msg(__func__, xdr);
-	return -EIO;
 }
 
 /*
-- 
2.20.1



