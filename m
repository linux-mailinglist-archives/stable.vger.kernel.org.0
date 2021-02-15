Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5DC31BEEE
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhBOQVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231703AbhBOPq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:46:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC7F64EB2;
        Mon, 15 Feb 2021 15:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403302;
        bh=IwpvTOBV/qBSb/D4GNBQPatO473ds64g9Ir3Kza9X0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwH+nKfOnDg3tLNklLKCzHRM8ytYacWEgig+5Gf9D7ji/0OdeSADkI18nbP73SSvs
         GKU1GMjZGTf7NQrqnxYy+vwK5BdgH8tPk4fIXiIAJ18dbMX/xazc6CsOFol3wVNtFT
         ZgUAFNcMy8vBe9AE/izmOfg/7cs/By6KOqnIddxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 5.10 104/104] kcov, usb: only collect coverage from __usb_hcd_giveback_urb in softirq
Date:   Mon, 15 Feb 2021 16:27:57 +0100
Message-Id: <20210215152722.828789915@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit aee9ddb1d3718d3ba05b50c51622d7792ae749c9 upstream.

Currently there's a KCOV remote coverage collection section in
__usb_hcd_giveback_urb(). Initially that section was added based on the
assumption that usb_hcd_giveback_urb() can only be called in interrupt
context as indicated by a comment before it. This is what happens when
syzkaller is fuzzing the USB stack via the dummy_hcd driver.

As it turns out, it's actually valid to call usb_hcd_giveback_urb() in task
context, provided that the caller turned off the interrupts; USB/IP does
exactly that. This can lead to a nested KCOV remote coverage collection
sections both trying to collect coverage in task context. This isn't
supported by KCOV, and leads to a WARNING.

Change __usb_hcd_giveback_urb() to only call kcov_remote_*() callbacks
when it's being executed in a softirq. As the result, the coverage from
USB/IP related usb_hcd_giveback_urb() calls won't be collected, but the
WARNING is fixed.

A potential future improvement would be to support nested remote coverage
collection sections, but this patch doesn't address that.

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/r/f3a7a153f0719cb53ec385b16e912798bd3e4cf9.1602856358.git.andreyknvl@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1646,9 +1646,16 @@ static void __usb_hcd_giveback_urb(struc
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
-	kcov_remote_start_usb((u64)urb->dev->bus->busnum);
+	/*
+	 * This function can be called in task context inside another remote
+	 * coverage collection section, but KCOV doesn't support that kind of
+	 * recursion yet. Only collect coverage in softirq context for now.
+	 */
+	if (in_serving_softirq())
+		kcov_remote_start_usb((u64)urb->dev->bus->busnum);
 	urb->complete(urb);
-	kcov_remote_stop();
+	if (in_serving_softirq())
+		kcov_remote_stop();
 
 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);


