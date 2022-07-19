Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF345579962
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiGSMCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237920AbiGSMBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:01:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494064331A;
        Tue, 19 Jul 2022 04:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEDAA61640;
        Tue, 19 Jul 2022 11:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC96C341CA;
        Tue, 19 Jul 2022 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231918;
        bh=yO7cXLAxMONxPcse2MF3SOWUyJi9k0jjmONBy+J6g8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9sH05ZnIcALOeZpweIeq3wBfQH677LvddXuvqx+ZhubMVQVfnEYcGTgvqj2aJycJ
         rxAnS7mjtNvEmlAB3gE4r5vWQCGDlz0RzsFshrjyCUvoRvk/OzwFAQAna9ueC6qXWt
         RuWS3XYvpuD30lUxkXaKSLvmkW3B6lH4oKX47/wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 10/43] xhci: bail out early if driver cant accress host in resume
Date:   Tue, 19 Jul 2022 13:53:41 +0200
Message-Id: <20220719114522.949172508@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 72ae194704da212e2ec312ab182a96799d070755 upstream.

Bail out early if the xHC host needs to be reset at resume
but driver can't access xHC PCI registers.

If xhci driver already fails to reset the controller then there
is no point in attempting to free, re-initialize, re-allocate and
re-start the host. If failure to access the host is detected later,
failing the resume, xhci interrupts will be double freed
when remove is called.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200312144517.1593-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1111,8 +1111,10 @@ int xhci_resume(struct xhci_hcd *xhci, b
 
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
-		xhci_reset(xhci);
+		retval = xhci_reset(xhci);
 		spin_unlock_irq(&xhci->lock);
+		if (retval)
+			return retval;
 		xhci_cleanup_msix(xhci);
 
 		xhci_dbg(xhci, "// Disabling event ring interrupts\n");


