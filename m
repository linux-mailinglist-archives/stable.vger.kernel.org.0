Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF12414E67
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfEFOmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbfEFOmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:42:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0EB20449;
        Mon,  6 May 2019 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153752;
        bh=kb4YRoMz1q9JxSCiNz5n5guxW0c2uzMpx47xBcCN2qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1KPdojLdOnKzQaqO0sth2LEVzMyM5r6I+qfJsp9WVsnA3VGaHwGVB2w67Qhi38IO
         nLt2/n31/DyJKjCWH4BfGVm1JuQ2HF1T9U3HYDMApzOZMVs+knunFlL/AFHQsVzEUz
         p2bEHEOMW3mS47rhxu2wvrQuXMbLDJMOpiU0T3lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 83/99] IB/core: Unregister notifier before freeing MAD security
Date:   Mon,  6 May 2019 16:32:56 +0200
Message-Id: <20190506143101.548249942@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

commit d60667fc398ed34b3c7456b020481c55c760e503 upstream.

If the notifier runs after the security context is freed an access of
freed memory can occur.

Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/security.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -728,9 +728,10 @@ void ib_mad_agent_security_cleanup(struc
 	if (!rdma_protocol_ib(agent->device, agent->port_num))
 		return;
 
-	security_ib_free_security(agent->security);
 	if (agent->lsm_nb_reg)
 		unregister_lsm_notifier(&agent->lsm_nb);
+
+	security_ib_free_security(agent->security);
 }
 
 int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index)


