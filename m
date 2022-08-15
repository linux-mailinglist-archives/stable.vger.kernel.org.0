Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4B7594761
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiHOXMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiHOXLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:11:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8C3FA33;
        Mon, 15 Aug 2022 13:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D6FB80EA8;
        Mon, 15 Aug 2022 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E6CC433C1;
        Mon, 15 Aug 2022 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593618;
        bh=2KW1HM963k7v+bwEDDz4Yh4oQrYctMijf1hKLtDHh9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7JtWaZWU8qFPCoSP7VvySJT052Slygkr5KssrSvKPOB5JNzDEhzJJH0wpC6pcsug
         QjpJDnxh4hYAR02NzhzNtvDTYK7ySkmTtUJ9vPVj6Kj/uZtL+BlxvnQXfvtZfPN6Hw
         6Rdx5BJ4VO0uhGAKgcD5n69tuRg/4/fJTX71jCWM=
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
Subject: [PATCH 5.19 0297/1157] thermal/tools/tmon: Include pthread and time headers in tmon.h
Date:   Mon, 15 Aug 2022 19:54:13 +0200
Message-Id: <20220815180451.525116184@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index c9066ec104dd..44d16d778f04 100644
--- a/tools/thermal/tmon/tmon.h
+++ b/tools/thermal/tmon/tmon.h
@@ -27,6 +27,9 @@
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



