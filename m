Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D581C19B379
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbgDAQge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388133AbgDAQgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:36:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CABE20BED;
        Wed,  1 Apr 2020 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758992;
        bh=nApbZ80mXRy/+ibrdVc/TvjMd1UMq5jINCA6FxGD2T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fscQi4f6g1flnTKcL505kvLNSMvf527Ddwo5J5wcxb3n0+gca/AMYIpQbLwzjSDCr
         QBv3GiHbXUp4vjycaas4T+JXFL8OXtx3v6Acw7gMN8IvR6dsWf6AlwQwqEm0cw2In1
         ZyHg6VMxsQFrzKs6x7NH0QEV6ntj8wkaw6vCS0gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.9 008/102] USB: Disable LPM on WD19s Realtek Hub
Date:   Wed,  1 Apr 2020 18:17:11 +0200
Message-Id: <20200401161533.326184425@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit b63e48fb50e1ca71db301ca9082befa6f16c55c4 upstream.

Realtek Hub (0bda:0x0487) used in Dell Dock WD19 sometimes drops off the
bus when bringing underlying ports from U3 to U0.

Disabling LPM on the hub during setting link state is not enough, so
let's disable LPM completely for this hub.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200205112633.25995-3-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -229,6 +229,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Realtek hub in Dell WD19 (Type-C) */
+	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },


