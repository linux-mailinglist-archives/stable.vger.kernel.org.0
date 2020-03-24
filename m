Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE91191414
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 16:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgCXPTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 11:19:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42066 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbgCXPTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 11:19:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id 22so5824223pfa.9;
        Tue, 24 Mar 2020 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n2bDSotzBV6UN70AN/x4Bcm38lByfTVVoEFkAkDjweA=;
        b=OmLhxF9ZFVLR3cLvu2hvEXiJVZLEW9VIbiFqQByCXZuRn/KhUiK2zv6Mvg6sKq+CAg
         q9O1ZbWbHnalD7JeFSzNLz0bFns4QEwF3wbIwXmGHenIFHdCdwCBJ/kSkUbcPgkOF6eA
         EWNaH7YgnVKAh0I0y+BKBhC9I8EC0ErWT2tbJW83d9o6C0u11u5iJuKOoN8X8qbhpcVY
         HXEMgS0GoaNGdRHBf0y7EhGhxlo9tnWob2DeC5SrXiPo1Nt5L1z7W19xy3aCcdVRXVqv
         me/m1TGSk3SAByCWrp0c/q4FY1CmsSj1G+XFMBZLIbHPVdW2jKoBatFr65OFQchzKDlg
         CWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n2bDSotzBV6UN70AN/x4Bcm38lByfTVVoEFkAkDjweA=;
        b=i9CeetRX/r9Bz10clNpaJrJsY83QbLkF9Ile8GOGMj0ZasnY8rLDV7iwlpjq+wIcvZ
         mztmNh+jxNG4oiOM6Xmx5zTnpXNOpFVVBW0QPs1466F2zjMpkSu+PQYg8vOxJy0pBaTS
         9lcy/d1r84onLlyRKGtmABIyZX3QJadSDtaQyQz/Zs5VWu0H9Pv7Y5+2rdSNZeba0Cdd
         PF/BHBPRl6moiL50S2SdRkuyZuBkZeY0f6tNhCCACeAaU/PgoD1qjrGredUsZ20TeqPo
         PtBpxafuShoN6/dEVsaQeg4BP0md6FKzhTtkwSITg6ENuYlV1UISlozD33KpMy4lTs1D
         700w==
X-Gm-Message-State: ANhLgQ2BRtFcF1qBxSgb+H6JGAdPbQflC3X9xoHrAlbOTpUIWRqVBYgT
        qNTfpBsmHSvXkaLMBNPjMhw=
X-Google-Smtp-Source: ADFU+vvDuPBa6Bp3Vi7dqS80D3QlME/zrmJ3O5IWsimloMvVF5/5KG/Vn8rPXGaL7RAM+9AVYlOUdw==
X-Received: by 2002:a63:1e57:: with SMTP id p23mr28693676pgm.316.1585063182250;
        Tue, 24 Mar 2020 08:19:42 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.2.210])
        by smtp.googlemail.com with ESMTPSA id x11sm13807073pgq.48.2020.03.24.08.19.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 08:19:41 -0700 (PDT)
From:   Yubo Xie <ltykernel@gmail.com>
X-Google-Original-From: Yubo Xie <yuboxie@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com
Cc:     Yubo Xie <yuboxie@microsoft.com>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        stable@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong time unit
Date:   Tue, 24 Mar 2020 08:19:35 -0700
Message-Id: <20200324151935.15814-1-yuboxie@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sched clock callback should return time with nano second as unit
but current hv callback returns time with 100ns. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Fixes: adb87ff4f96c ("clocksource/drivers/hyperv: Allocate Hyper-V TSC page statically")
---
 drivers/clocksource/hyperv_timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 9d808d595ca8..662ed978fa24 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
 
 static u64 read_hv_sched_clock_tsc(void)
 {
-	return read_hv_clock_tsc() - hv_sched_clock_offset;
+	return (read_hv_clock_tsc() - hv_sched_clock_offset)
+		* (NSEC_PER_SEC / HV_CLOCK_HZ);
 }
 
 static void suspend_hv_clock_tsc(struct clocksource *arg)
@@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
 
 static u64 read_hv_sched_clock_msr(void)
 {
-	return read_hv_clock_msr() - hv_sched_clock_offset;
+	return (read_hv_clock_msr() - hv_sched_clock_offset)
+		* (NSEC_PER_SEC / HV_CLOCK_HZ);
 }
 
 static struct clocksource hyperv_cs_msr = {
-- 
2.14.5

