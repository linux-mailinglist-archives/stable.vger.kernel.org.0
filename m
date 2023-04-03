Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB576D4A9F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbjDCOtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbjDCOsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:48:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E379529BC1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0933F61F52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6C2C433D2;
        Mon,  3 Apr 2023 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533250;
        bh=hC3hSOEkwIzy9efsheKlHFY4fiD1g1yw28jKqQZmX6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L321YBU75igKsUPo/x8G/FMWnOfheunQJLQgRwEMZ7g0j4jy1TqgeECEm57CFn+oR
         9awNUI2s38VMjdPyZ3HnJCHSSaD+NssKcVLoWyLUofDeM16Z0iClnRya+PGAq/tH3d
         sUXD0UOG32YJ2JBFyV/kwAN+s/us2EDIC0MRiYWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Shane Parslow <shaneparslow808@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, Martin <mwolf@adiumentum.com>
Subject: [PATCH 6.2 111/187] net: wwan: iosm: fixes 7560 modem crash
Date:   Mon,  3 Apr 2023 16:09:16 +0200
Message-Id: <20230403140419.630259679@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 5f70bcbca469a087b54ad2d934185ed69a098576 ]

ModemManger/Apps probing the wwan0xmmrpc0 port for 7560 Modem results in
modem crash.

7560 Modem FW uses the MBIM interface for control command communication
whereas 7360 uses Intel RPC interface so disable wwan0xmmrpc0 port for
7560.

Fixes: d08b0f8f46e4 ("net: wwan: iosm: add rpc interface for xmm modems")
Reported-and-tested-by: Martin <mwolf@adiumentum.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217200
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 1e6a479766429..c066b0040a3fe 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -587,6 +587,13 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
 		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
 			ipc_imem->ipc_port[ctrl_chl_idx] = NULL;
+
+			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7560_ID &&
+			    chnl_cfg_port.wwan_port_type == WWAN_PORT_XMMRPC) {
+				ctrl_chl_idx++;
+				continue;
+			}
+
 			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7360_ID &&
 			    chnl_cfg_port.wwan_port_type == WWAN_PORT_MBIM) {
 				ctrl_chl_idx++;
-- 
2.39.2



