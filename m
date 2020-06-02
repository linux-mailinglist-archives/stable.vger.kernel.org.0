Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4771EBD8C
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgFBOB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 10:01:29 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41445 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBOB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 10:01:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id u16so6239239lfl.8;
        Tue, 02 Jun 2020 07:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TsTVRy6VoIywIRL97JtwPjdmIS2xffzmjhoZrIa1AA=;
        b=eOsGiqaPePBg9gD9SVka1Kwq1CpL2OBOyyPJrYxi5m2hYmtOJ/v7bu83HfKBdkLZWc
         oj6mSbMP9vdotQC3eXB6t3hrE0VFnA6P//g1hV3p+uiWHy0Y3KoeFX1aITko7+eUlgWq
         sQSVqU0B/DSxw4QSn1mGUFCRGBHKzxIW0xaUfpnvH7rx3eTMO1tIqDOHi2BYVPlI19jT
         cr9C4gqu2gWSyPjibVvqIXrXbKzhM5rBDrGTp2Pc1Y8YnlMR444FUbSgmiaDK66jVtka
         ImfiBBofIpz4ws2gLKmOnyMvXmKMeIkPV6lMH97mLwdUU6XESQ2ycJX2VteAEFV0qvhc
         s7Og==
X-Gm-Message-State: AOAM5332KyAMv1YJFYfNqibUZfQUJ+OvZbEoFt+fRMNExqTNZe05uzKh
        1vB1yivc31atZcVGCGxU0TM=
X-Google-Smtp-Source: ABdhPJyua9OTdM+nCysSu614tZnmPjAqAmTU6yC4euXIi+HEamZNG2cLy12oe+as8rRKEabuEdEN8g==
X-Received: by 2002:ac2:485a:: with SMTP id 26mr13899122lfy.57.1591106486401;
        Tue, 02 Jun 2020 07:01:26 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id s13sm825849lfp.81.2020.06.02.07.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 07:01:25 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1jg7Ti-0000xz-RD; Tue, 02 Jun 2020 16:01:18 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jslaby@suse.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/4] serial: core: fix broken sysrq port unlock
Date:   Tue,  2 Jun 2020 16:00:56 +0200
Message-Id: <20200602140058.3656-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602140058.3656-1-johan@kernel.org>
References: <20200602140058.3656-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d6e1935819db ("serial: core: Allow processing sysrq at port
unlock time") worked around a circular locking dependency by adding
helpers used to defer sysrq processing to when the port lock was
released.

A later commit unfortunately converted these inline helpers to exported
functions despite the fact that the unlock helper was restoring irq
flags, something which needs to be done in the same function that saved
them (e.g. on SPARC).

Fixes: 8e20fc391711 ("serial_core: Move sysrq functions from header file")
Cc: stable <stable@vger.kernel.org>     # 5.6
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/serial_core.c | 19 -------------------
 include/linux/serial_core.h      | 21 +++++++++++++++++++--
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index edfb7bc14bbf..f6cf9cc4ce69 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3239,25 +3239,6 @@ int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch)
 }
 EXPORT_SYMBOL_GPL(uart_prepare_sysrq_char);
 
-void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long irqflags)
-{
-	int sysrq_ch;
-
-	if (!port->has_sysrq) {
-		spin_unlock_irqrestore(&port->lock, irqflags);
-		return;
-	}
-
-	sysrq_ch = port->sysrq_ch;
-	port->sysrq_ch = 0;
-
-	spin_unlock_irqrestore(&port->lock, irqflags);
-
-	if (sysrq_ch)
-		handle_sysrq(sysrq_ch);
-}
-EXPORT_SYMBOL_GPL(uart_unlock_and_check_sysrq);
-
 /*
  * We do the SysRQ and SAK checking like this...
  */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 1f4443db5474..858c5dd926ad 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -462,8 +462,25 @@ extern void uart_insert_char(struct uart_port *port, unsigned int status,
 
 extern int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch);
 extern int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch);
-extern void uart_unlock_and_check_sysrq(struct uart_port *port,
-					unsigned long irqflags);
+
+static inline void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long irqflags)
+{
+	int sysrq_ch;
+
+	if (!port->has_sysrq) {
+		spin_unlock_irqrestore(&port->lock, irqflags);
+		return;
+	}
+
+	sysrq_ch = port->sysrq_ch;
+	port->sysrq_ch = 0;
+
+	spin_unlock_irqrestore(&port->lock, irqflags);
+
+	if (sysrq_ch)
+		handle_sysrq(sysrq_ch);
+}
+
 extern int uart_handle_break(struct uart_port *port);
 
 /*
-- 
2.26.2

