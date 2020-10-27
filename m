Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8965129B9BE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802767AbgJ0PvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802378AbgJ0PrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D5C21D42;
        Tue, 27 Oct 2020 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813626;
        bh=SW88eK/jiGDxVxGbT2VqM6v0JHZOAYAyIZmEZo2DG58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUnSoEiKrihpX7rL2LJMjYBTW8viNVmktO6YNtzxDKvk4QphOuPVHVw0vXByju5W0
         G6za65Kh3qjXZwnGJwioapCIacCx467YbN9R8nTkoj+wTbX+FrTx/edf4nM93pA+Oh
         UsII8t+ikSG+TIASYjHQBdnx3QhNbz5dR2Fyj/34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 574/757] net: dsa: seville: the packet buffer is 2 megabits, not megabytes
Date:   Tue, 27 Oct 2020 14:53:44 +0100
Message-Id: <20201027135517.435448109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit a15a6afb3bf9388eb83a4b876d3453f305fba909 ]

The VSC9953 Seville switch has 2 megabits of buffer split into 4360
words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
2 megabits is (2048 / 8) * 1024 = 256 * 1024.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue system")
Link: https://lore.kernel.org/r/20201019050625.21533-1-fido_max@inbox.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 9e9fd19e1d00c..e2cd49eec0370 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1010,7 +1010,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
 	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 2048 * 1024,
+	.shared_queue_sz	= 256 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
-- 
2.25.1



