Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B70A2F7A25
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhAOMpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733203AbhAOMiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133B3235F8;
        Fri, 15 Jan 2021 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714268;
        bh=ZZWmJlUIDJ2JPv5b9I0qOYxGiQAFlC00RJvtuJxTiWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rL9JWbDkJ7h2ECcHw8a/Q3rMv3GjHEgks1/9XiblxlTeve+ltHI4RU5DPRQ7naTGi
         AJn6fbKJs1xHNRAFEHOGw+1SZ6VDmZJbP71MEofdYN1BBGjILi0gjL0uxcolnDDKJP
         6lR2nDLedWW0ss3Vkzdf90ry8qlUvRBjDe+0oLdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 032/103] chtls: Avoid unnecessary freeing of oreq pointer
Date:   Fri, 15 Jan 2021 13:27:25 +0100
Message-Id: <20210115122007.613127635@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit f8d15d29d6e6b32704c8fce9229716ca145a0de2 ]

In chtls_pass_accept_request(), removing the chtls_reqsk_free()
call to avoid oreq freeing twice. Here oreq is the pointer to
struct request_sock.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1396,7 +1396,7 @@ static void chtls_pass_accept_request(st
 
 	newsk = chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
 	if (!newsk)
-		goto free_oreq;
+		goto reject;
 
 	if (chtls_get_module(newsk))
 		goto reject;
@@ -1412,8 +1412,6 @@ static void chtls_pass_accept_request(st
 	kfree_skb(skb);
 	return;
 
-free_oreq:
-	chtls_reqsk_free(oreq);
 reject:
 	mk_tid_release(reply_skb, 0, tid);
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);


