Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3C42DC4B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhJNO6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhJNO5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 541B2610F8;
        Thu, 14 Oct 2021 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223337;
        bh=v7+TkdjV8KAuHdhOoUIUNqS4/e3tlVITDpERbHGJTNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+Ss25SrVneGsHbY97+pSrh8eGt0JDQzl8l8BuYUElK2vrUGs72FZZ39v2zPwIC5f
         5gXmoF7zvHzQeKjgQoQBrxAOI1rB1o8OMcgteDU/4EU37eNHCNrSSNgW/4tLvdUjsO
         vNUrAsi1j4a/BNWljvrbiB3U3zh0tSK1TFjSHN5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.9 01/25] Partially revert "usb: Kconfig: using select for USB_COMMON dependency"
Date:   Thu, 14 Oct 2021 16:53:32 +0200
Message-Id: <20211014145207.623708072@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit 4d1aa9112c8e6995ef2c8a76972c9671332ccfea upstream.

This reverts commit cb9c1cfc86926d0e86d19c8e34f6c23458cd3478 for
USB_LED_TRIG.  This config symbol has bool type and enables extra code
in usb_common itself, not a separate driver.  Enabling it should not
force usb_common to be built-in!

Fixes: cb9c1cfc8692 ("usb: Kconfig: using select for USB_COMMON dependency")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/r/20210921143442.340087-1-carnil@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -160,8 +160,7 @@ source "drivers/usb/gadget/Kconfig"
 
 config USB_LED_TRIG
 	bool "USB LED Triggers"
-	depends on LEDS_CLASS && LEDS_TRIGGERS
-	select USB_COMMON
+	depends on LEDS_CLASS && USB_COMMON && LEDS_TRIGGERS
 	help
 	  This option adds LED triggers for USB host and/or gadget activity.
 


