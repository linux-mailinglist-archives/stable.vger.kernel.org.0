Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F91D428E8A
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhJKNtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234464AbhJKNta (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:49:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DB9160E8B;
        Mon, 11 Oct 2021 13:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960050;
        bh=rT3cDRN4LZH0upw88GZNUXZrx4qrZK8EGET4m451yKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtdKcfIvX5T9nS2jWNoQ76ggzQYbQdV3qYB7V9H06BsLyRoLQzZlqk6ClsRTVkwRv
         Vp3XDRvsFD7du+vi4TBJ9L4zznVig+kOT9PJ0k1/hEXKChHedMyy4WaC48/XgbzJx/
         YzbLx9mVyOhEwHMzMC+19gjkC+A9skD65fPKDB1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.4 01/52] Partially revert "usb: Kconfig: using select for USB_COMMON dependency"
Date:   Mon, 11 Oct 2021 15:45:30 +0200
Message-Id: <20211011134503.765541677@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
 drivers/usb/common/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/common/Kconfig
+++ b/drivers/usb/common/Kconfig
@@ -6,8 +6,7 @@ config USB_COMMON
 
 config USB_LED_TRIG
 	bool "USB LED Triggers"
-	depends on LEDS_CLASS && LEDS_TRIGGERS
-	select USB_COMMON
+	depends on LEDS_CLASS && USB_COMMON && LEDS_TRIGGERS
 	help
 	  This option adds LED triggers for USB host and/or gadget activity.
 


