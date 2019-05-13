Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E681AF13
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 05:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfEMDPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 May 2019 23:15:38 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39208 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfEMDPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 May 2019 23:15:38 -0400
Received: by mail-qk1-f193.google.com with SMTP id z128so7148042qkb.6
        for <stable@vger.kernel.org>; Sun, 12 May 2019 20:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yd+HZMnsQ+5FsKeVzZLsE5zVu4hg4LnZqbae8xAM8eo=;
        b=X3JFlnTwX/NwbobzTjxupzz+FIc38NZWiimvaWfsTPwpogMtIMzPp2gxpMEFsSZMxT
         AtESXV2aBu4DC0RXIuz2dKlvXtjdjpbw6Znn0yCgkfC60DOSOtKfn4s8Doa6cN9Jj7Xk
         IF+OB6POOZMgw/TKhWizMAkUBbXV5wAXHzAS8a6VAodwOggWW8JeEoNmQvqaNs2PJMGo
         VwnivdC3KT4JIOCMKAS2NrzXYma94cZaXf2UUT7RL533tHn1OnfyqSmOr8laHWNfcK73
         ByXnmlpNjGR1EG9nCoImLTT6vnM7NlmrenoAKG/Va4iC5WPGc/p5xLSmyObXHiZYkNBH
         dcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yd+HZMnsQ+5FsKeVzZLsE5zVu4hg4LnZqbae8xAM8eo=;
        b=LZ2Rp++QTHM1CNCv16ztbiIMv9JdRiB8ki4Dpp0sXFtw1tH/SO4g+bWUyiRLOrv/2c
         Xotr2EcLW3BwOPxugah8i6LHbNN7S/UbnomkKAviP7bqFwdtcMEwuy3/jpf97wbYS5dl
         nSklVYvpmxMk/esQulhs0CYCKcyvCxP5bucDZgEO6u4nDMRWG6RhqnncSU81Z4WcYx/+
         bVu8z1zSEpa5frzRVG7/UiCW15DDkXJJSQa3YbLXlLHP3sv8OzrCWmPdDl6LoFNEASzY
         av6F0cjanYsDdH7l3QiCnxV9pp/79sNcq1FtnwWErX18TdOrrlRb1yatsSBqc8u08f64
         tbOQ==
X-Gm-Message-State: APjAAAWjHLo2YDssCbh4z656S1G6Y7U6pTAS4plX9VwXHGGikbI6RjkR
        +aP7y00xGh0LH3wUt7Cs+mY=
X-Google-Smtp-Source: APXvYqxlHSnuR40HD3WfHtCo8IyjnkzIu1nDKB3/VgfCw1ensYkYXwWlMXVkLTgynfwc29N6Bdv1kQ==
X-Received: by 2002:a37:ba44:: with SMTP id k65mr20420998qkf.209.1557717336791;
        Sun, 12 May 2019 20:15:36 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:3c8:56cb:1049:60d2:137b])
        by smtp.gmail.com with ESMTPSA id h16sm4257104qtk.1.2019.05.12.20.15.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 20:15:35 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, anson.huang@nxp.com,
        kernel@pengutronix.de, linux-imx@nxp.com,
        cniedermaier@dh-electronics.com, sebastien.szymanski@armadeus.com,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX
Date:   Mon, 13 May 2019 00:15:31 -0300
Message-Id: <20190513031531.7879-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 1e434b703248 ("ARM: imx: update the cpu power up timing
setting on i.mx6sx") some characters loss is noticed on i.MX6ULL UART
as reported by Christoph Niedermaier.

The intention of such commit was to increase the SW2ISO field for i.MX6SX
only, but since cpuidle-imx6sx is also used on i.MX6UL/i.MX6ULL this caused
unintended side effects on other SoCs.

Fix this problem by keeping the original SW2ISO value for i.MX6UL/i.MX6ULL
and only increase SW2ISO in the i.MX6SX case.

Cc: stable@vger.kernel.org
Fixes: 1e434b703248 ("ARM: imx: update the cpu power up timing setting on i.mx6sx")
Reported-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
---
Changes since v1:
- Simplify the code by using the C ternary operator so that the
patch can be backported all the way to kernel 4.4

 arch/arm/mach-imx/cpuidle-imx6sx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpuidle-imx6sx.c b/arch/arm/mach-imx/cpuidle-imx6sx.c
index fd0053e47a15..4016b717da1b 100644
--- a/arch/arm/mach-imx/cpuidle-imx6sx.c
+++ b/arch/arm/mach-imx/cpuidle-imx6sx.c
@@ -15,6 +15,7 @@
 
 #include "common.h"
 #include "cpuidle.h"
+#include "hardware.h"
 
 static int imx6sx_idle_finish(unsigned long val)
 {
@@ -110,7 +111,7 @@ int __init imx6sx_cpuidle_init(void)
 	 * except for power up sw2iso which need to be
 	 * larger than LDO ramp up time.
 	 */
-	imx_gpc_set_arm_power_up_timing(0xf, 1);
+	imx_gpc_set_arm_power_up_timing(cpu_is_imx6sx() ? 0xf : 0x2, 1);
 	imx_gpc_set_arm_power_down_timing(1, 1);
 
 	return cpuidle_register(&imx6sx_cpuidle_driver, NULL);
-- 
2.17.1

