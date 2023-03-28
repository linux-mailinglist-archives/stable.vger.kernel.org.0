Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46576CC3D9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjC1O5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbjC1O5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5791EE1AD
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E57516182A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06945C4339B;
        Tue, 28 Mar 2023 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015472;
        bh=XsZhYHmXJmA4h41p/H8hecSOUZXRODcED0Dj5+fXnsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZV2e/h14u2Y61oNNSOm3cHigC/xEL238HGNc4yL0gJrzUMFi01vkcNTLELVXbMDsk
         3zKr/qPKIKHX4ve8IQTpwA3nnwkwDavH6InNWlTQCCkObmQoNJ8570DqYzQd00+NcU
         DgR++yacANns59XyjUI9qcAWOo6a0wLyunQuhBVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 6.1 062/224] i40e: fix flow director packet filter programming
Date:   Tue, 28 Mar 2023 16:40:58 +0200
Message-Id: <20230328142619.929071230@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit c672297bbc0e86dbf88396b8053e2fbb173f16ff ]

Initialize to zero structures to build a valid
Tx Packet used for the filter programming.

Fixes: a9219b332f52 ("i40e: VLAN field for flow director")
Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b97c95f89fa02..494775d65bf28 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -171,10 +171,10 @@ static char *i40e_create_dummy_packet(u8 *dummy_packet, bool ipv4, u8 l4proto,
 				      struct i40e_fdir_filter *data)
 {
 	bool is_vlan = !!data->vlan_tag;
-	struct vlan_hdr vlan;
-	struct ipv6hdr ipv6;
-	struct ethhdr eth;
-	struct iphdr ip;
+	struct vlan_hdr vlan = {};
+	struct ipv6hdr ipv6 = {};
+	struct ethhdr eth = {};
+	struct iphdr ip = {};
 	u8 *tmp;
 
 	if (ipv4) {
-- 
2.39.2



