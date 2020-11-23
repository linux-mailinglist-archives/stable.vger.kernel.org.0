Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAC32C05D7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgKWMYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbgKWMYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 961082076E;
        Mon, 23 Nov 2020 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134290;
        bh=28der0o3osmfHOe5VzWj6q5t8fn5Cit52Ac1/oyRZ6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYfwbA9Zk/tWILmsNd4wM+KjzGYt7eU2/VLWI0yYgJpOwVe/3UcCk+wwe28CVYtqx
         X244u9T0FYxwzaVGVJ3ssqIbdDnNYXKtsOsvBTJgc+mdzfVQz2E8shbuaRoNWO+5vP
         mK3QiSFpz4dJZ+QK8/KUlogd1lOoS2wocEFRtqqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Yulevich <denisyu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 18/47] mlxsw: core: Use variable timeout for EMAD retries
Date:   Mon, 23 Nov 2020 13:22:04 +0100
Message-Id: <20201123121806.416945556@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
 drivers/net/ethernet/mellanox/mlxsw/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -436,7 +436,7 @@ static void mlxsw_emad_trans_timeout_sch
 {
 	unsigned long timeout = msecs_to_jiffies(MLXSW_EMAD_TIMEOUT_MS);
 
-	mlxsw_core_schedule_dw(&trans->timeout_dw, timeout);
+	mlxsw_core_schedule_dw(&trans->timeout_dw, timeout << trans->retries);
 }
 
 static int mlxsw_emad_transmit(struct mlxsw_core *mlxsw_core,


