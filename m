Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95196DEE91
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjDLImu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjDLImX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:42:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8528786BB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 619C363072
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733FAC433EF;
        Wed, 12 Apr 2023 08:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288906;
        bh=vVMujNle3lMqeU6dWkS8rSDZt+7+0BlHFempBIRKjQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7wkTr23+YdPMmPX393IiSGCgfqa8fokJWkcB7zN2oT6UadLNnvvNJSIWuO8t11sZ
         Ms5+CqAOfApfdI411vPzW8+c2HKV5n3hVQhpmaNkrX9IfS7xwnzKs+MO/fwm3MD95x
         RXCZD7XaJqc38Ivdll4rOA8NPAc7cXe9dkeGqcR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 063/164] xhci: Free the command allocated for setting LPM if we return early
Date:   Wed, 12 Apr 2023 10:33:05 +0200
Message-Id: <20230412082839.493782643@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 


