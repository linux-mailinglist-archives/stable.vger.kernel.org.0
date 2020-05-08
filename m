Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071B91CAB92
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgEHMov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbgEHMou (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7031C208D6;
        Fri,  8 May 2020 12:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941889;
        bh=4prF8DDv8Jnj9rAclIfEACuTg4aF5Tl7SY7vnNaeCGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drHXDaqyAcojqEkHXiBd4U/9DlURj+RjF7cpfCcL+pfyTKsUEQQ+UgO8F4rnFUCyB
         Z2hjLtHWnwDwaYrrXpkajIvTckI9r1lzIRF+sHusKsu7zSLHESCl8yL0M2WUaschvt
         tZoCc4UIknmlv62KeaT3LcLxg3oJT0/sMKbYdcUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 213/312] net/mlx4_core: Fix access to uninitialized index
Date:   Fri,  8 May 2020 14:33:24 +0200
Message-Id: <20200508123139.404678970@linuxfoundation.org>
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

From: Tariq Toukan <tariqt@mellanox.com>

commit 2bb07e155bb3e0c722c806723f737cf8020961ef upstream.

Prevent using uninitialized or negative index when handling
steering entries.

Fixes: b12d93d63c32 ('mlx4: Add support for promiscuous mode in the new steering model.')
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/mcg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1109,7 +1109,7 @@ int mlx4_qp_attach_common(struct mlx4_de
 	struct mlx4_cmd_mailbox *mailbox;
 	struct mlx4_mgm *mgm;
 	u32 members_count;
-	int index, prev;
+	int index = -1, prev;
 	int link = 0;
 	int i;
 	int err;
@@ -1188,7 +1188,7 @@ int mlx4_qp_attach_common(struct mlx4_de
 		goto out;
 
 out:
-	if (prot == MLX4_PROT_ETH) {
+	if (prot == MLX4_PROT_ETH && index != -1) {
 		/* manage the steering entry for promisc mode */
 		if (new_entry)
 			err = new_steering_entry(dev, port, steer,


