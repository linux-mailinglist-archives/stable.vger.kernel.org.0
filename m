Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4A4454F9
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhKDOTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhKDOSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF66611F2;
        Thu,  4 Nov 2021 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035342;
        bh=dP4KARcs0Bs7NKmvPnuE35GlR/rJPtlHkvr8icsWdZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv/DyzaCAVmFcLJYWOET84rm7mvePVMvECuPaUOD5s+IN8JhzbTp4KzyebiGi9ubj
         i5WZZPWZOPbNyKgZwgQO+iToCTPnFhtyl7fdx69DkrSGL3SHZFuQLVDYlQPZfv90LU
         Ev3+ZqqFahqqmuyqwztPnQ8Jd0tm+riJuC3xtvfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.10 09/16] Revert "xhci: Set HCD flag to defer primary roothub registration"
Date:   Thu,  4 Nov 2021 15:12:48 +0100
Message-Id: <20211104141159.896009810@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 0ea9ac731a315cd10bd6d6b33817b68ca9111ecf which is
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
@@ -693,7 +693,6 @@ int xhci_run(struct usb_hcd *hcd)
 		if (ret)
 			xhci_free_command(xhci, command);
 	}
-	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 


