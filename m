Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1107259DF82
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353938AbiHWKYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354691AbiHWKWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:22:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3546140;
        Tue, 23 Aug 2022 02:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 806E1B81C53;
        Tue, 23 Aug 2022 09:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B1CC433D6;
        Tue, 23 Aug 2022 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245402;
        bh=xrT7sCDqJzbwaabInFSOooM42pz6YylOw5GrLACf6Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2TBSylCESE11zt+nS1HEoul/g7IBImdu7V8ysLYKX4MRuc3Ul67t4f9wiLdtDW1i
         ch8FriSa9n9bu0J5XEcCAlqJgvOmr/JBb48ltkKLeEBhAnz7eUp8qOfeOGGRX+crPY
         EY+ZXQDPoIF6v1SDR6qXVRE3jLcefQ2M/8Zdgp6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        =?UTF-8?q?Alejandro=20Gonz=C3=A1lez?= 
        <alejandro.gonzalez.correo@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/287] thermal/tools/tmon: Include pthread and time headers in tmon.h
Date:   Tue, 23 Aug 2022 10:23:55 +0200
Message-Id: <20220823080102.455071090@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Mayer <mmayer@broadcom.com>

[ Upstream commit 0cf51bfe999524377fbb71becb583b4ca6d07cfc ]

Include sys/time.h and pthread.h in tmon.h, so that types
"pthread_mutex_t" and "struct timeval tv" are known when tmon.h
references them.

Without these headers, compiling tmon against musl-libc will fail with
these errors:

In file included from sysfs.c:31:0:
tmon.h:47:8: error: unknown type name 'pthread_mutex_t'
 extern pthread_mutex_t input_lock;
        ^~~~~~~~~~~~~~~
make[3]: *** [<builtin>: sysfs.o] Error 1
make[3]: *** Waiting for unfinished jobs....
In file included from tui.c:31:0:
tmon.h:54:17: error: field 'tv' has incomplete type
  struct timeval tv;
                 ^~
make[3]: *** [<builtin>: tui.o] Error 1
make[2]: *** [Makefile:83: tmon] Error 2

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Acked-by: Alejandro González <alejandro.gonzalez.correo@gmail.com>
Tested-by: Alejandro González <alejandro.gonzalez.correo@gmail.com>
Fixes: 94f69966faf8 ("tools/thermal: Introduce tmon, a tool for thermal  subsystem")
Link: https://lore.kernel.org/r/20220718031040.44714-1-f.fainelli@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/thermal/tmon/tmon.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/thermal/tmon/tmon.h b/tools/thermal/tmon/tmon.h
index 9e3c49c547ac..7b090a6c95b6 100644
--- a/tools/thermal/tmon/tmon.h
+++ b/tools/thermal/tmon/tmon.h
@@ -36,6 +36,9 @@
 #define NR_LINES_TZDATA 1
 #define TMON_LOG_FILE "/var/tmp/tmon.log"
 
+#include <sys/time.h>
+#include <pthread.h>
+
 extern unsigned long ticktime;
 extern double time_elapsed;
 extern unsigned long target_temp_user;
-- 
2.35.1



