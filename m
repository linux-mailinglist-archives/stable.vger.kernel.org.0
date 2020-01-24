Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB7A1480C1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbgAXLON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389526AbgAXLOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:14:12 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F202E20708;
        Fri, 24 Jan 2020 11:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864451;
        bh=JSYqf9UNdV7udgc9jrlSqdeo2E25WTgSVlEeMfRl1qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScT2KxNg5O/D7RbwR1bx1UMbLGe26rEc0jfn1gL3uXipkF1MjW2hHqlbo0YWS/6v3
         U9urtDRqG2Udrk8v45E/Smw81hUAo0uU/+yz8miAF1ukAZO7AqCshicKbuxRuDUMGx
         WSsT914YmflHtgVCn28+dIYAhhWXfGNu+dMR8ESA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 256/639] nfp: fix simple vNIC mailbox length
Date:   Fri, 24 Jan 2020 10:27:06 +0100
Message-Id: <20200124093118.771044665@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

[ Upstream commit eaab2d2d0fe4393b040dbf3922e18cd2ab7d6b85 ]

The simple vNIC mailbox length should be 12 decimal and not 0x12.
Using a decimal also makes it clear this is a length value and not
another field within the simple mailbox defines.

Found by code inspection, there are no known firmware configurations
where this would cause issues.

Fixes: 527d7d1b9949 ("nfp: read mailbox address from TLV caps")
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 44d3ea75d043a..ab602a79b084d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -423,7 +423,7 @@
 #define NFP_NET_CFG_MBOX_SIMPLE_CMD	0x0
 #define NFP_NET_CFG_MBOX_SIMPLE_RET	0x4
 #define NFP_NET_CFG_MBOX_SIMPLE_VAL	0x8
-#define NFP_NET_CFG_MBOX_SIMPLE_LEN	0x12
+#define NFP_NET_CFG_MBOX_SIMPLE_LEN	12
 
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_ADD 1
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_KILL 2
-- 
2.20.1



