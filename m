Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84826290B1F
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 20:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391059AbgJPSJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 14:09:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41931 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391056AbgJPSJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 14:09:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id s9so3938815wro.8;
        Fri, 16 Oct 2020 11:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i1B3U/bK42/bH0dAj7w8r7iLYMqlTy117f0Fgmj1z7s=;
        b=JZdRFGdoDigFLJ+EDxD6P25smJm8MaoALXTup39k+HuAOBfUGevTFcSvI6lKAiW1x+
         bU7mdLTQIFm8aCveFIarkz09aw1I8F36UIhroJ7SEBxvG7E7l5dn69rfncw50WhACoYM
         lAebu2cGo9nkElAa3KSUZ84e10ojrWLlWhzbX8wEFaMnPWGENFTNmz9OetUoGovs0kJa
         ZsLTVUEIyikAWUEuxQ7G+9dmxQDDLm5sySOGUzUrh2LEvQ5U3aclx6YoHQ3VbQKLDBjs
         rbczF/EFKzdeTrwGUpSOiNynEZw2pmWAmni5vhHva/QBh5CESOPeo30nbZjEpo1uxEEE
         F9jw==
X-Gm-Message-State: AOAM533GrDbq9lhYNQjraWkYS5TMox9N96YiTNjjHC9E+y8w0EOVwbJs
        I6vZlc/4+TMecEXmXra9SDKkAFuJJ2VI7IBC
X-Google-Smtp-Source: ABdhPJw31xk1B6nfVmHgik/shYbAcJvmexdgZ214yklfA4Z7dQh6M76Idw+xSeX/9Gps3bhF9zw60w==
X-Received: by 2002:adf:e88a:: with SMTP id d10mr5601850wrm.247.1602871773067;
        Fri, 16 Oct 2020 11:09:33 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-36-134-112.cust.vodafonedsl.it. [2.36.134.112])
        by smtp.gmail.com with ESMTPSA id x1sm4369260wrl.41.2020.10.16.11.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 11:09:32 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: [PATCH 2/2] reboot: fix parsing of reboot cpu number
Date:   Fri, 16 Oct 2020 20:09:07 +0200
Message-Id: <20201016180907.171957-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016180907.171957-1-mcroce@linux.microsoft.com>
References: <20201016180907.171957-1-mcroce@linux.microsoft.com>
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
index c4e7965c39b9..475f790bbd75 100644
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
+				cpu = simple_strtoul(str, NULL, 10);
+				if (cpu >= num_possible_cpus())
 					return -ERANGE;
-				}
+				reboot_cpu = cpu;
 			} else
 				*mode = REBOOT_SOFT;
 			break;
-- 
2.26.2

