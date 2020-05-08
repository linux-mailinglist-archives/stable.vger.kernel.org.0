Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B8E1CAEA8
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgEHMpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbgEHMpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01222208D6;
        Fri,  8 May 2020 12:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941917;
        bh=VyJB4voVU/kpMkxlpMjovjGyAfsim1CjcFShiatto98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNdQXxJ0obXliMUreX5bxg8KvlhYcdp8QTXfgzsxM9sgyBDz0rC3bobX3AFMZ0O9F
         7Ypu1rmX9A2+C4kpdRmaCoxKtCRXsJL+kwr5IhFajL9kXk2u43L+WBbIenRQn9zhOD
         0whxOweVButoNX3qHv2l0lKFZ9Yhe1jzqTj6/JVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elad Raz <eladr@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 223/312] mlxsw: switchx2: Fix ethernet port initialization
Date:   Fri,  8 May 2020 14:33:34 +0200
Message-Id: <20200508123140.141329888@linuxfoundation.org>
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

From: Elad Raz <eladr@mellanox.com>

commit 7fb6a36bab6b0b158f93eb13faa1b440f8b26009 upstream.

When creating an ethernet port fails, we must move the port to disable,
otherwise putting the port in switch partition 0 (ETH) or 1 (IB) will
always fails.

Fixes: 31557f0f9755 ("mlxsw: Introduce Mellanox SwitchX-2 ASIC support")
Signed-off-by: Elad Raz <eladr@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1074,6 +1074,7 @@ err_port_stp_state_set:
 err_port_admin_status_set:
 err_port_mtu_set:
 err_port_speed_set:
+	mlxsw_sx_port_swid_set(mlxsw_sx_port, MLXSW_PORT_SWID_DISABLED_PORT);
 err_port_swid_set:
 err_port_system_port_mapping_set:
 port_not_usable:


