Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74DD586943
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiHAL7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiHAL7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:59:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B854C4AD53;
        Mon,  1 Aug 2022 04:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FA77B8116E;
        Mon,  1 Aug 2022 11:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3559C433D6;
        Mon,  1 Aug 2022 11:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354749;
        bh=9BE/nUQGWleDQxVfUqpKfHzWVdmMwFM+lL9qBXcXGjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1y8PJrT/k1KWsEsC+FyAVg62P6Xfi0ztoiUrVDdbSFomsPfCczCwcDto5McTlIISX
         HeAJX2AsVUwbDau8afqv6NcTpug/eEt89Xb2bypSVvkKG1UwF9Hae38GJ0KXCisKa7
         EvHSTKs/Gnhtbn00iSTZQ5Fym8SiT50jrkmxv51E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/65] i40e: Fix interface init with MSI interrupts (no MSI-X)
Date:   Mon,  1 Aug 2022 13:46:57 +0200
Message-Id: <20220801114135.394817890@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Maloszewski <michal.maloszewski@intel.com>

[ Upstream commit 5fcbb711024aac6d4db385623e6f2fdf019f7782 ]

Fix the inability to bring an interface up on a setup with
only MSI interrupts enabled (no MSI-X).
Solution is to add a default number of QPs = 1. This is enough,
since without MSI-X support driver enables only a basic feature set.

Fixes: bc6d33c8d93f ("i40e: Fix the number of queues available to be mapped for use")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20220722175401.112572-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 11d4e3ba9af4..1dad62ecb8a3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1907,11 +1907,15 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 		 * non-zero req_queue_pairs says that user requested a new
 		 * queue count via ethtool's set_channels, so use this
 		 * value for queues distribution across traffic classes
+		 * We need at least one queue pair for the interface
+		 * to be usable as we see in else statement.
 		 */
 		if (vsi->req_queue_pairs > 0)
 			vsi->num_queue_pairs = vsi->req_queue_pairs;
 		else if (pf->flags & I40E_FLAG_MSIX_ENABLED)
 			vsi->num_queue_pairs = pf->num_lan_msix;
+		else
+			vsi->num_queue_pairs = 1;
 	}
 
 	/* Number of queues per enabled TC */
-- 
2.35.1



