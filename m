Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5812565D8E7
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbjADQTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbjADQT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:19:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9AB5FBB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:19:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 045F6CE184A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF44AC433D2;
        Wed,  4 Jan 2023 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849165;
        bh=O6wiKCupFA3cYumLXNEDZszkyucDIx/CQRmtWJWex/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crrMs5I1e8E1Vk2wpV/erOGdppIOaC8s1WIytME37u3kY5uRXO2IbroHvr3TGCh27
         pUYGzTE8If86LrFqLJ7zDKgxtcOe+PnD3zpFCYCTWmrNRJXtEYYqGska/udATvwolR
         eAk9Y3Ubhp6gKZ1OZvzEf4UJtsRWyCvNlD3WELsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiang Yu <quic_qianyu@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 136/207] bus: mhi: host: Fix race between channel preparation and M0 event
Date:   Wed,  4 Jan 2023 17:06:34 +0100
Message-Id: <20230104160516.223569967@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 869a99907faea6d1835b0bd0d0422ae3519c6ea9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -301,7 +301,8 @@ int mhi_pm_m0_transition(struct mhi_cont
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}


