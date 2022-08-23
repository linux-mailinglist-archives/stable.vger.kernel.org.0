Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C191B59D8CD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiHWJvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351651AbiHWJut (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:50:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E10C9DFBC;
        Tue, 23 Aug 2022 01:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6D1B81C6A;
        Tue, 23 Aug 2022 08:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08B2C433C1;
        Tue, 23 Aug 2022 08:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244317;
        bh=v72sCb1UKg/hUfqN4kpl6JgOnAKHwuo/rcMINgfYefU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbH0oSPTbP7YkJUzn7jxkl/BhgJ8jyGGiyQXctU3OpnKtw+tGuupc07aT7OqYcCtq
         1xYQd/gk3u+y7pwuXB82lmyeHLoXGd1qZ05qBdFlOGNz5MV7A5m9wt34hRAHVj+ZWT
         fMlZ2qe8wYcKLqGjnVF3YnCvAt/q7Gj1RgBaSNsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harman Kalra <hkalra@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 072/244] octeontx2-af: suppress external profile loading warning
Date:   Tue, 23 Aug 2022 10:23:51 +0200
Message-Id: <20220823080101.466987922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Harman Kalra <hkalra@marvell.com>

commit cf2437626502b5271d19686b03dea306efe17ea0 upstream.

The packet parser profile supplied as firmware may not
be present all the time and default profile is used mostly.
Hence suppress firmware loading warning from kernel due to
absence of firmware in kernel image.

Fixes: 3a7244152f9c ("octeontx2-af: add support for custom KPU entries")
Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1650,7 +1650,7 @@ static void npc_load_kpu_profile(struct
 	 * Firmware database method.
 	 * Default KPU profile.
 	 */
-	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+	if (!request_firmware_direct(&fw, kpu_profile, rvu->dev)) {
 		dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
 			 kpu_profile);
 		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);


