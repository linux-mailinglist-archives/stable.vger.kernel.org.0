Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555946A687F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 08:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCAH7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 02:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCAH7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 02:59:44 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AF2222F7
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 23:59:43 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id b13so13048389ljf.6
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 23:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1677657581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bA7nt4VKDa+62lfIEzrNwx8iY9x2ZjNkaV9QCRTZ5/M=;
        b=Z0resYFKm/zwiRxf7dvMgqn8Sg8ExqwFPNjZ9+/6O/Co8Svyz5xRsqlReabbJIjyon
         JFBBoYHAlIt9TH6xmTaLa0rhejyK9OkZvWVrsA8e5hgPhqYpRPsUtoLBqR/SNhgPqNA1
         fgkV2Vf2twXfrqUY1apus6ubbHVCvlpcFrx8xlobdatRP4aop9gwpPlUbAmAfuI6n/Rw
         MqMHCPUqiqcyScUV6KsRDvIH3ixZiQ8/IhclKeQ7fZTPATYf8U1PfLo9VSM1+oY/5CAm
         VjJBgccnKjGTGNg9SvABERPeOJdIFrqZQ1G8/+vLaDBVMEKK+kCmpAsGzjuvfTuTfRdc
         rpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677657581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bA7nt4VKDa+62lfIEzrNwx8iY9x2ZjNkaV9QCRTZ5/M=;
        b=TLQ818JB7DyWcIUybA//4a1amh/z/gtgA2c8bCQ3nQ0pXX7PrExbfVPEn/2F2QYMeg
         vCtrcCCBu/grRyEsXHIeDMExgjr2bAsTJpV6Gwmpp394l5566hLVvHM1/rgbMittEyvB
         JWbeEIFaDgbM/773wY0ECsAD+YEmV7N/2zpf8HqxqDKEtkSZQUr+3x0loAmP6BtQKFtU
         kTMoHoyPreIAi9bK6+gcBbABphxYqV1MByVJwgPQpJckLQnE+BZRXNqK7xzg/CxG9LuJ
         eniZxqXc4aNBp35rKKLkHcCvjk9CzlYvT3vSdXCJ7lS9bFnQQwsCCkx6uQObyVE4t96t
         mq2g==
X-Gm-Message-State: AO0yUKV/qwxxAqOQhFsyT1U4IXhTmo7ymBgBejjGDQmh3TZzIpM+eff/
        dzI+CPEzGaeNXXY2hj6EOlvdj6K4Kh243X7P
X-Google-Smtp-Source: AK7set/Rr8rGFuYqZf3NksYhKA4pQQPbk9F61v/Cqyf4oCoQ2ULFuK24NUohQIeVpam0A6KTMQJ7fQ==
X-Received: by 2002:a2e:9cd9:0:b0:295:ad91:8811 with SMTP id g25-20020a2e9cd9000000b00295ad918811mr1738540ljj.36.1677657581421;
        Tue, 28 Feb 2023 23:59:41 -0800 (PST)
Received: from lmajczak1-l.roam.corp.google.com ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id n9-20020a056512388900b004caf992bba9sm1631515lft.268.2023.02.28.23.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 23:59:41 -0800 (PST)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Guenter Roeck <groeck@chromium.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, upstream@semihalf.com,
        Lukasz Majczak <lma@semihalf.com>, stable@vger.kernel.org
Subject: [PATCH] serial: core: fix broken console after suspend
Date:   Wed,  1 Mar 2023 08:57:51 +0100
Message-Id: <20230301075751.43839-1-lma@semihalf.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
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

Re-enable the console device after suspending, causes its cflags,
ispeed and ospeed to be set anew, basing on the values stored in
uport->cons. The issue is that these values are set only once,
when parsing console parameters after boot (see uart_set_options()),
next after configuring a port in uart_port_startup() these parameteres
(cflags, ispeed and ospeed) are copied to termios structure and
the orginal one (stored in uport->cons) are cleared, but there is no place
in code where those fields are checked against 0.
When kernel calls uart_resume_port() and setups console, it copies cflags,
ispeed and ospeed values from uart->cons,but those are alread cleared.
The efect is that console is broken.
This patch address this by preserving the cflags, ispeed and
ospeed fields in uart->cons during uart_port_startup().

Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Cc: stable@vger.kernel.org
---
 drivers/tty/serial/serial_core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2bd32c8ece39..394a05c09d87 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 			tty->termios.c_cflag = uport->cons->cflag;
 			tty->termios.c_ispeed = uport->cons->ispeed;
 			tty->termios.c_ospeed = uport->cons->ospeed;
-			uport->cons->cflag = 0;
-			uport->cons->ispeed = 0;
-			uport->cons->ospeed = 0;
 		}
 		/*
 		 * Initialise the hardware port settings.
-- 
2.39.2.722.g9855ee24e9-goog

