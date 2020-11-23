Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9B72C0616
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgKWM1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgKWM1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A1C420888;
        Mon, 23 Nov 2020 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134449;
        bh=bvJOhSxgWar3+h+GrQTGBdx1KFwP/r4gC7sLgSRsrI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0coLJdhXH7Xf62Q1lSxzNjW8xkx6kHaZYQ/7lefU8La5JeLXv+1lh6Oz1rDyJi0R
         Br9tBV80lyHouJkUUjAjfeMKvrVw57ksUEMybNdpDbqjToi3JXUJ3rg9Hm5vw4orQM
         4QLjnxoNheMAz0MlGoNp5L8nM1YphL1AlkT/LsU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Yulevich <denisyu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 06/60] mlxsw: core: Use variable timeout for EMAD retries
Date:   Mon, 23 Nov 2020 13:21:48 +0100
Message-Id: <20201123121805.349935900@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1f492eab67bced119a0ac7db75ef2047e29a30c6 ]

The driver sends Ethernet Management Datagram (EMAD) packets to the
device for configuration purposes and waits for up to 200ms for a reply.
A request is retried up to 5 times.

When the system is under heavy load, replies are not always processed in
time and EMAD transactions fail.

Make the process more robust to such delays by using exponential
backoff. First wait for up to 200ms, then retransmit and wait for up to
400ms and so on.

Fixes: caf7297e7ab5 ("mlxsw: core: Introduce support for asynchronous EMAD register access")
Reported-by: Denis Yulevich <denisyu@nvidia.com>
Tested-by: Denis Yulevich <denisyu@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -471,7 +471,8 @@ static void mlxsw_emad_trans_timeout_sch
 	if (trans->core->fw_flash_in_progress)
 		timeout = msecs_to_jiffies(MLXSW_EMAD_TIMEOUT_DURING_FW_FLASH_MS);
 
-	queue_delayed_work(trans->core->emad_wq, &trans->timeout_dw, timeout);
+	queue_delayed_work(trans->core->emad_wq, &trans->timeout_dw,
+			   timeout << trans->retries);
 }
 
 static int mlxsw_emad_transmit(struct mlxsw_core *mlxsw_core,


