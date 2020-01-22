Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C31455BE
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgAVNYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgAVNYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:51 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6D424697;
        Wed, 22 Jan 2020 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699490;
        bh=1YzfcHjs92uvAFnhEsI/u9hRXryDJjS0n+AS3ZKt7l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afGH3CTAh4hIVJUmOnkCLubYuv9uOU3kl4pTQ5gh6XYhiaCTizAKAEzuwJKm4oRm6
         CbHiDREuGTtXtvK2w3A8NgtZLyLY+meTgLMITMQRyGeUfSw5bHose5sXkW+VdZaVgc
         Dg4mtRycxo6vxCWQ1KWazedNQmjaCaGWqz5BG0Lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 162/222] mlxsw: spectrum: Wipe xstats.backlog of down ports
Date:   Wed, 22 Jan 2020 10:29:08 +0100
Message-Id: <20200122092845.313521947@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

commit ca7609ff3680c51d6c29897f3117aa2ad904f92a upstream.

Per-port counter cache used by Qdiscs is updated periodically, unless the
port is down. The fact that the cache is not updated for down ports is no
problem for most counters, which are relative in nature. However, backlog
is absolute in nature, and if there is a non-zero value in the cache around
the time that the port goes down, that value just stays there. This value
then leaks to offloaded Qdiscs that report non-zero backlog even if
there (obviously) is no traffic.

The HW does not keep backlog of a downed port, so do likewise: as the port
goes down, wipe the backlog value from xstats.

Fixes: 075ab8adaf4e ("mlxsw: spectrum: Collect tclass related stats periodically")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1161,6 +1161,9 @@ static void update_stats_cache(struct wo
 			     periodic_hw_stats.update_dw.work);
 
 	if (!netif_carrier_ok(mlxsw_sp_port->dev))
+		/* Note: mlxsw_sp_port_down_wipe_counters() clears the cache as
+		 * necessary when port goes down.
+		 */
 		goto out;
 
 	mlxsw_sp_port_get_hw_stats(mlxsw_sp_port->dev,
@@ -4170,6 +4173,15 @@ static int mlxsw_sp_port_unsplit(struct
 	return 0;
 }
 
+static void
+mlxsw_sp_port_down_wipe_counters(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	int i;
+
+	for (i = 0; i < TC_MAX_QUEUE; i++)
+		mlxsw_sp_port->periodic_hw_stats.xstats.backlog[i] = 0;
+}
+
 static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 				     char *pude_pl, void *priv)
 {
@@ -4191,6 +4203,7 @@ static void mlxsw_sp_pude_event_func(con
 	} else {
 		netdev_info(mlxsw_sp_port->dev, "link down\n");
 		netif_carrier_off(mlxsw_sp_port->dev);
+		mlxsw_sp_port_down_wipe_counters(mlxsw_sp_port);
 	}
 }
 


