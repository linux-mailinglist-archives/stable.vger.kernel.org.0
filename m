Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33693157935
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgBJNNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbgBJMil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922332080C;
        Mon, 10 Feb 2020 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338320;
        bh=W6R6/H9LJYmDqr1OCcfQ0aOFtqfURjgqrU8o3+YAPoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n//iwMoWpWU3SRnQ5hr+8+SQlYtSGMW+FR9jeVSZAymF/RhEsSpowwEtg6yx67Rof
         urNcCEXoVD7T6YHm9SbVblpXLoOPZHDL2oMkbty6ujZS7cIM0p7LljvkqvmQZ+kxRi
         Gxj3sqKy6D+cptlgwWJWXMUICjO6w0KwhODsCLTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Prabhath Sajeepa <psajeepa@purestorage.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 251/309] IB/mlx5: Fix outstanding_pi index for GSI qps
Date:   Mon, 10 Feb 2020 04:33:27 -0800
Message-Id: <20200210122430.633901238@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prabhath Sajeepa <psajeepa@purestorage.com>

commit b5671afe5e39ed71e94eae788bacdcceec69db09 upstream.

Commit b0ffeb537f3a ("IB/mlx5: Fix iteration overrun in GSI qps") changed
the way outstanding WRs are tracked for the GSI QP. But the fix did not
cover the case when a call to ib_post_send() fails and updates index to
track outstanding.

Since the prior commmit outstanding_pi should not be bounded otherwise the
loop generate_completions() will fail.

Fixes: b0ffeb537f3a ("IB/mlx5: Fix iteration overrun in GSI qps")
Link: https://lore.kernel.org/r/1576195889-23527-1-git-send-email-psajeepa@purestorage.com
Signed-off-by: Prabhath Sajeepa <psajeepa@purestorage.com>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/gsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -507,8 +507,7 @@ int mlx5_ib_gsi_post_send(struct ib_qp *
 		ret = ib_post_send(tx_qp, &cur_wr.wr, bad_wr);
 		if (ret) {
 			/* Undo the effect of adding the outstanding wr */
-			gsi->outstanding_pi = (gsi->outstanding_pi - 1) %
-					      gsi->cap.max_send_wr;
+			gsi->outstanding_pi--;
 			goto err;
 		}
 		spin_unlock_irqrestore(&gsi->lock, flags);


