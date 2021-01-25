Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1422304B7D
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbhAZEop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbhAYSmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788B723100;
        Mon, 25 Jan 2021 18:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600115;
        bh=Gn+MkB9Eng1cTrCl6XMQZ0tZy4zKzPh+svjPu8k37l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afPgIiScMGPds50/+75bc2hWtTuOerQeaLJVnvytQCPrUuxrHyyexFIRiKR2lxx1Q
         +F06FNqd/73vJe5yn9tw3FcWvJBRx/XO3zSe2N4UeKn8fxt9ZJbqYHJDWBuqVyBps7
         kAmDPAWOKoQp17tJ6Le60sxGNvQXh0B7iwRePb2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 37/58] USB: ehci: fix an interrupt calltrace error
Date:   Mon, 25 Jan 2021 19:39:38 +0100
Message-Id: <20210125183158.308708462@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

commit 643a4df7fe3f6831d14536fd692be85f92670a52 upstream.

The system that use Synopsys USB host controllers goes to suspend
when using USB audio player. This causes the USB host controller
continuous send interrupt signal to system, When the number of
interrupts exceeds 100000, the system will forcibly close the
interrupts and output a calltrace error.

When the system goes to suspend, the last interrupt is reported to
the driver. At this time, the system has set the state to suspend.
This causes the last interrupt to not be processed by the system and
not clear the interrupt flag. This uncleared interrupt flag constantly
triggers new interrupt event. This causing the driver to receive more
than 100,000 interrupts, which causes the system to forcibly close the
interrupt report and report the calltrace error.

so, when the driver goes to sleep and changes the system state to
suspend, the interrupt flag needs to be cleared.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1610416647-45774-1-git-send-email-liulongfang@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -345,6 +345,9 @@ static int ehci_bus_suspend (struct usb_
 
 	unlink_empty_async_suspended(ehci);
 
+	/* Some Synopsys controllers mistakenly leave IAA turned on */
+	ehci_writel(ehci, STS_IAA, &ehci->regs->status);
+
 	/* Any IAA cycle that started before the suspend is now invalid */
 	end_iaa_cycle(ehci);
 	ehci_handle_start_intr_unlinks(ehci);


