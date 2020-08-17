Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2408247064
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbgHQSIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388357AbgHQQI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:08:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEFB620658;
        Mon, 17 Aug 2020 16:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680508;
        bh=3Vmt7elrrY0Kx0wt65LnXkA3Dxd0dWGwpRqdwHSx8QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRlMKKh3njc5+yWIDG8GD9b5X8Bo/AeujltM5eQIOUHK7vZgB+VkKWj0KsQMtQCUf
         KeG53jCfZhBgXXlIM10Lu4djpOnU7tzsVmFVuDTjeKZNwKWfbyoImD5xfAXjOlr2Z1
         O8wf4i1icPyPfOy7AzSu4wa6qpKAgyBdncUk5oAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Sauter <pierre.sauter@stwm.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/270] SUNRPC: Fix ("SUNRPC: Add "@len" parameter to gss_unwrap()")
Date:   Mon, 17 Aug 2020 17:16:55 +0200
Message-Id: <20200817143806.437599061@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 986a4b63d3bc5f2c0eb4083b05aff2bf883b7b2f ]

Braino when converting "buf->len -=" to "buf->len = len -".

The result is under-estimation of the ralign and rslack values. On
krb5p mounts, this has caused READDIR to fail with EIO, and KASAN
splats when decoding READLINK replies.

As a result of fixing this oversight, the gss_unwrap method now
returns a buf->len that can be shorter than priv_len for small
RPC messages. The additional adjustment done in unwrap_priv_data()
can underflow buf->len. This causes the nfsd_request_too_large
check to fail during some NFSv3 operations.

Reported-by: Marian Rainer-Harbach
Reported-by: Pierre Sauter <pierre.sauter@stwm.de>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1886277
Fixes: 31c9590ae468 ("SUNRPC: Add "@len" parameter to gss_unwrap()")
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_wrap.c | 2 +-
 net/sunrpc/auth_gss/svcauth_gss.c   | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index 683755d950758..78ad416569969 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -584,7 +584,7 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *kctx, int offset, int len,
 							buf->head[0].iov_len);
 	memmove(ptr, ptr + GSS_KRB5_TOK_HDR_LEN + headskip, movelen);
 	buf->head[0].iov_len -= GSS_KRB5_TOK_HDR_LEN + headskip;
-	buf->len = len - GSS_KRB5_TOK_HDR_LEN + headskip;
+	buf->len = len - (GSS_KRB5_TOK_HDR_LEN + headskip);
 
 	/* Trim off the trailing "extra count" and checksum blob */
 	xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index fd91274e834d6..3645cd241d3ea 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -949,7 +949,6 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 
 	maj_stat = gss_unwrap(ctx, 0, priv_len, buf);
 	pad = priv_len - buf->len;
-	buf->len -= pad;
 	/* The upper layers assume the buffer is aligned on 4-byte boundaries.
 	 * In the krb5p case, at least, the data ends up offset, so we need to
 	 * move it around. */
-- 
2.25.1



