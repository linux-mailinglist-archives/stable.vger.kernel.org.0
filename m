Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB0F2E3F41
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392108AbgL1OcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392101AbgL1Obw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4620920791;
        Mon, 28 Dec 2020 14:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165896;
        bh=WmPOZiA28eMxsh5USZaoHVnbE4Q8/E4DuTNXX/FnMBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFcHHnFSqI5+OEse81ieiDahq6XGjyuqqfkGGEYdR08w9RfgFPHsDkg0xSYSD1Bos
         GliyGoyqyQPijwa+p+YbtuWnZcPcntwKX+GPtMizIYEOGydsng1PGal2MvvDAgxWfK
         qJJQYNgtBjOt6d7VjkLW/J3WH/viqVCJzMgBlvKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 5.10 694/717] driver: core: Fix list corruption after device_del()
Date:   Mon, 28 Dec 2020 13:51:32 +0100
Message-Id: <20201228125054.232036599@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 66482f640755b31cb94371ff6cef17400cda6db5 upstream.

The device_links_purge() function (called from device_del()) tries to
remove the links.needs_suppliers list entry, but it's using
list_del(), hence it doesn't initialize after the removal.  This is OK
for normal cases where device_del() is called via device_destroy().
However, it's not guaranteed that the device object will be really
deleted soon after device_del().  In a minor case like HD-audio codec
reconfiguration that re-initializes the device after device_del(), it
may lead to a crash by the corrupted list entry.

As a simple fix, replace list_del() with list_del_init() in order to
make the list intact after the device_del() call.

Fixes: e2ae9bcc4aaa ("driver core: Add support for linking devices during device addition")
Cc: <stable@vger.kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20201208190326.27531-1-tiwai@suse.de
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1386,7 +1386,7 @@ static void device_links_purge(struct de
 		return;
 
 	mutex_lock(&wfs_lock);
-	list_del(&dev->links.needs_suppliers);
+	list_del_init(&dev->links.needs_suppliers);
 	mutex_unlock(&wfs_lock);
 
 	/*


