Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F0F48E633
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbiANIYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:24:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33932 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239900AbiANIWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ED60B82443;
        Fri, 14 Jan 2022 08:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465A4C36AE9;
        Fri, 14 Jan 2022 08:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148547;
        bh=8GFM8MvwpFq8w6DiPHbGyX52z5/r4lEr4SVXvAN/DRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cq9eNgTJVSOIcntwcD6+Jb364/juJKYI0wiQ/CUNbyWzoCoaAI6Cj1CP4Jgdy8itS
         lGQmHELQRS618GyCnwhQG1R1OvUEY7TlMrIbUYFN2NhdzbjnciI0OUP88uJ3Ls28BZ
         VE8uCfi9MThmVb633f0vrYTmHe9mFcVqSV9UirbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 5.16 03/37] staging: r8188eu: switch the led off during deinit
Date:   Fri, 14 Jan 2022 09:16:17 +0100
Message-Id: <20220114081544.969588704@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kaiser <martin@kaiser.cx>

commit 9d36de31130542fc060f7cd17e72db670202c682 upstream.

When the driver is unloaded or when the system goes into standby mode,
DeInitLed871x is called to stop the led layer. In this case, we stop
the blinking worker but we do not switch the led off explicitly. On my
system, I can go into standby mode with the LED enabled.

Add a call to SwLedOff to fix this.

Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://lore.kernel.org/r/20211226195556.159471-2-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/core/rtw_led.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -54,6 +54,7 @@ void DeInitLed871x(struct LED_871x *pLed
 	_cancel_workitem_sync(&pLed->BlinkWorkItem);
 	_cancel_timer_ex(&pLed->BlinkTimer);
 	ResetLedStatus(pLed);
+	SwLedOff(pLed->padapter, pLed);
 }
 
 static void SwLedBlink1(struct LED_871x *pLed)


