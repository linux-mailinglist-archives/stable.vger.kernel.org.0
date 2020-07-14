Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01821FAB9
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgGNSzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbgGNSzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9680222BEF;
        Tue, 14 Jul 2020 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752906;
        bh=YhQ2ixbfhp4SiAICf1XQbHb7sW6dkMUmpy8IK3GkMpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqFoO1r5mk25sNEPvIhM4E9yk5IvIbMmW2gLXztlWz8bHNGIRo8UekHAsnYHirh2k
         Iq3gmB4Ne0vP0O0COiYCqYwhbMointaitng65yB2rOx3QsXewy9TL2ptg8mR0azgUZ
         zeVizL66VWII0iNGUXczRM4L7hM6RhLZqNmZg2V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 045/166] net: qrtr: Fix an out of bounds read qrtr_endpoint_post()
Date:   Tue, 14 Jul 2020 20:43:30 +0200
Message-Id: <20200714184118.037636310@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8ff41cc21714704ef0158a546c3c4d07fae2c952 upstream.

This code assumes that the user passed in enough data for a
qrtr_hdr_v1 or qrtr_hdr_v2 struct, but it's not necessarily true.  If
the buffer is too small then it will read beyond the end.

Reported-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reported-by: syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com
Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/qrtr/qrtr.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -427,7 +427,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 	unsigned int ver;
 	size_t hdrlen;
 
-	if (len & 3)
+	if (len == 0 || len & 3)
 		return -EINVAL;
 
 	skb = netdev_alloc_skb(NULL, len);
@@ -441,6 +441,8 @@ int qrtr_endpoint_post(struct qrtr_endpo
 
 	switch (ver) {
 	case QRTR_PROTO_VER_1:
+		if (len < sizeof(*v1))
+			goto err;
 		v1 = data;
 		hdrlen = sizeof(*v1);
 
@@ -454,6 +456,8 @@ int qrtr_endpoint_post(struct qrtr_endpo
 		size = le32_to_cpu(v1->size);
 		break;
 	case QRTR_PROTO_VER_2:
+		if (len < sizeof(*v2))
+			goto err;
 		v2 = data;
 		hdrlen = sizeof(*v2) + v2->optlen;
 


