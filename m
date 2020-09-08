Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76A7261E62
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgIHTvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgIHPt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE7B2485D;
        Tue,  8 Sep 2020 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579922;
        bh=Q0s+No+VwSBihjIHi1xxZfkgr3aWqm7PPMb0lJeQw4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzKiQ7792d/hIt6YLu5j5PDIAUfhGYHYOliWXFlEiDEFbWV2c3742XUtasR5gDzMp
         YYxj9qITEVHBNH4uhxwT7EIg3t5PYq1zzG/X/eRRZ8JvakUOgXHIq96MVVXKveeJFp
         Z8pso5kZBaX7FYFPa+8WTlCEG5ZEVhJWonqzvBKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/129] Revert "net: dsa: microchip: set the correct number of ports"
Date:   Tue,  8 Sep 2020 17:25:29 +0200
Message-Id: <20200908152234.112893103@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d55dad8b1d893fae0c4e778abf2ace048bcbad86.

Upstream commit af199a1a9cb0 ("net: dsa: microchip: set the correct
number of ports") seems to have been applied twice on top of the 5.4
branch. This revert the second instance of said commit.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 3 ---
 drivers/net/dsa/microchip/ksz9477.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8d50aacd19e51..84c4319e3b31f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1270,9 +1270,6 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
 
-	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt;
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index b15da9a8e3bb9..49ab1346dc3f7 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -515,9 +515,6 @@ static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
 			     PORT_VLAN_LOOKUP_VID_0, false);
 	}
 
-	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt;
-
 	return 0;
 }
 
-- 
2.25.1



