Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0921E1EFA63
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgFEORF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgFEORE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CCA206A2;
        Fri,  5 Jun 2020 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366623;
        bh=gs9/lY+1QDQ5E52V460MMXznwqxNumfuWvVTDb9U+uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhO2/9IrU7IspBJ58prpwMhelImop+aW5d8BDpvpaKZIgok4/Yr8gHyBOrQoCMpu/
         +R7jhHrhU1z75sk2Zd4H8nTyB8nt4qbjQKUaVGsmLQbXq6hkAiiUij6PgVJYSWcesS
         pwWK47DkXKQkpHKEt2gkUEy7f8fKTPwbPJQQU7KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 28/43] selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer
Date:   Fri,  5 Jun 2020 16:14:58 +0200
Message-Id: <20200605140153.998720440@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit 46ca11177ed593f39d534f8d2c74ec5344e90c11 ]

Starting from iputils s20190709 (used in Fedora 31), arping does not
support timeout being specified as a decimal:

$ arping -c 1 -I swp1 -b 192.0.2.66 -q -w 0.1
arping: invalid argument: '0.1'

Previously, such timeouts were rounded to an integer.

Fix this by specifying the timeout as an integer.

Fixes: a5ee171d087e ("selftests: mlxsw: qos_mc_aware: Add a test for UC awareness")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 24dd8ed48580..b025daea062d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -300,7 +300,7 @@ test_uc_aware()
 	local i
 
 	for ((i = 0; i < attempts; ++i)); do
-		if $ARPING -c 1 -I $h1 -b 192.0.2.66 -q -w 0.1; then
+		if $ARPING -c 1 -I $h1 -b 192.0.2.66 -q -w 1; then
 			((passes++))
 		fi
 
-- 
2.25.1



