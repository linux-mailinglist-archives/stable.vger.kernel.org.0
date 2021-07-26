Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E43D5E5C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbhGZPHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236262AbhGZPGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF3F60F6B;
        Mon, 26 Jul 2021 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314424;
        bh=8NuPKRkybmUYXeVgMaIoBn/BUL1fl3Z2lejk3KOUK9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gmtt1XPskMoArqAsElF8v2IXzPhcW90D/OTHjHAcinAusv8MnspTLZPYUnhRq53iT
         UYe5OWMF2HKPEK38431JszMYG91K3kY2vpp6FXEAQqj9g7yvGHGYXRpwMN4ikZK7kw
         E68hCr8WsmBDfTpc+u0BZOyuryW71bgzAGbn3uKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.placzewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/82] igb: Check if num of q_vectors is smaller than max before array access
Date:   Mon, 26 Jul 2021 17:38:41 +0200
Message-Id: <20210726153829.504040181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit 6c19d772618fea40d9681f259368f284a330fd90 ]

Ensure that the adapter->q_vector[MAX_Q_VECTORS] array isn't accessed
beyond its size. It was fixed by using a local variable num_q_vectors
as a limit for loop index, and ensure that num_q_vectors is not bigger
than MAX_Q_VECTORS.

Fixes: 047e0030f1e6 ("igb: add new data structure for handling interrupts and NAPI")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Slawomir Laba <slawomirx.laba@intel.com>
Reviewed-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Reviewed-by: Mateusz Palczewski <mateusz.placzewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c4898bb9896f..6bd30d51dafc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -949,6 +949,7 @@ static void igb_configure_msix(struct igb_adapter *adapter)
  **/
 static int igb_request_msix(struct igb_adapter *adapter)
 {
+	unsigned int num_q_vectors = adapter->num_q_vectors;
 	struct net_device *netdev = adapter->netdev;
 	int i, err = 0, vector = 0, free_vector = 0;
 
@@ -957,7 +958,13 @@ static int igb_request_msix(struct igb_adapter *adapter)
 	if (err)
 		goto err_out;
 
-	for (i = 0; i < adapter->num_q_vectors; i++) {
+	if (num_q_vectors > MAX_Q_VECTORS) {
+		num_q_vectors = MAX_Q_VECTORS;
+		dev_warn(&adapter->pdev->dev,
+			 "The number of queue vectors (%d) is higher than max allowed (%d)\n",
+			 adapter->num_q_vectors, MAX_Q_VECTORS);
+	}
+	for (i = 0; i < num_q_vectors; i++) {
 		struct igb_q_vector *q_vector = adapter->q_vector[i];
 
 		vector++;
-- 
2.30.2



