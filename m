Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28ED396269
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhEaO4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233130AbhEaOxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 533FC61CAD;
        Mon, 31 May 2021 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469540;
        bh=3Shp8sSKKLxkGkhTI0C21kKKh1LOq5TbLqI58tEXAGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvUvIM33yR2tTpmubg3VwmowqVwES3171TSdv1twrdpEQnyE3HXbFd5/qJwgyECjp
         cqT99K/ppdY7dxhi453mjOXm6UdLnL0XTi8LbAsXQCzL0ixZmmYk29egU7dC36brZW
         rvpo2azO7VubTW1n1tM2fva9wWc9lpuAqfQI7c0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 236/296] chelsio/chtls: unlock on error in chtls_pt_recvmsg()
Date:   Mon, 31 May 2021 15:14:51 +0200
Message-Id: <20210531130711.737664546@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 832ce924b1a14e139e184a6da9f5a69a5e47b256 ]

This error path needs to release some memory and call release_sock(sk);
before returning.

Fixes: 6919a8264a32 ("Crypto/chtls: add/delete TLS header in driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 188d871f6b8c..c320cc8ca68d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1564,8 +1564,10 @@ found_ok_skb:
 			cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
 					sizeof(thdr->type), &thdr->type);
 
-			if (cerr && thdr->type != TLS_RECORD_TYPE_DATA)
-				return -EIO;
+			if (cerr && thdr->type != TLS_RECORD_TYPE_DATA) {
+				copied = -EIO;
+				break;
+			}
 			/*  don't send tls header, skip copy */
 			goto skip_copy;
 		}
-- 
2.30.2



