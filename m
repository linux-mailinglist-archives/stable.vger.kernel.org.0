Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1A25A4B5B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiH2MQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiH2MQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:16:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AE3DEAE;
        Mon, 29 Aug 2022 04:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54533B80EF3;
        Mon, 29 Aug 2022 11:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38B3C433D7;
        Mon, 29 Aug 2022 11:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771753;
        bh=BILumsM7qmpk/hwvCIZjFEGcHsYLV3LR5ngpNbL/JVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Owzfv/5Owvu8QWMUem69ijFbnmDnitN6Ttm+1I0IbfrNkJm34Ro/6hWpAivFVt6vU
         OAM8kMlPfMGyQZ0/BK7XkqKOrUaFI50A53Cv1zukhcekrRniYBys22casky3ppkcvu
         N4/m/X4UcqRT0KRxQ4cRVk6Vd2sR/WfWpXK19fSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 087/158] ionic: clear broken state on generation change
Date:   Mon, 29 Aug 2022 12:58:57 +0200
Message-Id: <20220829105812.704403576@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 9cb9dadb8f45c67e4310e002c2f221b70312b293 ]

There is a case found in heavy testing where a link flap happens just
before a firmware Recovery event and the driver gets stuck in the
BROKEN state.  This comes from the driver getting interrupted by a FW
generation change when coming back up from the link flap, and the call
to ionic_start_queues() in ionic_link_status_check() fails.  This can be
addressed by having the fw_up code clear the BROKEN bit if seen, rather
than waiting for a user to manually force the interface down and then
back up.

Fixes: 9e8eaf8427b6 ("ionic: stop watchdog when in broken state")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1443f788ee37c..d4226999547e8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2963,6 +2963,9 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 
 	mutex_lock(&lif->queue_lock);
 
+	if (test_and_clear_bit(IONIC_LIF_F_BROKEN, lif->state))
+		dev_info(ionic->dev, "FW Up: clearing broken state\n");
+
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_unlock;
-- 
2.35.1



