Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2436F1C3CF6
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 16:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgEDO1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbgEDO1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 10:27:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB008C061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 07:27:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u16so9300733wmc.5
        for <stable@vger.kernel.org>; Mon, 04 May 2020 07:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R8hMysgCANDxPI0D+IpQRpi6VaDo+fsmsuFYs+cuTuA=;
        b=sCyOY7cWz+Zih2Gcur3hgcfiu3oSiZBTIp0cZmq5uKEDB6IrRn9BCNvLxR0Y2FnQ75
         J/sWlpL8ZM/H2nEmr1COYKz40Odhyre7AgPfsXQpuO/yVTvFrL7svixV/hPPXLFe76NL
         a5ZxjdqpicIx5Ol0TULum1FfemlP16K3/LeIY6MvaApt2ME7+3l3YC+1xxuqIB3+2AXc
         RgQkc912evPAICrllpKV+xm0uyGmeiHBUw2pviROwFNmFGQMeMlbHDH+To1RM+10fxCp
         PtzF1sTkIAtzaTNVqC2EXQGruoXv5gwMTh5A5y1Jlrv5srccEch/nFZZN7jXn7v8L8r6
         FHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=R8hMysgCANDxPI0D+IpQRpi6VaDo+fsmsuFYs+cuTuA=;
        b=OdlJdADKW6ggPvNTb9dXbh1DnGjSBHIF32b7nfjq/jO1dH2Pn3Az2yxsemTujzvYN/
         RLn5wiVZPV0HXyXVJ1dhzUkFFpJvqbmXrMA0AhaDC7DqcgJDY+EqeW5oGwH1b1KXYyhQ
         P8ns6UF3NXqxuu5DvDCPVtOc6YBtbfVvTyGcoBwvWz/nIwmLCmk74EhFJ6gszIW0ia+t
         wnDhk35SK4+BYmYL2NesQlxc3UmF2SafL5JOra0BgvrZKJNtnzWL7WGuIjaAIWIH2cP3
         /xwIHe4+ZhGw3AbKEkr7A9gWE1nCy8/5ts4mmN7QP3FZntZgvbhrX7XbPJr6Z1M0HAMH
         fTiA==
X-Gm-Message-State: AGi0PuamDqgHuY7BHz1i7VXPhotjPlX5KZFwM0v0cf98lq8JQD1j+AnB
        bLe7xR8Q6eZKpGNt3Mg/rKw1Fw==
X-Google-Smtp-Source: APiQypJvPehbbUthQvX9YGeEq+Ipj4rzULCq/PSfWLN7t0/wgJVu4JxunEJ5TD5rohgmepaA63orXw==
X-Received: by 2002:a1c:1bcb:: with SMTP id b194mr15744884wmb.4.1588602450462;
        Mon, 04 May 2020 07:27:30 -0700 (PDT)
Received: from localhost (nat-35.starnet.cz. [178.255.168.35])
        by smtp.gmail.com with ESMTPSA id g6sm19438716wrw.34.2020.05.04.07.27.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 07:27:29 -0700 (PDT)
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com, stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [PATCH v2] tty: xilinx_uartps: Fix missing id assignment to the console
Date:   Mon,  4 May 2020 16:27:28 +0200
Message-Id: <ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

When serial console has been assigned to ttyPS1 (which is serial1 alias)
console index is not updated property and pointing to index -1 (statically
initialized) which ends up in situation where nothing has been printed on
the port.

The commit 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console
and driver structures"") didn't contain this line which was removed by
accident.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2:
- Do better commit description
- Origin subject was "tty: xilinx_uartps: Add the id to the console"

Greg: Would be good if you can take this patch to 5.7 and also to stable
trees.

---
 drivers/tty/serial/xilinx_uartps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 672cfa075e28..b9d672af8b65 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1465,6 +1465,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 		cdns_uart_uart_driver.cons = &cdns_uart_console;
+		cdns_uart_console.index = id;
 #endif
 
 		rc = uart_register_driver(&cdns_uart_uart_driver);
-- 
2.26.2

