Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809FC3739ED
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhEEMGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233277AbhEEMGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB006121F;
        Wed,  5 May 2021 12:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216323;
        bh=Xp8BkyYpdA6m2is4Ncl9MO72bgGFjVI0vRmrahfqTOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkFHVCdaXCN9B8kmhe3lwR6IgzPTn10COXXu8zz+NcXinTT4/ifzfdiMo4kL+POo5
         qjr3BzuCIP+8RZimQLyPJSz15eEUOY147cYOW4s5Sfz7HDaIyD5xPkUGApxjRoHYMV
         VALCAlGZQwQnCqVTz02l0HktgmkdaTs2D85x3SZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 5.4 14/21] USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet
Date:   Wed,  5 May 2021 14:04:28 +0200
Message-Id: <20210505112325.202475316@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 8f23fe35ff1e5491b4d279323a8209a31f03ae65 upstream.

This is another branded 8153 device that doesn't work well with LPM
enabled:
[ 400.597506] r8152 5-1.1:1.0 enx482ae3a2a6f0: Tx status -71

So disable LPM to resolve the issue.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
BugLink: https://bugs.launchpad.net/bugs/1922651
Link: https://lore.kernel.org/r/20210412135455.791971-1-kai.heng.feng@canonical.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -438,6 +438,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 
+	/* Lenovo ThinkPad USB-C Dock Gen2 Ethernet (RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0xa387), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },


