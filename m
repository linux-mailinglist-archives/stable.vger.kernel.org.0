Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13D645C68A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354374AbhKXOKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354083AbhKXOGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49E461414;
        Wed, 24 Nov 2021 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759554;
        bh=cNg9cPQa+FFqCxQ0HotEaU3EN3cGa4rFddpf2ofRjSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzLCgFVSgKrDWR3C1o9QO9KIz09GY35KeoLiewAmub5Bv1vHEUZlpWZCJVan/jeYM
         6nz8RlGceSk8JFG3hnaAWmCsZjvS4tbvnk+HLZiAEXLw7qy71Ai5cMOtB/TXRwGFCj
         wGS+ESaUAWYZd90q/8oYRQY6cjH91L833rHTnly8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.15 279/279] x86/Kconfig: Fix an unused variable error in dell-smm-hwmon
Date:   Wed, 24 Nov 2021 12:59:26 +0100
Message-Id: <20211124115728.317530279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit ef775a0e36c6a81c5b07cb228c02f967133fe768 upstream.

When CONFIG_PROC_FS is not set, there is a build warning (turned
into an error):

  ../drivers/hwmon/dell-smm-hwmon.c: In function 'i8k_init_procfs':
  ../drivers/hwmon/dell-smm-hwmon.c:624:24: error: unused variable 'data' [-Werror=unused-variable]
    struct dell_smm_data *data = dev_get_drvdata(dev);

Make I8K depend on PROC_FS and HWMON (instead of selecting HWMON -- it
is strongly preferred to not select entire subsystems).

Build tested in all possible combinations of SENSORS_DELL_SMM, I8K, and
PROC_FS.

Fixes: 039ae58503f3 ("hwmon: Allow to compile dell-smm-hwmon driver without /proc/i8k")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lkml.kernel.org/r/20210910071921.16777-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1256,7 +1256,8 @@ config TOSHIBA
 
 config I8K
 	tristate "Dell i8k legacy laptop support"
-	select HWMON
+	depends on HWMON
+	depends on PROC_FS
 	select SENSORS_DELL_SMM
 	help
 	  This option enables legacy /proc/i8k userspace interface in hwmon


