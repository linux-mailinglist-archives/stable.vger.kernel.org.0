Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1654551C85
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344497AbiFTNY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346207AbiFTNY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:24:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDF4237FE;
        Mon, 20 Jun 2022 06:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA35EB811DC;
        Mon, 20 Jun 2022 13:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D56DC3411B;
        Mon, 20 Jun 2022 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730526;
        bh=d+Sd3pkdwyWjKKIEML2KReblaje9FPliZz3Y2tO3UCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooHsu/G9DVjQo4qc53c8TjzmNGTfY9gnGjDHLPHj3ISyINXFK000mIKolONTeaney
         RrbkD4S+CQ1M1sPLBDdCtXtA89IyRdIPj3WFMwk+peTLzFFWKiV/BV9/sqxlihYWQ1
         Oq9Vnadur14fjNpH930L1FecM/IsuNYqXH9QdK3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.15 081/106] mei: hbm: drop capability response on early shutdown
Date:   Mon, 20 Jun 2022 14:51:40 +0200
Message-Id: <20220620124726.790509332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 68553650bc9c57c7e530c84e5b2945e9dfe1a560 upstream.

Drop HBM responses also in the early shutdown phase where
the usual traffic is allowed.
Extend the rule that drop HBM responses received during the shutdown
phase by also in MEI_DEV_POWERING_DOWN state.
This resolves the stall if the driver is stopping in the middle
of the link initialization or link reset.

Drop the capabilities response on early shutdown.

Fixes: 6d7163f2c49f ("mei: hbm: drop hbm responses on early shutdown")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20220606144225.282375-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hbm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1351,7 +1351,8 @@ int mei_hbm_dispatch(struct mei_device *
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CAP_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: capabilities response: on shutdown, ignoring\n");
 				return 0;
 			}


