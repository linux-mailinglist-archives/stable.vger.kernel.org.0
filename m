Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEBC246EB6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgHQRfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbgHQQRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:17:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7483C2075B;
        Mon, 17 Aug 2020 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681060;
        bh=JwBFHVM3zClCcFsLQOBYkaN/QxPl8gqzR3imMdH576I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjYnskCgbbSFLWvINDUAGhwzSibQKjhjCWrwhy6mCTo01TT0udAVje8zZhhkf5WaW
         m+q5X1GOoyQv/Fs7V1+rijPhvtIr/OyeDmsaWOJU8eHxEXGmj0Cxdmbq2TNtMTk7xO
         Kyih1e9alVjnZ71ZtuZQIhI3hA67RFh4jCV/0MTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 135/168] net/tls: Fix kmap usage
Date:   Mon, 17 Aug 2020 17:17:46 +0200
Message-Id: <20200817143740.446300902@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit b06c19d9f827f6743122795570bfc0c72db482b0 ]

When MSG_OOB is specified to tls_device_sendpage() the mapped page is
never unmapped.

Hold off mapping the page until after the flags are checked and the page
is actually needed.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -476,7 +476,7 @@ int tls_device_sendpage(struct sock *sk,
 			int offset, size_t size, int flags)
 {
 	struct iov_iter	msg_iter;
-	char *kaddr = kmap(page);
+	char *kaddr;
 	struct kvec iov;
 	int rc;
 
@@ -490,6 +490,7 @@ int tls_device_sendpage(struct sock *sk,
 		goto out;
 	}
 
+	kaddr = kmap(page);
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
 	iov_iter_kvec(&msg_iter, WRITE | ITER_KVEC, &iov, 1, size);


