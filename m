Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3A1CAF83
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgEHMke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgEHMkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E86F24968;
        Fri,  8 May 2020 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941630;
        bh=q5eylGLhRXdWXDttS54e99ejHhVcbX7hzaz1XTM5AFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu7SGvOKJqMg+OFRK8thaLoO8HkPTtFS3ag3HBIGZxzM/vSZX8pLV69Ag+4ZG07N0
         SdGPPrk4coibM+BZ4AFGUKiOplSCj1MjKQe5ajyyLtbVl3KQw6wcb/5fdsKlC1buyt
         +08RiT4sCm36ZNfMyz0jqqxitz6jFiivPjOjMPrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 059/312] mlxsw: pci: Correctly determine if descriptor queue is full
Date:   Fri,  8 May 2020 14:30:50 +0200
Message-Id: <20200508123128.705713327@linuxfoundation.org>
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

From: Ido Schimmel <idosch@mellanox.com>

commit 5091730d7795ccb21eb880699b5194730641c70b upstream.

The descriptor queues for sending (SDQs) and receiving (RDQs) packets
are managed by two counters - producer and consumer - which are both
16-bit in size. A queue is considered full when the difference between
the two equals the queue's maximum number of descriptors.

However, if the producer counter overflows, then it's possible for the
full queue check to fail, as it doesn't take the overflow into account.
In such a case, descriptors already passed to the device - but for which
a completion has yet to be posted - will be overwritten, thereby causing
undefined behavior. The above can be achieved under heavy load (~30
netperf instances).

Fix that by casting the subtraction result to u16, preventing it from
being treated as a signed integer.

Fixes: eda6500a987a ("mlxsw: Add PCI bus implementation")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -215,7 +215,7 @@ mlxsw_pci_queue_elem_info_producer_get(s
 {
 	int index = q->producer_counter & (q->count - 1);
 
-	if ((q->producer_counter - q->consumer_counter) == q->count)
+	if ((u16) (q->producer_counter - q->consumer_counter) == q->count)
 		return NULL;
 	return mlxsw_pci_queue_elem_info_get(q, index);
 }


