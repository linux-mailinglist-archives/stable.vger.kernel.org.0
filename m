Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CA64454A3
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhKDOQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231447AbhKDOQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E91611C1;
        Thu,  4 Nov 2021 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035235;
        bh=78bgP46dgD+WIALiLEJ02vL1KmCe3kcU77+QvWCqnVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXse6bXfuD4CPhhr50e/OIpZfBsJLDJS2ra3ynAJJeXy1gLwjehG2cI1EpUkeYSHo
         0MHFMe+n8nk5exql7iUKJpD4zHknFkEN569E4OwiogMn0hWcRZ0Blw9G9FiFbOx1fE
         /WGleZw5BOEKB27Iu5AQALtYp5YafFJgeqpGtuPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.15 03/12] Revert "xhci: Set HCD flag to defer primary roothub registration"
Date:   Thu,  4 Nov 2021 15:12:29 +0100
Message-Id: <20211104141159.670046356@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b7a0a792f864583207c593b50fd1b752ed89f4c1.

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
 


