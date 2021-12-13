Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C89B4727DC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241804AbhLMKFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50050 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbhLMKCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:02:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 416B2CE0F55;
        Mon, 13 Dec 2021 10:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74B7C34600;
        Mon, 13 Dec 2021 10:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389747;
        bh=GGv27K9df6wUUKge/umrWY1aFmKVPGaU359dqxvROAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxxrss9CgYnvHXg70bXJz5z10xRLnGgDqb9J3kkyDuxtcBIulYfABE1xJUNr0Dnfs
         nWgF+Bz/JbcI9JF6X6/IxAjFgWZp+YZPywTW02DotDcSL1ABaLpqGTgQCNmi1V2bmP
         koPpLUMQBtk9XcXfndZAcEYFjxBF8dy3y+x1AnWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Vadim V. Vlasov" <vadim.vlasov@elpitech.ru>,
        Alexey Sheplyakov <asheplyakov@basealt.ru>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 170/171] clocksource/drivers/dw_apb_timer_of: Fix probe failure
Date:   Mon, 13 Dec 2021 10:31:25 +0100
Message-Id: <20211213092950.726173439@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Sheplyakov <asheplyakov@basealt.ru>

commit a663bd19114d79f0902e2490fc484e5a7419cdc2 upstream.

The driver refuses to probe with -EINVAL since the commit 5d9814df0aec
("clocksource/drivers/dw_apb_timer_of: Add error handling if no clock
available").

Before the driver used to probe successfully if either "clock-freq" or
"clock-frequency" properties has been specified in the device tree.

That commit changed

if (A && B)
	panic("No clock nor clock-frequency property");

into

if (!A && !B)
	return 0;

That's a bug: the reverse of `A && B` is '!A || !B', not '!A && !B'

Signed-off-by: Vadim V. Vlasov <vadim.vlasov@elpitech.ru>
Signed-off-by: Alexey Sheplyakov <asheplyakov@basealt.ru>
Fixes: 5d9814df0aec56a6 ("clocksource/drivers/dw_apb_timer_of: Add error handling if no clock available").
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vadim V. Vlasov <vadim.vlasov@elpitech.ru>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20211109153401.157491-1-asheplyakov@basealt.ru
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -47,7 +47,7 @@ static int __init timer_get_base_and_rat
 			pr_warn("pclk for %pOFn is present, but could not be activated\n",
 				np);
 
-	if (!of_property_read_u32(np, "clock-freq", rate) &&
+	if (!of_property_read_u32(np, "clock-freq", rate) ||
 	    !of_property_read_u32(np, "clock-frequency", rate))
 		return 0;
 


