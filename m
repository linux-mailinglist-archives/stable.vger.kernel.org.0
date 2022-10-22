Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE85A608850
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiJVIQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiJVIPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:15:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2982DA752;
        Sat, 22 Oct 2022 00:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6E78B82E1A;
        Sat, 22 Oct 2022 07:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B076C433C1;
        Sat, 22 Oct 2022 07:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424790;
        bh=RZ6NS0SnC3gnbfETbcJ/j5wvx8/vJ3dE1h7eQRYb3WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sPKgkrZ3TZJnjUDyz8hPAOCGn4bnMoaDxXcCx+2SQWVj9/jeKYMe/CGuKkLVM1Yg
         hdsen7OyeGJFLhjmicQ0wmnSr/wZvCKB2j4m37CcHdV6zjRwquSIqzZu4ZldUqI7KG
         C5SPFhJaQ9BshLVj+qFS1WBrGPauJn7z+m2wIy/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Zbynek Michl <zbynek.michl@gmail.com>
Subject: [PATCH 5.19 278/717] eth: alx: take rtnl_lock on resume
Date:   Sat, 22 Oct 2022 09:22:37 +0200
Message-Id: <20221022072503.183456425@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a89b93cb4e26..d5939586c82e 100644
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



