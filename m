Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A4B5519C1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243903AbiFTNB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243243AbiFTNAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:00:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818531A397;
        Mon, 20 Jun 2022 05:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C8EE614DA;
        Mon, 20 Jun 2022 12:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0625C3411B;
        Mon, 20 Jun 2022 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729820;
        bh=J4GKVgzV5EMFVfT389DAZgVtD9P7mBr/j5cWGA2DIWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQNGhBQazVnt3UWgH+jKvClSlMC02Oz/zA5qb3KG3UYbrLXZER3LUzhLeydrc02/G
         P86wU+7TbRbnbkyXk8wnUKyMZZ3jQkc/+boD601QoeMnpAXp/tfVn2MOZOZmZm7GM7
         2QvQ1PQz6G+297/FSY8TLNM9BTzAs6sTw8fe4WR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.18 076/141] ice: Fix PTP TX timestamp offset calculation
Date:   Mon, 20 Jun 2022 14:50:14 +0200
Message-Id: <20220620124731.783806252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Michalik <michal.michalik@intel.com>

[ Upstream commit 71a579f0d3777a704355e6f1572dfba92a9b58b2 ]

The offset was being incorrectly calculated for E822 - that led to
collisions in choosing TX timestamp register location when more than
one port was trying to use timestamping mechanism.

In E822 one quad is being logically split between ports, so quad 0 is
having trackers for ports 0-3, quad 1 ports 4-7 etc. Each port should
have separate memory location for tracking timestamps. Due to error for
example ports 1 and 2 had been assigned to quad 0 with same offset (0),
while port 1 should have offset 0 and 1 offset 16.

Fix it by correctly calculating quad offset.

Fixes: 3a7496234d17 ("ice: implement basic E822 PTP support")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h | 31 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 662947c882e8..ef9344ef0d8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2271,7 +2271,7 @@ static int
 ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 {
 	tx->quad = port / ICE_PORTS_PER_QUAD;
-	tx->quad_offset = tx->quad * INDEX_PER_PORT;
+	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
 	tx->len = INDEX_PER_PORT;
 
 	return ice_ptp_alloc_tx_tracker(tx);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index afd048d69959..10e396abf130 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -49,6 +49,37 @@ struct ice_perout_channel {
  * To allow multiple ports to access the shared register block independently,
  * the blocks are split up so that indexes are assigned to each port based on
  * hardware logical port number.
+ *
+ * The timestamp blocks are handled differently for E810- and E822-based
+ * devices. In E810 devices, each port has its own block of timestamps, while in
+ * E822 there is a need to logically break the block of registers into smaller
+ * chunks based on the port number to avoid collisions.
+ *
+ * Example for port 5 in E810:
+ *  +--------+--------+--------+--------+--------+--------+--------+--------+
+ *  |register|register|register|register|register|register|register|register|
+ *  | block  | block  | block  | block  | block  | block  | block  | block  |
+ *  |  for   |  for   |  for   |  for   |  for   |  for   |  for   |  for   |
+ *  | port 0 | port 1 | port 2 | port 3 | port 4 | port 5 | port 6 | port 7 |
+ *  +--------+--------+--------+--------+--------+--------+--------+--------+
+ *                                               ^^
+ *                                               ||
+ *                                               |---  quad offset is always 0
+ *                                               ---- quad number
+ *
+ * Example for port 5 in E822:
+ * +-----------------------------+-----------------------------+
+ * |  register block for quad 0  |  register block for quad 1  |
+ * |+------+------+------+------+|+------+------+------+------+|
+ * ||port 0|port 1|port 2|port 3|||port 0|port 1|port 2|port 3||
+ * |+------+------+------+------+|+------+------+------+------+|
+ * +-----------------------------+-------^---------------------+
+ *                                ^      |
+ *                                |      --- quad offset*
+ *                                ---- quad number
+ *
+ *   * PHY port 5 is port 1 in quad 1
+ *
  */
 
 /**
-- 
2.35.1



