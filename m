Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACA65AEC10
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbiIFOLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241551AbiIFOKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7E186C13;
        Tue,  6 Sep 2022 06:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FAE760F89;
        Tue,  6 Sep 2022 13:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607C1C433D6;
        Tue,  6 Sep 2022 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472033;
        bh=qpDSi8Cq/D9AtkyR6e0dv7yhz5NO/64eV3IVCIZOq4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSUmZOECasTmTBGqpqCAOvM0rXjlq+iBkr87ueDr6n4l37W9ITIMf+Qgsq0yQkITf
         ue65WEIuvaIHQTnjvRiMqgJOmGfnqmW7x09CQgMY0vRaZ/PQ/3FNtWl+xj5pXcCdFM
         6TefYGADgZsXAeGTLVPEbT9gAgfLAh957D8B5icQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.19 124/155] usb: cdns3: fix issue with rearming ISO OUT endpoint
Date:   Tue,  6 Sep 2022 15:31:12 +0200
Message-Id: <20220906132834.694726677@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Pawel Laszczak <pawell@cadence.com>

commit b46a6b09fa056042a302b181a1941f0056944603 upstream.

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
---
 drivers/usb/cdns3/cdns3-gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1690,6 +1690,7 @@ static int cdns3_check_ep_interrupt_proc
 				ep_cfg &= ~EP_CFG_ENABLE;
 				writel(ep_cfg, &priv_dev->regs->ep_cfg);
 				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
+				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
 			}
 			cdns3_transfer_completed(priv_dev, priv_ep);
 		} else if (!(priv_ep->flags & EP_STALLED) &&


