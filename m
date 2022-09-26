Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E55EA098
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiIZKkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbiIZKjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344184BD34;
        Mon, 26 Sep 2022 03:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17544CE10EC;
        Mon, 26 Sep 2022 10:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8E9C433C1;
        Mon, 26 Sep 2022 10:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187755;
        bh=xP7XOWPMnFeVu890uppPhA3VUfoPZOvUcblwscp7WOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5YeKm1D6OEhVIUxGa9VPIKW0XuQdLxnq5QyfY+3xR61fqL/tdNqKbTEggxAcU++R
         q/9eRorin319mhVl3uKvWUag5x+WfRcZa9pqJaHRrWabO8TTRgA3Nqv+Ue9k/FRj2l
         2ao4onxkYgzMrtjUe35S3HowhCd5m+lzqncobjak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/120] usb: cdns3: fix issue with rearming ISO OUT endpoint
Date:   Mon, 26 Sep 2022 12:11:23 +0200
Message-Id: <20220926100752.602823497@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit b46a6b09fa056042a302b181a1941f0056944603 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 8bedf0504e92..d111cf81cece 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1259,6 +1259,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 				ep_cfg &= ~EP_CFG_ENABLE;
 				writel(ep_cfg, &priv_dev->regs->ep_cfg);
 				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
+				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
 			}
 			cdns3_transfer_completed(priv_dev, priv_ep);
 		} else if (!(priv_ep->flags & EP_STALLED) &&
-- 
2.35.1



