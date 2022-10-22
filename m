Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D19608596
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJVHfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJVHfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE4E4E60B;
        Sat, 22 Oct 2022 00:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0BE60ADA;
        Sat, 22 Oct 2022 07:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787D5C433D6;
        Sat, 22 Oct 2022 07:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424090;
        bh=fgdXg1wobOdeihxoqquNWvbEhAq2SyCVppXeIRBGkRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMvJz0MfUM4sCCdr1HUwErv5EsYadjEQutN6wdEYF7nWE9aZNdgpMmxjAk0gfTQ6K
         jqnTIsLWE2gwG5i95kdlHWxHOGz0E5x7mToI3U4TUWga4Gm+bQReRveaqXI++4sHQI
         FJXoIjTLL+YCiA5HueRjdkOZOkNalU1ZSfxVZZZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.19 024/717] xhci: dbc: Fix memory leak in xhci_alloc_dbc()
Date:   Sat, 22 Oct 2022 09:18:23 +0200
Message-Id: <20221022072419.380936693@linuxfoundation.org>
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


