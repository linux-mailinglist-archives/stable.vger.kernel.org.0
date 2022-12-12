Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F23649FE1
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiLLNQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiLLNQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:16:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC8013CEE
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E6561041
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81610C433F0;
        Mon, 12 Dec 2022 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850949;
        bh=nES3pJaba156cD/1XBMiLGJBbNuOBkRwz36AzmWijBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnufqDsJ1U9lPooX5Di7CJXnQ1wj/zgMzjYgDsNynSohPqImEHepnoFrQlNXUWro4
         w+IJwjtVP5M83uAKb+ehhW+J6DVMygYpjpKRTDozlc2CdzvPw8YFWD9BhsaG7q29SG
         9TgqdwKCXaIhSJMqBdzfvAKbUhIQn4DeVqXTpXfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akihiko Odaki <akihiko.odaki@daynix.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 5.10 071/106] igb: Allocate MSI-X vector when testing
Date:   Mon, 12 Dec 2022 14:10:14 +0100
Message-Id: <20221212130927.981006477@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akihiko Odaki <akihiko.odaki@daynix.com>

[ Upstream commit 28e96556baca7056d11d9fb3cdd0aba4483e00d8 ]

Without this change, the interrupt test fail with MSI-X environment:

$ sudo ethtool -t enp0s2 offline
[   43.921783] igb 0000:00:02.0: offline testing starting
[   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
[   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   51.272202] igb 0000:00:02.0: testing shared interrupt
[   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
The test result is FAIL
The test extra info:
Register test  (offline)	 0
Eeprom test    (offline)	 0
Interrupt test (offline)	 4
Loopback test  (offline)	 0
Link test   (on/offline)	 0

Here, "4" means an expected interrupt was not delivered.

To fix this, route IRQs correctly to the first MSI-X vector by setting
IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
masked. The interrupt test now runs properly with this change:

$ sudo ethtool -t enp0s2 offline
[   42.762985] igb 0000:00:02.0: offline testing starting
[   50.141967] igb 0000:00:02.0: testing shared interrupt
[   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
The test result is PASS
The test extra info:
Register test  (offline)	 0
Eeprom test    (offline)	 0
Interrupt test (offline)	 0
Loopback test  (offline)	 0
Link test   (on/offline)	 0

Fixes: 4eefa8f01314 ("igb: add single vector msi-x testing to interrupt test")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 28baf203459a..5e3b0a5843a8 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
 			*data = 1;
 			return -1;
 		}
+		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
+		wr32(E1000_EIMS, BIT(0));
 	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
 		shared_int = false;
 		if (request_irq(irq,
-- 
2.35.1



