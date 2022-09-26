Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC7F5EA31A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiIZLTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237806AbiIZLTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC745280C;
        Mon, 26 Sep 2022 03:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D861C604F5;
        Mon, 26 Sep 2022 10:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7263C433D7;
        Mon, 26 Sep 2022 10:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188630;
        bh=WV/zMXn4qK+3/dXRfNeM1DEaI727czjNjicKeB4wghc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQPHYdan9UL/LHH2graEHJk15vlU/19n62MwcxrZUHAMMAmNqWJYDUjQtYINzrVSs
         W6bvvGpIRQGvFSFJNoD72BlUqvc44KTpdN49BXBOlZLHEPsNNYe7YLxa02dTbfcEZh
         sdKmGlnnIYv2wrukfg7IA97SJZZ6qgf2sMPvHy+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/148] iavf: Fix cached head and tail value for iavf_get_tx_pending
Date:   Mon, 26 Sep 2022 12:11:44 +0200
Message-Id: <20220926100758.661648298@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 809f23c0423a43266e47a7dc67e95b5cb4d1cbfc ]

The underlying hardware may or may not allow reading of the head or tail
registers and it really makes no difference if we use the software
cached values. So, always used the software cached values.

Fixes: 9c6c12595b73 ("i40e: Detection and recovery of TX queue hung logic moved to service_task from tx_timeout")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Co-developed-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 5448ed0e0357..a99d5db15406 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -114,8 +114,11 @@ u32 iavf_get_tx_pending(struct iavf_ring *ring, bool in_sw)
 {
 	u32 head, tail;
 
+	/* underlying hardware might not allow access and/or always return
+	 * 0 for the head/tail registers so just use the cached values
+	 */
 	head = ring->next_to_clean;
-	tail = readl(ring->tail);
+	tail = ring->next_to_use;
 
 	if (head != tail)
 		return (head < tail) ?
-- 
2.35.1



