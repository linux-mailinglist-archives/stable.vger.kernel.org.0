Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5364728CB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhLMKOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbhLMKLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:11:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63325C08ECB3;
        Mon, 13 Dec 2021 01:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEF20CE0E6F;
        Mon, 13 Dec 2021 09:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55894C34603;
        Mon, 13 Dec 2021 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389239;
        bh=6UikLrr2zxxoqQxCmqJ8iOfr3jCOlMDSVw6reSBi2Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6FTpsw4ZohhsJjmevfWaMXw94YNnNXjxao5IlKPv+PgjyT45HST5eCLrsdtGryTy
         +v560XpuAnsIwXi2xkxr7GVBPkxvx8YDnydBDpd/rtWO3G9mixlgg0y25Oww80BrkV
         PbrOhsvofSzq1JlG6ztIQhbPawWTjmZUaXE78yMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Fabrizio Bertocci <fabriziobertocci@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 032/171] platform/x86: amd-pmc: Fix s2idle failures on certain AMD laptops
Date:   Mon, 13 Dec 2021 10:29:07 +0100
Message-Id: <20211213092946.145020824@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrizio Bertocci <fabriziobertocci@gmail.com>

commit 49201b90af818654c5506a0decc18e111eadcb66 upstream.

On some AMD hardware laptops, the system fails communicating with the
PMC when entering s2idle and the machine is battery powered.

Hardware description: HP Pavilion Aero Laptop 13-be0097nr
CPU: AMD Ryzen 7 5800U with Radeon Graphics
GPU: 03:00.0 VGA compatible controller [0300]: Advanced Micro Devices,
Inc. [AMD/ATI] Device [1002:1638] (rev c1)

Detailed description of the problem (and investigation) here:
https://gitlab.freedesktop.org/drm/amd/-/issues/1799

Patch is a single line: reduce the polling delay in half, from 100uSec
to 50uSec when waiting for a change in state from the PMC after a
write command operation.

After changing the delay, I did not see a single failure on this
machine (I have this fix for now more than one week and s2idle worked
every single time on battery power).

Cc: stable@vger.kernel.org
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Fabrizio Bertocci <fabriziobertocci@gmail.com>
Link: https://lore.kernel.org/r/CADtzkx7TdfbwtaVEXUdD6YXPey52E-nZVQNs+Z41DTx7gqMqtw@mail.gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -70,7 +70,7 @@
 #define AMD_CPU_ID_CZN			AMD_CPU_ID_RN
 #define AMD_CPU_ID_YC			0x14B5
 
-#define PMC_MSG_DELAY_MIN_US		100
+#define PMC_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
 #define SOC_SUBSYSTEM_IP_MAX	12


