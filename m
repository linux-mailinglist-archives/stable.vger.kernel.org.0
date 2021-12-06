Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704F1469E6D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385690AbhLFPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377535AbhLFPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56295C09CE44;
        Mon,  6 Dec 2021 07:21:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E74FE61316;
        Mon,  6 Dec 2021 15:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF0EC341C2;
        Mon,  6 Dec 2021 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804097;
        bh=viddXTknhOgEXWS6LJy1v976ezvP6bEIsfD9x355hVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OV7+4Lx58VVOXXEf2hMIOF1rNZbGg9sVfn+8mQXVeFe5YDcg4iNb8m8QuLQPi88Xa
         3V34SBmrqK/DxqexNxfiYI7FBsZroMpPJ8543SRqQYwuc4U+kjjolbC3SVSs6KuIKA
         KQaKQghqDAGn2tyVYrFKSRXbd4ITj/3cKYRAEyD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/207] platform/x86: dell-wmi-descriptor: disable by default
Date:   Mon,  6 Dec 2021 15:54:39 +0100
Message-Id: <20211206145611.078498434@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 0f07c023dcd08ca49b6d3dd018abc7cd56301478 ]

dell-wmi-descriptor only provides symbols to other drivers.
These drivers already select dell-wmi-descriptor when needed.

This fixes an issue where dell-wmi-descriptor is compiled as a module
with localyesconfig on a non-Dell machine.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20211113080551.61860-1-linux@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/Kconfig b/drivers/platform/x86/dell/Kconfig
index 2fffa57e596e4..fe224a54f24c0 100644
--- a/drivers/platform/x86/dell/Kconfig
+++ b/drivers/platform/x86/dell/Kconfig
@@ -187,7 +187,7 @@ config DELL_WMI_AIO
 
 config DELL_WMI_DESCRIPTOR
 	tristate
-	default m
+	default n
 	depends on ACPI_WMI
 
 config DELL_WMI_LED
-- 
2.33.0



