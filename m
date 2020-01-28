Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02D314B611
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgA1OCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgA1OB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9C012468A;
        Tue, 28 Jan 2020 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220119;
        bh=5U/qTJZ9hKV8uZcz6cF61Xy7FyZJKlPLbrzhNYoQQoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7XpsI6ysnG6XESNWEO81+xrZOwRDDCGmEzDnedxI3ru+CVizKS0/z2mZuCqzJvUA
         Ii1NDsWn7jLRY3kY8252cOjNJtPHGVkEH3037im22ZVSjDIQDI97CSEErBHttTze9p
         9oUC0MQRfP1xE0ttCcDwkOtlvvNvmN/vd3ffd9Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 024/104] net/mlx5: Fix lowest FDB pool size
Date:   Tue, 28 Jan 2020 14:59:45 +0100
Message-Id: <20200128135820.633225472@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

commit 93b8a7ecb7287cc9b0196f12a25b57c2462d11dc upstream.

The pool sizes represent the pool sizes in the fw. when we request
a pool size from fw, it will return the next possible group.
We track how many pools the fw has left and start requesting groups
from the big to the small.
When we start request 4k group, which doesn't exists in fw, fw
wants to allocate the next possible size, 64k, but will fail since
its exhausted. The correct smallest pool size in fw is 128 and not 4k.

Fixes: e52c28024008 ("net/mlx5: E-Switch, Add chains and priorities")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -858,7 +858,7 @@ out:
  */
 #define ESW_SIZE (16 * 1024 * 1024)
 const unsigned int ESW_POOLS[4] = { 4 * 1024 * 1024, 1 * 1024 * 1024,
-				    64 * 1024, 4 * 1024 };
+				    64 * 1024, 128 };
 
 static int
 get_sz_from_pool(struct mlx5_eswitch *esw)


