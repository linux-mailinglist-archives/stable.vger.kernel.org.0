Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560C74A96BF
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358161AbiBDJ3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358183AbiBDJ1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A699C0613A0;
        Fri,  4 Feb 2022 01:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65186B817E5;
        Fri,  4 Feb 2022 09:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00BAC004E1;
        Fri,  4 Feb 2022 09:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966791;
        bh=YMYuQnPuONb4tfoxDPPHXVTTN65rWcYcJS4YmBhYkt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1OuLAwm00uXOyXnN4A9WjBh4BwwH/WSGsrejhTYMrNL/X22fpP0ytsLCzLPXu3nw
         VCyPk50GTT6QvHiMJkTCX57cTbETefyCvUEDNHvDJNsCGkBWFLXVrSMys4urVm5pPQ
         byOV7LT3rrbPZ4EsU2pRFF46Sqn4WQhM+JKkRKlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.16 40/43] e1000e: Handshake with CSME starts from ADL platforms
Date:   Fri,  4 Feb 2022 10:22:47 +0100
Message-Id: <20220204091918.466644099@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit cad014b7b5a6897d8c4fad13e2888978bfb7a53f upstream.

Handshake with CSME/AMT on none provisioned platforms during S0ix flow
is not supported on TGL platform and can cause to HW unit hang. Update
the handshake with CSME flow to start from the ADL platform.

Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6345,7 +6345,8 @@ static void e1000e_s0ix_entry_flow(struc
 	u32 mac_data;
 	u16 phy_data;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME configure the device for S0ix */
 		mac_data = er32(H2ME);
 		mac_data |= E1000_H2ME_START_DPG;
@@ -6494,7 +6495,8 @@ static void e1000e_s0ix_exit_flow(struct
 	u16 phy_data;
 	u32 i = 0;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME unconfigure the device from S0ix */
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;


