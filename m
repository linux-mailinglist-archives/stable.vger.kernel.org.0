Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E2E38A585
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhETKRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236465AbhETKPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8326144D;
        Thu, 20 May 2021 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503921;
        bh=PWhh0ZcWeQn8bVv0bIWSaizyESpeNWTFdsOuegL4smM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxpsMKalZRBnZXMygF/swSONBLvDVnprXwMauYyU8C2CSxuMaGUiUTPqxoaWvggW0
         Yb3s2wM0uaWHUzo94PglyqgUckpvnff/shWTLiwBNNKNz4BAi2gezRxYO7M36AFrsH
         yr6ENRpATRBZNzXXrdxAss6fkdBUqJWT/2EY47JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.14 014/323] USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet
Date:   Thu, 20 May 2021 11:18:26 +0200
Message-Id: <20210520092120.599576145@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
@@ -264,6 +264,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo ThinkPad USB-C Dock Gen2 Ethernet (RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0xa387), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },


