Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0840D3CD9EB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244047AbhGSOcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245048AbhGSOaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2490460551;
        Mon, 19 Jul 2021 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707453;
        bh=bQ6o2NIi3EfTjmaHCOFG+RzRJtr0dJpoXEu17KBfHcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3rgX1NZNz1JLpfLSz4n/VZej6RsjOQFLpLLoo1XvHFR0cb4xZkjzLoE5SaaVvjn0
         eQ7l5SWq0py3TrOx9UyJpsEVI6hHVPjMUB8eVVMvmYtjyjp2eiH5JQRcnAgBTJLtcS
         BlhvrX8591EBcdbUY8fGxiEq+WJm565dMXOZHG3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marcus Cooper <codekipper@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.9 169/245] power: supply: ab8500: Fix an old bug
Date:   Mon, 19 Jul 2021 16:51:51 +0200
Message-Id: <20210719144945.869636730@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit f1c74a6c07e76fcb31a4bcc1f437c4361a2674ce upstream.

Trying to get the AB8500 charging driver working I ran into a bit
of bitrot: we haven't used the driver for a while so errors in
refactorings won't be noticed.

This one is pretty self evident: use argument to the macro or we
end up with a random pointer to something else.

Cc: stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marcus Cooper <codekipper@gmail.com>
Fixes: 297d716f6260 ("power_supply: Change ownership from driver to core")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mfd/abx500/ux500_chargalg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -15,7 +15,7 @@
  * - POWER_SUPPLY_TYPE_USB,
  * because only them store as drv_data pointer to struct ux500_charger.
  */
-#define psy_to_ux500_charger(x) power_supply_get_drvdata(psy)
+#define psy_to_ux500_charger(x) power_supply_get_drvdata(x)
 
 /* Forward declaration */
 struct ux500_charger;


