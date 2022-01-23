Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063B34971F1
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiAWOOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:14:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33490 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiAWOOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:14:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 674AF60C7B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B61C340E2;
        Sun, 23 Jan 2022 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947283;
        bh=um2J3eDO0ugjUIDz1yzwtruvCIjIggSjcBvkhh3Rs+g=;
        h=Subject:To:Cc:From:Date:From;
        b=pKv1r8m/xypFtC9OlQqGbWyYqCsWXvbCDgskA9WZKPxt2/9iV/3GFLClmLXT8033E
         5oB1BQY0SjtWBZ6Md8gI3p/Px2jzRe1rNF7OxEbXXf8OnLVTiZDjvtMz64lqXeshXR
         6KAhjU31uBaL5jWlO8MGJ2b9h8wmmm1b0Jrf51MU=
Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: Fix s2idle failures on certain AMD" failed to apply to 5.16-stable tree
To:     fabriziobertocci@gmail.com, Shyam-sundar.S-k@amd.com,
        hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:14:33 +0100
Message-ID: <1642947273187150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a602f5111fdd3d8a8ea2ac9e61f1c047d9794062 Mon Sep 17 00:00:00 2001
From: Fabrizio Bertocci <fabriziobertocci@gmail.com>
Date: Mon, 29 Nov 2021 23:15:40 -0500
Subject: [PATCH] platform/x86: amd-pmc: Fix s2idle failures on certain AMD
 laptops

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

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index b7e50ed050a8..841c44cd64c2 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -76,7 +76,7 @@
 #define AMD_CPU_ID_CZN			AMD_CPU_ID_RN
 #define AMD_CPU_ID_YC			0x14B5
 
-#define PMC_MSG_DELAY_MIN_US		100
+#define PMC_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
 #define SOC_SUBSYSTEM_IP_MAX	12

