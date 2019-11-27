Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF96C10BFD6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfK0VqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727538AbfK0UeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D7D207DD;
        Wed, 27 Nov 2019 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886853;
        bh=7ELU8Vu6+GPSxNfHPinOpipkeIGoboas9zgz5lzP99o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge5uplF8zj8dD4hO+K+xABl7+6vdj5DPF1WFPWEdHNISm1CzE3EEgPYvz+mhjWgPF
         EP7YxnNieHAenISYM3rqVWXhOEj1p65tagYz8JRoKjHcnJrCbW47jY0dsxcfPN3eZX
         3KMqNvtEtikx9COz/1bhgMg7KhUvD695HwC6YwpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 019/132] platform/x86: asus-wmi: add SERIO_I8042 dependency
Date:   Wed, 27 Nov 2019 21:30:10 +0100
Message-Id: <20191127202916.307387184@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ea893695ec1131a5fed0523ff8094bc6e8723bbe ]

A recent bugfix added a call to i8042_install_filter but did
not add the dependency, leading to possible link errors:

drivers/platform/built-in.o: In function `asus_nb_wmi_quirks':
asus-nb-wmi.c:(.text+0x23af): undefined reference to `i8042_install_filter'

This adds a dependency on SERIO_I8042||SERIO_I8042=n to indicate
that we can build the driver when the i8042 driver is disabled,
but it cannot be built-in when that is a loadable module.

Fixes: b5643539b825 ("platform/x86: asus-wmi: Filter buggy scan codes on ASUS Q500A")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 953974b5a9a95..6487453c68b59 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -566,6 +566,7 @@ config ASUS_WMI
 config ASUS_NB_WMI
 	tristate "Asus Notebook WMI Driver"
 	depends on ASUS_WMI
+	depends on SERIO_I8042 || SERIO_I8042 = n
 	---help---
 	  This is a driver for newer Asus notebooks. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
-- 
2.20.1



