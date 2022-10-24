Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462AF60AB74
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbiJXNwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiJXNvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:51:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD05BB06C;
        Mon, 24 Oct 2022 05:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9AE261299;
        Mon, 24 Oct 2022 12:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE641C433C1;
        Mon, 24 Oct 2022 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615340;
        bh=tiyhuEZPjajtP+igwZqaXeDfD751I7gCLOYpcZMLJFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bphs1z4X3RiT8KMTG03JJ4czz3JPZticoDc80fCJw2KIIrjEJXKdLJK8kZznuu7nj
         +Iz6UYYXfQN21fVAWBKTi+4lKQ5yZO3ExGlIwrGNaump6qu/PYZzEanHlf7MreaXiA
         hmeBedB289fRAP7a1HZJAkkhpVo8z03bNCOUU/58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Zbynek Michl <zbynek.michl@gmail.com>
Subject: [PATCH 5.15 196/530] eth: alx: take rtnl_lock on resume
Date:   Mon, 24 Oct 2022 13:29:00 +0200
Message-Id: <20221024113053.918097596@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6ad1c94e1e7e374d88f0cfd77936dddb8339aaba ]

Zbynek reports that alx trips an rtnl assertion on resume:

 RTNL: assertion failed at net/core/dev.c (2891)
 RIP: 0010:netif_set_real_num_tx_queues+0x1ac/0x1c0
 Call Trace:
  <TASK>
  __alx_open+0x230/0x570 [alx]
  alx_resume+0x54/0x80 [alx]
  ? pci_legacy_resume+0x80/0x80
  dpm_run_callback+0x4a/0x150
  device_resume+0x8b/0x190
  async_resume+0x19/0x30
  async_run_entry_fn+0x30/0x130
  process_one_work+0x1e5/0x3b0

indeed the driver does not hold rtnl_lock during its internal close
and re-open functions during suspend/resume. Note that this is not
a huge bug as the driver implements its own locking, and does not
implement changing the number of queues, but we need to silence
the splat.

Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
Reported-and-tested-by: Zbynek Michl <zbynek.michl@gmail.com>
Reviewed-by: Niels Dossche <dossche.niels@gmail.com>
Link: https://lore.kernel.org/r/20220928181236.1053043-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 98a8698a3201..2ac5253ff89a 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1912,11 +1912,14 @@ static int alx_suspend(struct device *dev)
 
 	if (!netif_running(alx->dev))
 		return 0;
+
+	rtnl_lock();
 	netif_device_detach(alx->dev);
 
 	mutex_lock(&alx->mtx);
 	__alx_stop(alx);
 	mutex_unlock(&alx->mtx);
+	rtnl_unlock();
 
 	return 0;
 }
@@ -1927,6 +1930,7 @@ static int alx_resume(struct device *dev)
 	struct alx_hw *hw = &alx->hw;
 	int err;
 
+	rtnl_lock();
 	mutex_lock(&alx->mtx);
 	alx_reset_phy(hw);
 
@@ -1943,6 +1947,7 @@ static int alx_resume(struct device *dev)
 
 unlock:
 	mutex_unlock(&alx->mtx);
+	rtnl_unlock();
 	return err;
 }
 
-- 
2.35.1



