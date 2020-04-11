Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35281A51C3
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgDKM1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgDKMNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:13:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AAA320787;
        Sat, 11 Apr 2020 12:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607213;
        bh=ZK58EhlMOeO9CO4NzNnLbrS6ZtcPRg7CXCnEljICNWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ku+zub3XT5/SaO8vY4A/LaPFjnr7iOmdSVN2YzUwv8csTspzD9vma4zkxSpur8xRY
         SRmVv8wJyYfsVtXt//OEh/RmDKUqJHlFwKR8wK4i+623wD04sACFzw1P6XSorQokjb
         SR/2Pih9wg/+9dyyIPavIXElk1us8qHgH5VXdaUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 20/38] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE
Date:   Sat, 11 Apr 2020 14:09:04 +0200
Message-Id: <20200411115440.081210401@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit ccfc569347f870830e7c7cf854679a06cf9c45b5 ]

The handler for FLOW_ACTION_VLAN_MANGLE ends by returning whatever the
lower-level function that it calls returns. If there are more actions lined
up after this action, those are never offloaded. Fix by only bailing out
when the called function returns an error.

Fixes: a150201a70da ("mlxsw: spectrum: Add support for vlan modify TC action")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -112,9 +112,11 @@ static int mlxsw_sp_flower_parse_actions
 			u8 prio = tcf_vlan_push_prio(a);
 			u16 vid = tcf_vlan_push_vid(a);
 
-			return mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
-							   action, vid,
-							   proto, prio);
+			err = mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
+							  action, vid,
+							  proto, prio);
+			if (err)
+				return err;
 		} else {
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
 			return -EOPNOTSUPP;


