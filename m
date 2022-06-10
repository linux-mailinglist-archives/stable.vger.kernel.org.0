Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A6354678A
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiFJNqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 09:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiFJNqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 09:46:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE7E22B35
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 06:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BEF3B83501
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 13:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08243C3411D;
        Fri, 10 Jun 2022 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654868768;
        bh=M0G8HKoN3LPQQXb6OJkpWvlzgLX8cfctA126X+cZIug=;
        h=Subject:To:From:Date:From;
        b=hQTaBKQsWLQOZU5HYSNN7hA4LByD3kj6P1DlL+kWhlNsYPleIUJ/JxaFWi4YfDZgg
         fsAjOEWD1dZjS7mqBDGIcZHcsq03PClSGr+yslgY5E7FWCzSTG44H13nugg3/H0z5p
         PVFAmJoen99TM7P2SjTNSMbw0ujwkb0yZJEH92EQ=
Subject: patch "mei: hbm: drop capability response on early shutdown" added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jun 2022 15:45:55 +0200
Message-ID: <1654868755212244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: hbm: drop capability response on early shutdown

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 68553650bc9c57c7e530c84e5b2945e9dfe1a560 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Mon, 6 Jun 2022 17:42:24 +0300
Subject: mei: hbm: drop capability response on early shutdown

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
 drivers/misc/mei/hbm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index cebcca6d6d3e..cf2b8261da14 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1351,7 +1351,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CAP_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: capabilities response: on shutdown, ignoring\n");
 				return 0;
 			}
-- 
2.36.1


