Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C8F29AD7B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752325AbgJ0NgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:36:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34465 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438830AbgJ0NgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 09:36:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id i1so1979872wro.1;
        Tue, 27 Oct 2020 06:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Su0KydEKTT9poTTNB/IzB7GeLLJi5Ez1axnmVYAjRY=;
        b=dKk5BHcBMbaCUocbuqvlaPNIiBKt04UZzSzF5sNZENe/5cB4uARMEX8ZQwtvf4M5cW
         GgYTDEFkqIZPCXuu9QYasmDRf4+1WVlzqXokje70sjbB88wBep59M5de4KquuVZ63Exh
         lyCIiWziNr2XvB2oXBmt2E1AK6ma5C8mNrVgofqjRJaXAHg/WP7h1x4h9r1Lr98SGd0g
         +8u9e8XjxePN+j9Tl8Tb2y0rfyJv7g+X65cBQ6N3C22yg8j2SLeUJm5dF99X8iZp+T97
         oL/PppBbJf44T2QFLE36zPCWQJfF6qMEFQEnMJwe2bXQJ3BNggmJET8pIIqZTvFjW9U2
         Ah4Q==
X-Gm-Message-State: AOAM532/HBJW1a7oBUzC8vS51aaUz91fqmF8oK9okvM4NmDgm4Frp+Bc
        gNGlX4KfA4DNh23TczZf2hmE9XFBs7E=
X-Google-Smtp-Source: ABdhPJzyzIcZhNMayFgmK++xvvJ59GKAA71iy0h8ja6RkAEibpBrcNKaGix9lXPbCV1fbqDNWk95ZA==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr2980712wrp.122.1603805782578;
        Tue, 27 Oct 2020 06:36:22 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-36-134-112.cust.vodafonedsl.it. [2.36.134.112])
        by smtp.gmail.com with ESMTPSA id x15sm2218175wrr.36.2020.10.27.06.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:36:22 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] reboot: fix parsing of reboot cpu number
Date:   Tue, 27 Oct 2020 14:35:45 +0100
Message-Id: <20201027133545.58625-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027133545.58625-1-mcroce@linux.microsoft.com>
References: <20201027133545.58625-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The kernel cmdline reboot= argument allows to specify the CPU used
for rebooting, with the syntax `s####` among the other flags, e.g.

  reboot=soft,s4
  reboot=warm,s31,force

In the early days the parsing was done with simple_strtoul(), later
deprecated in favor of the safer kstrtoint() which handles overflow.

But kstrtoint() returns -EINVAL if there are non-digit characters
in a string, so if this flag is not the last given, it's silently
ignored as well as the subsequent ones.

To fix it, revert the usage of simple_strtoul(), which is no longer
deprecated, and restore the old behaviour.

While at it, merge two identical code blocks into one.

Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 kernel/reboot.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index c4e7965c39b9..a09c5937c0b6 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -552,25 +552,19 @@ static int __init reboot_setup(char *str)
 
 		case 's':
 		{
-			int rc;
-
-			if (isdigit(*(str+1))) {
-				rc = kstrtoint(str+1, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-				if (reboot_cpu >= num_possible_cpus()) {
-					reboot_cpu = 0;
-					return -ERANGE;
-				}
-			} else if (str[1] == 'm' && str[2] == 'p' &&
-				   isdigit(*(str+3))) {
-				rc = kstrtoint(str+3, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-				if (reboot_cpu >= num_possible_cpus()) {
-					reboot_cpu = 0;
+			int cpu;
+
+			/*
+			 * reboot_cpu is s[mp]#### with #### being the processor
+			 * to be used for rebooting. Skip 's' or 'smp' prefix.
+			 */
+			str += str[1] == 'm' && str[2] == 'p' ? 3 : 1;
+
+			if (isdigit(str[0])) {
+				cpu = simple_strtoul(str, NULL, 0);
+				if (cpu >= num_possible_cpus())
 					return -ERANGE;
-				}
+				reboot_cpu = cpu;
 			} else
 				*mode = REBOOT_SOFT;
 			break;
-- 
2.28.0

