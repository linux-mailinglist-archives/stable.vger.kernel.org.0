Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA576653F32
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 12:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiLVLoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 06:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbiLVLoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 06:44:24 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEE928773
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 03:44:22 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id x11so2408195lfn.0
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 03:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ygg8cCj0qz0zed9Ni0rRxDgu3BA1WKymtQ3VddGBok=;
        b=R2GQaW0Q5fBX6ixCUYu9m2260sTsoElZxWpPz8LVGXEtZ++6ZCiu7BNJ7EfjBk8p8m
         rUVWo0Ywxvpv5q1W3iZtSz3VvzYYISXJF6zQvvfsbnjGkZvYNzHB4whtCFZVkCfAwNtj
         lt9LZ9AM0Ir9/2TEVK+VoF7Nr7Ug0ga5SgYs8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ygg8cCj0qz0zed9Ni0rRxDgu3BA1WKymtQ3VddGBok=;
        b=fYX/UuQrbn5+ghKhgGwyqea4zOjid0RhJAWkEptZI3VM1plDg97F67YwDWrubMFYWz
         C9DvPoWVGi4lD5Mq5/rUZadoaWWzLadDl/Cg69ZKMlnHYhq6O92WI1pnHq4a9LrymtME
         Q01kZeL59tH4sSIqua6o9UDgnDAI5CxU7T6v9LVWNTtLjlvtxnH/S8PAsnsN2wz9I1hg
         2ZmwBhU56EJ63AGpJXk5+r/Y9Pppc5B+i/KG6coEdkykNHB8O79W9SKD/ZvlYfpa+XGb
         9cgNxXWLGwUTnj4VtpmaOnLPtWV2582QBC2mTwWyonr0qMR6uODiHkeH2EucyfED1F9S
         MrCA==
X-Gm-Message-State: AFqh2koVyPxq1UZSnEhknQAvqmkdD70c9HzFUGjpZ6nrLJeCYcwgEVDe
        X/gyzoVbBKX+/SiyW1fd/ckH3w==
X-Google-Smtp-Source: AMrXdXt/Mh5V7Dzux6VZN/xlxRFgwiC+Jy35qwoh4IhMypGqbPz1by2hx5aixOUZqItwr5wXuxhnqA==
X-Received: by 2002:a05:6512:4005:b0:4b5:9183:5ad0 with SMTP id br5-20020a056512400500b004b591835ad0mr3110798lfb.63.1671709461328;
        Thu, 22 Dec 2022 03:44:21 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id c18-20020ac25f72000000b004a2386b8cf5sm43072lfc.215.2022.12.22.03.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 03:44:20 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Lukas Wunner <lukas@wunner.de>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     linux-serial@vger.kernel.org, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 5.15.y v2] serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"
Date:   Thu, 22 Dec 2022 12:44:14 +0100
Message-Id: <20221222114414.1886632-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221220102316.1280393-1-linux@rasmusvillemoes.dk>
References: <20221220102316.1280393-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
driver-specific way") got backported to 5.15.y, there known as
b079d3775237, some hunks were accidentally left out.

In fsl_lpuart.c, this amounts to uart_remove_one_port() being called
in an error path despite uart_add_one_port() not having been called.

In serial_core.c, it is possible that the omission in
uart_suspend_port() is harmless, but the backport did have the
corresponding hunk in uart_resume_port(), it runs counter to the
original commit's intention of

  Skip any invocation of ->set_mctrl() if RS485 is enabled.

and it's certainly better to be aligned with upstream.

Fixes: b079d3775237 ("serial: Deassert Transmit Enable on probe in driver-specific way")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

v2: Also amend uart_suspend_port(), update commit log accordingly.

 drivers/tty/serial/fsl_lpuart.c  | 2 +-
 drivers/tty/serial/serial_core.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 595430aedc0d..fc311df9f1c9 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2784,9 +2784,9 @@ static int lpuart_probe(struct platform_device *pdev)
 	return 0;
 
 failed_irq_request:
-failed_get_rs485:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
+failed_get_rs485:
 failed_reset:
 	lpuart_disable_clks(sport);
 	return ret;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 5f8f0a90ce55..45b721abaa2f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2225,7 +2225,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 
 		spin_lock_irq(&uport->lock);
 		ops->stop_tx(uport);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		ops->stop_rx(uport);
 		spin_unlock_irq(&uport->lock);
 

base-commit: 5827ddaf4534c52d31dd464679a186b41810ef76
-- 
2.37.2

