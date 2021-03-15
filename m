Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223D333B59A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhCONyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231496AbhCONyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADB2664EF0;
        Mon, 15 Mar 2021 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816473;
        bh=1Kd/rquBxZVICU9rF5Lu5//Qw5/yd4S4wz7lW+9kBkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7nXbHgWtUL8G95LcySCpJZmRAfvQZl32l3TMdlpqF7lrDnR2iAtKC6CeTZauOZmx
         R/N/REIRDqyBVz3sbavVID2uY173r37yasoLA0sn4627u4aWMTq75dU1jWAO7dbv3n
         Z8cMGOWFno5cz70JHVOfVUFwqt6BPNpvv2y96I+I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 60/78] sh_eth: fix TRSCER mask for R7S72100
Date:   Mon, 15 Mar 2021 14:52:23 +0100
Message-Id: <20210315135214.041770782@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 75be7fb7f978202c4c3a1a713af4485afb2ff5f6 ]

According  to  the RZ/A1H Group, RZ/A1M Group User's Manual: Hardware,
Rev. 4.00, the TRSCER register has bit 9 reserved, hence we can't use
the driver's default TRSCER mask.  Add the explicit initializer for
sh_eth_cpu_data::trscer_err_mask for R7S72100.

Fixes: db893473d313 ("sh_eth: Add support for r7s72100")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 7458b1a70e5d..0e5b1935af50 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -526,6 +526,8 @@ static struct sh_eth_cpu_data r7s72100_data = {
 			  EESR_TDE | EESR_ECI,
 	.fdr_value	= 0x0000070f,
 
+	.trscer_err_mask = DESC_I_RINT8 | DESC_I_RINT5,
+
 	.no_psr		= 1,
 	.apr		= 1,
 	.mpr		= 1,
-- 
2.30.1



