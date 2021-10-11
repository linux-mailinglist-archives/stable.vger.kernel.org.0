Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A716428FDC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbhJKOBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238005AbhJKN7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 093F260F6E;
        Mon, 11 Oct 2021 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960599;
        bh=6xGs4lMDOTDyCBKNi0Dggj8SWnrnTlV12MwzTreLdUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnpGDQa3MIJSTvCl4n/5JM9Nz/kvr0qVbGt+cWUapVkIgxA/ZyydY3bw7Irbh2wqw
         8feMcAw0GW+JLxnzRjUgFuDm8DDiSiEwuEVZlLqAKTcFjrUdC2/VqrunlZuXa4EiXk
         FnDBmQJNdRtizYAPBtjpUZw5yccVwOxaXu07NZ4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.14 002/151] usb: cdc-wdm: Fix check for WWAN
Date:   Mon, 11 Oct 2021 15:44:34 +0200
Message-Id: <20211011134517.913099879@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

commit 04d2b75537085cb0c85d73a2e0e50317bffa883f upstream.

CONFIG_WWAN_CORE was with CONFIG_WWAN in commit 89212e160b81 ("net: wwan:
Fix WWAN config symbols"), but did not update all users of it. Change it
back to use CONFIG_WWAN instead.

Fixes: 89212e160b81 ("net: wwan: Fix WWAN config symbols")
Cc: <stable@vger.kernel.org>
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210929194547.46954-2-rikard.falkeborn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -824,7 +824,7 @@ static struct usb_class_driver wdm_class
 };
 
 /* --- WWAN framework integration --- */
-#ifdef CONFIG_WWAN_CORE
+#ifdef CONFIG_WWAN
 static int wdm_wwan_port_start(struct wwan_port *port)
 {
 	struct wdm_device *desc = wwan_port_get_drvdata(port);
@@ -963,11 +963,11 @@ static void wdm_wwan_rx(struct wdm_devic
 	/* inbuf has been copied, it is safe to check for outstanding data */
 	schedule_work(&desc->service_outs_intr);
 }
-#else /* CONFIG_WWAN_CORE */
+#else /* CONFIG_WWAN */
 static void wdm_wwan_init(struct wdm_device *desc) {}
 static void wdm_wwan_deinit(struct wdm_device *desc) {}
 static void wdm_wwan_rx(struct wdm_device *desc, int length) {}
-#endif /* CONFIG_WWAN_CORE */
+#endif /* CONFIG_WWAN */
 
 /* --- error handling --- */
 static void wdm_rxwork(struct work_struct *work)


