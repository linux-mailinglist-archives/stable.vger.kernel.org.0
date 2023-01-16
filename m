Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC5366C57D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjAPQGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjAPQGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED6B23D92
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED2B3B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52588C433EF;
        Mon, 16 Jan 2023 16:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885073;
        bh=3xteQ9jQKhn+tRgWq/xoHRCBtd/+9YToqzMGlIwpfdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XybnsorPOqsbq16oZ9lprjlQ9annWuELYuC6U2S6kIgQTgOp8fiovcaURn/lZ9pdM
         9QdKiA0QY8IoDCpVjPI/093VpAZNRBGUfhwJ8A9HZHGHDjZWDtzxrDwoDCt5oc3Q/s
         xUkQ+JADhHzmA0GL4xH5l+JQCgYx/t2xZehNo3c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiang Yu <quic_qianyu@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/86] bus: mhi: host: Fix race between channel preparation and M0 event
Date:   Mon, 16 Jan 2023 16:51:09 +0100
Message-Id: <20230116154748.547464918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Qiang Yu <quic_qianyu@quicinc.com>

[ Upstream commit 869a99907faea6d1835b0bd0d0422ae3519c6ea9 ]

There is a race condition where mhi_prepare_channel() updates the
read and write pointers as the base address and in parallel, if
an M0 transition occurs, the tasklet goes ahead and rings
doorbells for all channels with a delta in TRE rings assuming
they are already enabled. This causes a null pointer access. Fix
it by adding a channel enabled check before ringing channel
doorbells.

Cc: stable@vger.kernel.org # 5.19
Fixes: a6e2e3522f29 "bus: mhi: core: Add support for PM state transitions"
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/1665889532-13634-1-git-send-email-quic_qianyu@quicinc.com
[mani: CCed stable list]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/pm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 1020268a075a..1a87b9c6c2f8 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -297,7 +297,8 @@ int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl)
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}
-- 
2.35.1



