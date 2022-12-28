Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E710657E32
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiL1PvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiL1PvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DE7186BC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B0CB81732
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D2C433D2;
        Wed, 28 Dec 2022 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242665;
        bh=IppDHdVxIkZDMbJLSMcl/cUWkF/7izl0yYhhB9kxKHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbbKZy3k3WVmpbXtl2yPwLz43iBf+iqXCovOqUOvzTYJMnu95AHLNHQVLZ++gDY1W
         UnOoORQRNYK/khv88HLXF7qNgr6bpWEYcfRcSSNwCH+esJN5Gk8M3ySQ8dD51ovs8k
         PfGbBKczKgci5rpKf3gtPhCnqrNA1enYSgTd3p9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ian Lin <ian.lin@infineon.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 631/731] brcmfmac: return error when getting invalid max_flowrings from dongle
Date:   Wed, 28 Dec 2022 15:42:18 +0100
Message-Id: <20221228144314.816099620@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit 2aca4f3734bd717e04943ddf340d49ab62299a00 ]

When firmware hit trap at initialization, host will read abnormal
max_flowrings number from dongle, and it will cause kernel panic when
doing iowrite to initialize dongle ring.
To detect this error at early stage, we directly return error when getting
invalid max_flowrings(>256).

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ian Lin <ian.lin@infineon.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220929031001.9962-3-ian.lin@infineon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 358021a33b8a..f5f5a002fdcf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1118,6 +1118,10 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
+	if (max_flowrings > 256) {
+		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
+		return -EIO;
+	}
 
 	if (devinfo->dma_idx_sz != 0) {
 		bufsz = (max_submissionrings + max_completionrings) *
-- 
2.35.1



