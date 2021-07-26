Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E64D3D6141
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGZPa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhGZP2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E4161007;
        Mon, 26 Jul 2021 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315643;
        bh=64AN+Am0fWBby4FWNBulHpCbKILhRIOtYNtEezU8g+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXDeD151ORxa74gM2JkkWYi4zc3QnofY6729mKgEX//9uUZDZeZpFe/dK6ndcS3Ag
         WD7fAuJMYXpqxdizKYe+qh3jy80XPfYhzp70V03v3dGssbZfjKl6FdfXlmf0PpMfI+
         92hst2dfJlTpueIU+toV+6zAptuODvvQz5todQ3E=
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
Subject: [PATCH 5.13 010/223] igb: Check if num of q_vectors is smaller than max before array access
Date:   Mon, 26 Jul 2021 17:36:42 +0200
Message-Id: <20210726153846.594482866@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index a371c51a3fe8..9f83ff55394c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -931,6 +931,7 @@ static void igb_configure_msix(struct igb_adapter *adapter)
  **/
 static int igb_request_msix(struct igb_adapter *adapter)
 {
+	unsigned int num_q_vectors = adapter->num_q_vectors;
 	struct net_device *netdev = adapter->netdev;
 	int i, err = 0, vector = 0, free_vector = 0;
 
@@ -939,7 +940,13 @@ static int igb_request_msix(struct igb_adapter *adapter)
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



