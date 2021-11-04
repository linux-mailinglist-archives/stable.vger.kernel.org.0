Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1DF4454C0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhKDORX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231705AbhKDORF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA710611C4;
        Thu,  4 Nov 2021 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035267;
        bh=z0720/qrSeRBwGLFaB14ge8mHngrzH6hqDn69QTk0Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jq4gPYSZiZQrzxPtoHHCKlF2IlByJyXJiZ/dEJGqx4uMg9cbPW/XB2QHfwATSrzp1
         +tv5i+WBSm0x5KIoM4PNEuBqQJS5YVUIF4A6j1wF9jmfXrLVjl7vZzmNCMJm/fIuMA
         X7F7GNO+/whixl7QLci8Nvq8/5eEW/ff44/sWmko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.14 05/16] Revert "xhci: Set HCD flag to defer primary roothub registration"
Date:   Thu,  4 Nov 2021 15:12:36 +0100
Message-Id: <20211104141200.032189817@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 807ac762afee3b88f17354327c74d986e7489b8a which is
commit b7a0a792f864583207c593b50fd1b752ed89f4c1 upstream.

It has been reported to be causing problems in Arch and Fedora bug
reports.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Link: https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2019542
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2019576
Link: https://lore.kernel.org/r/42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Chris Chiu <chris.chiu@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -692,7 +692,6 @@ int xhci_run(struct usb_hcd *hcd)
 		if (ret)
 			xhci_free_command(xhci, command);
 	}
-	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 


