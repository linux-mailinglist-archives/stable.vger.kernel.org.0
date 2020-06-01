Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75321EA8DC
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgFAR4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbgFAR4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E99B2074B;
        Mon,  1 Jun 2020 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034193;
        bh=8X9HU6b1c4jo32TsWzW6l8edB1iW46dxxPn50t0tRjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHJ8N6CMpjHgRfiVG4avVeClI4OUSg0HZlpBjfaLDdROp1tt57Bo1fa3L17KVzvtJ
         7lbTmlXCga6TeTbMB8psO8vQ+YFw/6foScOVvZs1Xnl7REsUTLAliTxmxg9ATBTyiv
         /m0h/DtqNFndJyUiNjQkW4WiIoLJL3dZLVxNgk7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 06/48] net/mlx4_core: fix a memory leak bug.
Date:   Mon,  1 Jun 2020 19:53:16 +0200
Message-Id: <20200601173953.870589538@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit febfd9d3c7f74063e8e630b15413ca91b567f963 upstream.

In function mlx4_opreq_action(), pointer "mailbox" is not released,
when mlx4_cmd_box() return and error, causing a memory leak bug.
Fix this issue by going to "out" label, mlx4_free_cmd_mailbox() can
free this pointer.

Fixes: fe6f700d6cbb ("net/mlx4_core: Respond to operation request by firmware")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2522,7 +2522,7 @@ void mlx4_opreq_action(struct work_struc
 		if (err) {
 			mlx4_err(dev, "Failed to retrieve required operation: %d\n",
 				 err);
-			return;
+			goto out;
 		}
 		MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);
 		MLX4_GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);


