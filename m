Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ABB3CD85B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbhGSOVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242710AbhGSOUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27FC360551;
        Mon, 19 Jul 2021 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706868;
        bh=bQ6o2NIi3EfTjmaHCOFG+RzRJtr0dJpoXEu17KBfHcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJYHvaY2i6bkkBWy4LHKl/jcCPZM/8NlCqeTaq/T1shIJ72N9qb/NAUc68PZKaQ5i
         +YROnSnFr7OxSWuyMIasz5gOokLc5TJKeggMFyLdj4fAFS3oqyxl0TiltvYdT2OqUO
         8LlZVClu4Sq/Qj0Gb4x6i5qSFRU918Mm3b2gxj9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marcus Cooper <codekipper@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.4 132/188] power: supply: ab8500: Fix an old bug
Date:   Mon, 19 Jul 2021 16:51:56 +0200
Message-Id: <20210719144940.808576241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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


