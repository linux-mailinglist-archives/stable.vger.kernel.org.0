Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA7B603BDC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiJSIkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiJSIjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3086880EB1;
        Wed, 19 Oct 2022 01:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B6CE617E7;
        Wed, 19 Oct 2022 08:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E551C433C1;
        Wed, 19 Oct 2022 08:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168735;
        bh=fgdXg1wobOdeihxoqquNWvbEhAq2SyCVppXeIRBGkRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPX0izFWn8RqJAxNCVRXGZqEJ5b5n3LQYIZ8JMkK1qMoRly5K3gCxp87LZO3eKbNt
         ETx+HmJeyNEYBz6FommNcEEIlrzHRj79qWV+OOmjSNnB5ex9tPV+H1MJrFoz/OHocZ
         fhkPUXdzog1e3OLB8vp9CFt7GzUEMLh7P1QsZs4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.0 029/862] xhci: dbc: Fix memory leak in xhci_alloc_dbc()
Date:   Wed, 19 Oct 2022 10:21:56 +0200
Message-Id: <20221019083251.301923715@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

commit d591b32e519603524a35b172156db71df9116902 upstream.

If DbC is already in use, then the allocated memory for the xhci_dbc struct
doesn't get freed before returning NULL, which leads to a memleak.

Fixes: 534675942e90 ("xhci: dbc: refactor xhci_dbc_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220921123450.671459-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -988,7 +988,7 @@ xhci_alloc_dbc(struct device *dev, void
 	dbc->driver = driver;
 
 	if (readl(&dbc->regs->control) & DBC_CTRL_DBC_ENABLE)
-		return NULL;
+		goto err;
 
 	INIT_DELAYED_WORK(&dbc->event_work, xhci_dbc_handle_events);
 	spin_lock_init(&dbc->lock);


