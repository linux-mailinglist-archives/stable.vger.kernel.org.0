Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786BD65D951
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbjADQXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbjADQXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:23:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B5A33D63
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFDA5CE184D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FD3C433D2;
        Wed,  4 Jan 2023 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849383;
        bh=eTkKD0QLneq/gTEjl7sEcWX6q3OTaP227nVwiEgcnBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4S+n5qZM/EW6B0tlUcznmbf9aDfO9e6iWi+CLoGO7JtiabMX9mLwvFdFd0LCenK+
         +Er4zN+0wyYcTbL4yfzGT8KmNSJMEhHHu27NyA9737ipRssiRbsP1C0HiNtTGngPjs
         WNH1iFFz5srJnNZYSRQxVdSE56l2Di5bNIaQYq4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiang Yu <quic_qianyu@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.0 112/177] bus: mhi: host: Fix race between channel preparation and M0 event
Date:   Wed,  4 Jan 2023 17:06:43 +0100
Message-Id: <20230104160511.037198241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
 drivers/bus/mhi/host/pm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/pm.c b/drivers/bus/mhi/host/pm.c
index 4a42186ff111..083459028a4b 100644
--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -301,7 +301,8 @@ int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl)
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}
-- 
2.39.0



