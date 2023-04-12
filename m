Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2AE6DEF4E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjDLItd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjDLIt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373D9E65
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D587762C20
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F22C433EF;
        Wed, 12 Apr 2023 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289342;
        bh=vVMujNle3lMqeU6dWkS8rSDZt+7+0BlHFempBIRKjQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWJ0HYaZKrUioi9jtfFhTroV2gEBcKXYqkE3iMmtxZNuLDN+DWJTPA67kcAZL0VeQ
         Xti5RvSr7UD5jwa87WlunrvnA3QXisS8rsjApb+RMESZ1RlVzzH8trG34j18+F0gkC
         Pi06YFjxAtNccO0GoGEB1Y7IQ+FQSYARuM1DKv5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.2 063/173] xhci: Free the command allocated for setting LPM if we return early
Date:   Wed, 12 Apr 2023 10:33:09 +0200
Message-Id: <20230412082840.626982848@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f6caea4855553a8b99ba3ec23ecdb5ed8262f26c upstream.

The command allocated to set exit latency LPM values need to be freed in
case the command is never queued. This would be the case if there is no
change in exit latency values, or device is missing.

Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230330143056.1390020-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4406,6 +4406,7 @@ static int __maybe_unused xhci_change_ma
 
 	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
+		xhci_free_command(xhci, command);
 		return 0;
 	}
 


