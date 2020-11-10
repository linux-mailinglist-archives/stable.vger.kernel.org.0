Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAF42AE3A4
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 23:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbgKJWtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 17:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJWtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 17:49:55 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF88C0613D3
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:49:55 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id d3so792527plo.4
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oTLSsibufzWzMwpo8qkoqYzphbDo9oHVLv73BEVjMRw=;
        b=hve4HvrQq9EsNI1QYuz6/oOdzvECxuqSP0+b1p6EfXlOOXhazaB1Z25028V96c/x0i
         WN/LSNq9cPZNHJfr2ViI6fEgekAeA8l538rRWv4m/UyM/Uz6PBnOHf7Qhvy5QL0qhUUC
         PQevEI+qUeaKWHSPge3oKEqgx9XBtwZVbm8Xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oTLSsibufzWzMwpo8qkoqYzphbDo9oHVLv73BEVjMRw=;
        b=Xg6cPTphCSc++nikgi+1x1k01Ia1V07Sd+sM03PLXRKyhurEfA3It0xoYvkL1cUYHt
         KdajbDRBzwhYbSnAD/KipmsW/60U24b8vt/QZ7EG5l4PSk/EBfCXvUBMzMMko8Yh5Qoq
         WC5W6ds6i7Z2gL3s0tw/nDyDqTkn0HM05Q8JOXCegt+B0khW6J+3r/+F2jhgCutewrrm
         1YAU0EyHjzEFqQaMzvNk4AKgXIbOzOyr9M3jRfR4hjtu0B+HKizUwdZUapAMZ7O+Pld/
         KC54ztvcaIIOxyvhPUf2tr0NRojavTX21w85aj/o9a2dqh20G/g5HLkw4ighOxiB73QT
         tBkQ==
X-Gm-Message-State: AOAM533z+xqAt/73l75ad0H8wj4EhL0AGuTZUpkw17z5Usre0bPAtM04
        dM43WhwQ7XIWE3tc9OoAbXQpTw==
X-Google-Smtp-Source: ABdhPJwfhNHYZjFRje1wP4WQws5EGleZth9p2I30TlxBONK6+npBRQ16AFvbx3VYftASE6iJ5bOJng==
X-Received: by 2002:a17:902:fe8a:b029:d7:e629:9551 with SMTP id x10-20020a170902fe8ab02900d7e6299551mr9160621plm.79.1605048594925;
        Tue, 10 Nov 2020 14:49:54 -0800 (PST)
Received: from evgreen-glaptop.cheshire.ch ([2601:646:c780:1404:250:b6ff:fee1:7d4c])
        by smtp.gmail.com with ESMTPSA id i7sm34066pjj.20.2020.11.10.14.49.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Nov 2020 14:49:54 -0800 (PST)
From:   Evan Green <evgreen@chromium.org>
To:     Andy Shevchenko <andy@kernel.org>
Cc:     Evan Green <evgreen@chromium.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: intel: Fix Jasperlake hostown offset
Date:   Tue, 10 Nov 2020 14:49:49 -0800
Message-Id: <20201110144932.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GPIOs that attempt to use interrupts get thwarted with a message like:
"pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
the JSL_HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
owned by ACPI.

Signed-off-by: Evan Green <evgreen@chromium.org>
Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin
controller support")
Cc: stable@vger.kernel.org
---

 drivers/pinctrl/intel/pinctrl-jasperlake.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-jasperlake.c b/drivers/pinctrl/intel/pinctrl-jasperlake.c
index 9bd0e8e6310c3..283698cf0dc7d 100644
--- a/drivers/pinctrl/intel/pinctrl-jasperlake.c
+++ b/drivers/pinctrl/intel/pinctrl-jasperlake.c
@@ -16,7 +16,7 @@
 
 #define JSL_PAD_OWN	0x020
 #define JSL_PADCFGLOCK	0x080
-#define JSL_HOSTSW_OWN	0x0b0
+#define JSL_HOSTSW_OWN	0x0c0
 #define JSL_GPI_IS	0x100
 #define JSL_GPI_IE	0x120
 
-- 
2.26.2

