Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7C6C17F2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbjCTPS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjCTPS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1320A31E17
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2FB361575
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9C4C433EF;
        Mon, 20 Mar 2023 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325180;
        bh=sFh+slsaerm0TBFtv1wg/yGEi4mxAKvEZDoV0mTpmvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCE8MNMzOCEA+YGW4NZtrBOWEDwOtQYf+YEV+MJ3frDUwvDMxayUgCEqIPjGeeryw
         QDIG0Y5J+BWNrkL+E5IhhAyilMeUO+Tqu6YFanaCOGSezNuIOk3AfnbzFDW59bWQDq
         wiUitCoD8LuPdT/dg1mvG6bEq49OzR4fZuyWcJ4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Adrian Bonislawski <adrian.bonislawski@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 014/211] ASoC: SOF: ipc4-topology: set dmic dai index from copier
Date:   Mon, 20 Mar 2023 15:52:29 +0100
Message-Id: <20230320145513.890915524@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@linux.intel.com>

[ Upstream commit c99e48f4ce9b986ab7992ec7283a06dae875f668 ]

Dmic dai index was set incorrectly to bits 5-7, when it is actually using
just the lowest 3. Fix the macro for setting the bits.

Fixes: aa84ffb72158 ("ASoC: SOF: ipc4-topology: Add support for SSP/DMIC DAI's")
Signed-off-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
Reviewed-by: Adrian Bonislawski <adrian.bonislawski@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307110730.1995-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index 0aa87a8add5d3..2363a7cc0b57d 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -46,7 +46,7 @@
 #define SOF_IPC4_NODE_INDEX_INTEL_SSP(x) (((x) & 0xf) << 4)
 
 /* Node ID for DMIC type DAI copiers */
-#define SOF_IPC4_NODE_INDEX_INTEL_DMIC(x) (((x) & 0x7) << 5)
+#define SOF_IPC4_NODE_INDEX_INTEL_DMIC(x) ((x) & 0x7)
 
 #define SOF_IPC4_GAIN_ALL_CHANNELS_MASK 0xffffffff
 #define SOF_IPC4_VOL_ZERO_DB	0x7fffffff
-- 
2.39.2



