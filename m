Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C239F7E53
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfKKSqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbfKKSqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671BA21655;
        Mon, 11 Nov 2019 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497992;
        bh=1G2RTe8bkhAi0JvZ0DOc/Hnu08pCUoVbpcdYhiBBMiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2DN74Wt9gaO1GpKOjRo4xcwjR6ZxOsoma5hsmD7XT2sdlwtcsJXw/AaFOXXgilQK
         OHp4Z1hpeCTj3uWVw6vxrq4bsa3BYEBScx0hHSMEBDul4IWaj9jaAqzmWQth84e1VN
         i73008GEGD59Kq3ZtrfJ8BWi8xEO9qClV5zZrpp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manfred Rudigier <manfred.rudigier@omicronenergy.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/125] igb: Fix constant media auto sense switching when no cable is connected
Date:   Mon, 11 Nov 2019 19:29:15 +0100
Message-Id: <20191111181455.335395928@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manfred Rudigier <manfred.rudigier@omicronenergy.com>

[ Upstream commit 8d5cfd7f76a2414e23c74bb8858af7540365d985 ]

At least on the i350 there is an annoying behavior that is maybe also
present on 82580 devices, but was probably not noticed yet as MAS is not
widely used.

If no cable is connected on both fiber/copper ports the media auto sense
code will constantly swap between them as part of the watchdog task and
produce many unnecessary kernel log messages.

The swap code responsible for this behavior (switching to fiber) should
not be executed if the current media type is copper and there is no signal
detected on the fiber port. In this case we can safely wait until the
AUTOSENSE_EN bit is cleared.

Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ab76a5f77cd0e..36db874f3c928 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2064,7 +2064,8 @@ static void igb_check_swap_media(struct igb_adapter *adapter)
 	if ((hw->phy.media_type == e1000_media_type_copper) &&
 	    (!(connsw & E1000_CONNSW_AUTOSENSE_EN))) {
 		swap_now = true;
-	} else if (!(connsw & E1000_CONNSW_SERDESD)) {
+	} else if ((hw->phy.media_type != e1000_media_type_copper) &&
+		   !(connsw & E1000_CONNSW_SERDESD)) {
 		/* copper signal takes time to appear */
 		if (adapter->copper_tries < 4) {
 			adapter->copper_tries++;
-- 
2.20.1



