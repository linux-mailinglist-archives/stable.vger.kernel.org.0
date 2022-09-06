Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21E05AE692
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiIFL1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiIFL1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54643E4B
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD46460ED1
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D8CC433C1;
        Tue,  6 Sep 2022 11:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463634;
        bh=LRFFY+DS6X3P8wS/pqswYR+r6yWjYwUN7pgs0hjT7a0=;
        h=Subject:To:Cc:From:Date:From;
        b=vgGrkfwgctOd6kBkAEtA3ZYB6Yc/X2W56O8HP1orbxz7spb22lc6lFa6DUtjh1e8M
         5Bqo94qcOt803OstopiMUoyLt4FXluujGhN/XOdc2fzFp4/UHZOAPVVVU5fcU1rL1f
         rza/XrvwxrY9Awkifx9YfJGl2gmOTc2sFSe/jTyM=
Subject: FAILED: patch "[PATCH] usb: cdns3: fix issue with rearming ISO OUT endpoint" failed to apply to 5.4-stable tree
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:27:11 +0200
Message-ID: <16624636314877@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b46a6b09fa056042a302b181a1941f0056944603 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Thu, 25 Aug 2022 08:21:37 +0200
Subject: [PATCH] usb: cdns3: fix issue with rearming ISO OUT endpoint

ISO OUT endpoint is enabled during queuing first usb request
in transfer ring and disabled when TRBERR is reported by controller.
After TRBERR and before next transfer added to TR driver must again
reenable endpoint but does not.
To solve this issue during processing TRBERR event driver must
set the flag EP_UPDATE_EP_TRBADDR in priv_ep->flags field.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220825062137.5766-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 4f11c311acaf..5adcb349718c 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1691,6 +1691,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 				ep_cfg &= ~EP_CFG_ENABLE;
 				writel(ep_cfg, &priv_dev->regs->ep_cfg);
 				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
+				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
 			}
 			cdns3_transfer_completed(priv_dev, priv_ep);
 		} else if (!(priv_ep->flags & EP_STALLED) &&

