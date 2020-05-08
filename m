Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6AF1CAF6B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgEHNRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbgEHMng (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF889206B8;
        Fri,  8 May 2020 12:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941815;
        bh=N1QuJS+d5gBmirzhOh9f5RZpo50hIk/wDqEPpv55E0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6smHcF9DnBbz371xpwx0tvMdHkzO9UpbIqMKhlvLM9VRhlUh+59nZ56DCqqkXLYg
         vlYjAnf8XU1+DXDP035yxJA3vdvvoaaYDVkQ8RI4fCGftjGVLM5ydXusVjQJhH8+4V
         AXfYdGF7iuqp40qUSUE3TRYXaoNjbT6sO6K3N/k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 182/312] qlcnic: use the correct ring in qlcnic_83xx_process_rcv_ring_diag()
Date:   Fri,  8 May 2020 14:32:53 +0200
Message-Id: <20200508123137.285319631@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5b4d10f5e0369ed79434593b7cd8e85eebbe473f upstream.

There is a static checker warning here "warn: mask and shift to zero"
and the code sets "ring" to zero every time.  From looking at how
QLCNIC_FETCH_RING_ID() is used in qlcnic_83xx_process_rcv_ring() the
qlcnic_83xx_hndl() should be removed.

Fixes: 4be41e92f7c6 ('qlcnic: 83xx data path routines')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -2220,7 +2220,7 @@ void qlcnic_83xx_process_rcv_ring_diag(s
 	if (!opcode)
 		return;
 
-	ring = QLCNIC_FETCH_RING_ID(qlcnic_83xx_hndl(sts_data[0]));
+	ring = QLCNIC_FETCH_RING_ID(sts_data[0]);
 	qlcnic_83xx_process_rcv_diag(adapter, ring, sts_data);
 	desc = &sds_ring->desc_head[consumer];
 	desc->status_desc_data[0] = cpu_to_le64(STATUS_OWNER_PHANTOM);


