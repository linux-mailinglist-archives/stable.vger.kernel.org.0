Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E5226338D
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgIIRFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 13:05:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43031 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgIIPnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 11:43:09 -0400
Received: by mail-lj1-f196.google.com with SMTP id u4so4129289ljd.10;
        Wed, 09 Sep 2020 08:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbZsg6zJ9YzguB6nUiWhHT7YZ4ojzslnf2Tm9G1IUuk=;
        b=RRZvhfOmZjPXeOoSewPmfTLRGlgj3Q+lfz6Tu73WDmMilhIlROcIyUTP3Yt/OrPgI3
         nurEIkz+GV5w/+3j4nKYK18YylMKeXs69LdFOlxSDVoOwsAgpqrar7B26/XDM5takrB8
         khk9MBrQUl7jHEL2Zvm4m9/apEkXZIn1+NVrmuEfJJe8SeV+f4YEuVaN/AE8DrdsPfhk
         qZIpKiZIlUBVHxNa8aalgc5VcBl2aZW9OtQxao3maAfh4xS2Ik7APp6cEJ4WrSog4G/Z
         83h0dx0fmI6AP3bE8ZnnjMiSbQMFH1/6Twoib90IE8sPL8kuWpT+DXIyZ7DVUAqK/4J+
         ThVw==
X-Gm-Message-State: AOAM530OtwjqgkDg90Rd/lSwx5tANZOaSJ92OeHVNj4UGfur33vYZL7B
        Hp8a33tpXHfaSmOl33Z2H8YESKS5gFs=
X-Google-Smtp-Source: ABdhPJwS3wrvbRTJ2zVlaE3xujZfh71HbLpExorB/edTGouYaURh6yY6hL4+gTtV9bo8bpSFq7F1lw==
X-Received: by 2002:a2e:141d:: with SMTP id u29mr2062438ljd.243.1599661890371;
        Wed, 09 Sep 2020 07:31:30 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id u9sm514049lju.95.2020.09.09.07.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 07:31:29 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kG18A-000418-UP; Wed, 09 Sep 2020 16:31:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] serial: core: fix port-lock initialisation
Date:   Wed,  9 Sep 2020 16:31:00 +0200
Message-Id: <20200909143101.15389-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909143101.15389-1-johan@kernel.org>
References: <20200909143101.15389-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit f743061a85f5 ("serial: core: Initialise spin lock before use in
uart_configure_port()") tried to work around a breakage introduced by
commit a3cb39d258ef ("serial: core: Allow detach and attach serial
device for console") by adding a second initialisation of the port lock
when registering the port.

As reported by the build robots [1], this doesn't really solve the
regression introduced by the console-detach changes and also adds a
second redundant initialisation of the lock for normal ports.

Start cleaning up this mess by removing the redundant initialisation and
making sure that the port lock is again initialised once-only for ports
that aren't already in use as a console.

[1] https://lore.kernel.org/r/20200802054852.GR23458@shao2-debian

Fixes: f743061a85f5 ("serial: core: Initialise spin lock before use in uart_configure_port()")
Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Cc: stable <stable@vger.kernel.org>     # 5.7
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/serial_core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f797c971cd82..53b79e1fcbc8 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2378,13 +2378,6 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		/* Power up port for set_mctrl() */
 		uart_change_pm(state, UART_PM_STATE_ON);
 
-		/*
-		 * If this driver supports console, and it hasn't been
-		 * successfully registered yet, initialise spin lock for it.
-		 */
-		if (port->cons && !(port->cons->flags & CON_ENABLED))
-			__uart_port_spin_lock_init(port);
-
 		/*
 		 * Ensure that the modem control lines are de-activated.
 		 * keep the DTR setting that is set in uart_set_options()
@@ -2900,7 +2893,12 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 		goto out;
 	}
 
-	uart_port_spin_lock_init(uport);
+	/*
+	 * If this port is in use as a console then the spinlock is already
+	 * initialised.
+	 */
+	if (!uart_console_enabled(uport))
+		__uart_port_spin_lock_init(uport);
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
-- 
2.26.2

