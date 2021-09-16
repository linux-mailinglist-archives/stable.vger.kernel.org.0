Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA0B40E582
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350757AbhIPRMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245472AbhIPRKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01FC761B49;
        Thu, 16 Sep 2021 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810260;
        bh=nd89eXtBFKueYaWwtvBp619RU0dRzWtOpxQO35ufTUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVXTP84u48O+r6VNgjXBfO5kMHKd3jImbxdf1/410U3ooXFtMjbHHc/WS7pgOmm7i
         /vg3yXhDQxLCfz5MOWUVn5Fkz6L4xnN6h1uxLii5MqPAXswrgs/JgQazopdzQQVctq
         q9AVURf3WyiLd3MueDJhPhXZHuUJA0jA6YIhVIkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.14 058/432] watchdog: iTCO_wdt: Fix detection of SMI-off case
Date:   Thu, 16 Sep 2021 17:56:47 +0200
Message-Id: <20210916155812.757434358@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

commit aec42642d91fc86ddc03e97f0139c6c34ee6b6b1 upstream.

Obviously, the test needs to run against the register content, not its
address.

Fixes: cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on second timeout")
Cc: stable@vger.kernel.org
Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Mantas Mikulėnas <grawity@gmail.com>
Link: https://lore.kernel.org/r/d84f8e06-f646-8b43-d063-fb11f4827044@siemens.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/iTCO_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -362,7 +362,7 @@ static int iTCO_wdt_set_timeout(struct w
 	 * Otherwise, the BIOS generally reboots when the SMI triggers.
 	 */
 	if (p->smi_res &&
-	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
+	    (inl(SMI_EN(p)) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
 		tmrval /= 2;
 
 	/* from the specs: */


