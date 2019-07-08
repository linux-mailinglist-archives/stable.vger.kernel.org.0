Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C32624FA
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbfGHPSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733117AbfGHPSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73BA5216E3;
        Mon,  8 Jul 2019 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599128;
        bh=Pye/p9PcyC9LCsMm/JO/a8E44rYQin15gAiJQ4UK8Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hW+PI1QSfLN3JxBg/+Ngbeu5vAJDDBIc8h/VGAcxwon8m9Vr6kHtiPmfPT3yHv34z
         zUU9AA62huy0raWk0sjx++YfA/QsJaIKyUsP/Fa0xZrHgi/vayshyg9bSd3tXUlvLV
         L2DAlXDI+cRwb8r9tTjQDD27th57ER0C+ifGn7Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 015/102] net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0
Date:   Mon,  8 Jul 2019 17:12:08 +0200
Message-Id: <20190708150526.922729679@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62394708f3e01c9f2be6be74eb6305bae1ed924f ]

When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
message is logged:

failed to kill vid 0081/0 for device eth_cu_1000_4

This is caused by call from __vlan_vid_del() with vin set to zero, over
call chain this results into _mv88e6xxx_port_vlan_del() called with
vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.

On symmetric path moving port up, call goes through
mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
that returns -EOPNOTSUPP for zero vid.

This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
zero vid, then this error code is explicitly cleared in
dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dc510069d37b..2edd193c96ab 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1742,7 +1742,7 @@ static int _mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	int err;
 
 	if (!vid)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	err = _mv88e6xxx_vtu_vid_write(chip, vid - 1);
 	if (err)
-- 
2.20.1



