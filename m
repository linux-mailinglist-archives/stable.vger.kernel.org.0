Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8166E30E
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 17:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjAQQFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 11:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjAQQFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 11:05:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4BA3A861
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 08:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D552B8159F
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 16:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD83C433D2;
        Tue, 17 Jan 2023 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673971540;
        bh=tTng6XZ4k1VNSeYIsxSGza5t1wEZNINy0dJGNTFX2T4=;
        h=Subject:To:From:Date:From;
        b=w5vLQZ5szX/HbcixhtO5IwCGrVSmY7AdU71nynvh3xOZjKCFDhKdsCxdOnViu1r2D
         ZecQVtB2vkqYXJHwLONzauUAYxpkFQ68Dgc1wkZ5meAZbwUn8IxHn0K9SZOHn5V/Di
         m7Yaj3QeEjtjYi8N+5qImcg2QKOc45BuYkf7kCOo=
Subject: patch "usb: chipidea: core: fix possible constant 0 if use" added to usb-linus
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Jan 2023 17:05:37 +0100
Message-ID: <1673971537766@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: core: fix possible constant 0 if use

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f96c0384047257365371a8ac217107c0371586f1 Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Thu, 15 Dec 2022 13:54:09 +0800
Subject: usb: chipidea: core: fix possible constant 0 if use
 IS_ERR(ci->role_switch)

After successfully probed, ci->role_switch would only be NULL or a valid
pointer. IS_ERR(ci->role_switch) will always return 0. So no need to wrap
it with IS_ERR, otherwise the logic is wrong.

Fixes: e1b5d2bed67c ("usb: chipidea: core: handle usb role switch in a common way")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20221215055409.3760523-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 484b1cd23431..27c601296130 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1294,12 +1294,12 @@ static void ci_extcon_wakeup_int(struct ci_hdrc *ci)
 	cable_id = &ci->platdata->id_extcon;
 	cable_vbus = &ci->platdata->vbus_extcon;
 
-	if ((!IS_ERR(cable_id->edev) || !IS_ERR(ci->role_switch))
+	if ((!IS_ERR(cable_id->edev) || ci->role_switch)
 		&& ci->is_otg &&
 		(otgsc & OTGSC_IDIE) && (otgsc & OTGSC_IDIS))
 		ci_irq(ci);
 
-	if ((!IS_ERR(cable_vbus->edev) || !IS_ERR(ci->role_switch))
+	if ((!IS_ERR(cable_vbus->edev) || ci->role_switch)
 		&& ci->is_otg &&
 		(otgsc & OTGSC_BSVIE) && (otgsc & OTGSC_BSVIS))
 		ci_irq(ci);
-- 
2.39.0


