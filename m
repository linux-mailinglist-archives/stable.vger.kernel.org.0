Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5241CAB07
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgEHMjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgEHMjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4653A2495F;
        Fri,  8 May 2020 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941548;
        bh=NducT023nwiNoUlVzfNfhqduldpolUNeS4mDLwt4BWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8QH/JJ4UemFGebGg07mvPrpIo9XFSllLYXXNaDNQk8atYNE9jEOaQRbHSqAmHPZP
         02oBMNfjVAhSO3RaTasU9O6X95WjUHxuSQWcpZsqzHhYsglZXT4o2Fc4MPHbK+250Z
         qtL9cpFWrhpCoBp329TI6/PpzHjuXI282MYYelAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 077/312] net/mlx5: Fix the size of modify QP mailbox
Date:   Fri,  8 May 2020 14:31:08 +0200
Message-Id: <20200508123129.938048967@linuxfoundation.org>
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

From: Majd Dibbiny <majd@mellanox.com>

commit 418f8399a8bedf376ec13eb01088f04a76ebdd6f upstream.

Add 16 reserved bytes at the end of mlx5_modify_qp_mbox_in to
match the hardware spec definition.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mlx5/qp.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -539,6 +539,7 @@ struct mlx5_modify_qp_mbox_in {
 	__be32			optparam;
 	u8			rsvd1[4];
 	struct mlx5_qp_context	ctx;
+	u8			rsvd2[16];
 };
 
 struct mlx5_modify_qp_mbox_out {


