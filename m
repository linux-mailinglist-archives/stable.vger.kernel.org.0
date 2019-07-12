Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75274666E2
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 08:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbfGLGUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 02:20:20 -0400
Received: from condef-05.nifty.com ([202.248.20.70]:20673 "EHLO
        condef-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfGLGUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 02:20:20 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jul 2019 02:20:18 EDT
Received: from conuserg-09.nifty.com ([10.126.8.72])by condef-05.nifty.com with ESMTP id x6C68cOu025512
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 15:08:42 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id x6C67CGj006351;
        Fri, 12 Jul 2019 15:07:13 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com x6C67CGj006351
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1562911633;
        bh=DNuQzHn+OIKUIOau4E/Lk/DJbbhem5IcUbtMTebzYys=;
        h=From:To:Cc:Subject:Date:From;
        b=njop8InNKgrhUWeNEiLlitdYGHFbavRnEoEQcMaiP5MNjiH4JD48I/rK7M5zch6KE
         eRE+Rp58omN412mkPEZZI1uQrwpnlatT0uh7k14YdhFfOhSBV5U/tjMF4eElfPGH5d
         j0Dy+A9ze1wmEXnEecZS8Wastnd/xM7dQIdoftowzq5K8fpZAjzOanoY2rfpd6za6s
         0qtA+rEkodL9x/VoAVwc1gZbCFPEIyvUHQfJencJjasSM0cpMFxhYYfwmDSBoNXodA
         odqfqq/LfffTsAcSS0tR/1bGWcxOL65AzRbjwbXl7hRbl8rVThMoXOwurJrKwflb0Z
         tLxH0s0hCZO4g==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     =?UTF-8?q?Joonas=20Kylm=8F=AB=A3l=8F=AB=A3?= 
        <joonas.kylmala@iki.fi>, Ulf Magnusson <ulfalizer@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: fix missing choice values in auto.conf
Date:   Fri, 12 Jul 2019 15:07:09 +0900
Message-Id: <20190712060709.20609-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 00c864f8903d ("kconfig: allow all config targets to write
auto.conf if missing"), Kconfig creates include/config/auto.conf in the
defconfig stage when it is missing.

Joonas Kylmälä reported incorrect auto.conf generation under some
circumstances.

Apply the following diff:

| --- a/arch/arm/configs/imx_v6_v7_defconfig
| +++ b/arch/arm/configs/imx_v6_v7_defconfig
| @@ -345,14 +345,7 @@ CONFIG_USB_CONFIGFS_F_MIDI=y
|  CONFIG_USB_CONFIGFS_F_HID=y
|  CONFIG_USB_CONFIGFS_F_UVC=y
|  CONFIG_USB_CONFIGFS_F_PRINTER=y
| -CONFIG_USB_ZERO=m
| -CONFIG_USB_AUDIO=m
| -CONFIG_USB_ETH=m
| -CONFIG_USB_G_NCM=m
| -CONFIG_USB_GADGETFS=m
| -CONFIG_USB_FUNCTIONFS=m
| -CONFIG_USB_MASS_STORAGE=m
| -CONFIG_USB_G_SERIAL=m
| +CONFIG_USB_FUNCTIONFS=y
|  CONFIG_MMC=y
|  CONFIG_MMC_SDHCI=y
|  CONFIG_MMC_SDHCI_PLTFM=y

And then, run:

$ make ARCH=arm mrproper imx_v6_v7_defconfig

CONFIG_USB_FUNCTIONFS=y is correctly contained in the .config, but not
in the auto.conf.

Please note drivers/usb/gadget/legacy/Kconfig is included from a choice
block in drivers/usb/gadget/Kconfig. So USB_FUNCTIONFS is a choice value.

This is probably a similar situation described in commit beaaddb62540
("kconfig: tests: test defconfig when two choices interact").

When sym_calc_choice() is called, the choice symbol forgets the
SYMBOL_DEF_USER unless all of its choice values are explicitly set by
the user.

The choice symbol is given just one chance to recall it because
set_all_choice_values() is called if SYMBOL_NEED_SET_CHOICE_VALUES
is set.

When sym_calc_choice() is called again, the choice symbol forgets it
forever, since SYMBOL_NEED_SET_CHOICE_VALUES is a one-time aid.
Hence, we cannot call sym_clear_all_valid() again and again.

It is crazy to set and clear internal flags. However, we cannot simply
get rid of "sym->flags &= flags | ~SYMBOL_DEF_USER;" Doing so would
re-introduce the problem solved by commit 5d09598d488f ("kconfig: fix
new choices being skipped upon config update").

To work around the issue, conf_write_autoconf() stopped calling
sym_clear_all_valid().

conf_write() must be changed accordingly. Currently, it clears
SYMBOL_WRITE after the symbol is written into the .config file. This
is needed to prevent it from writing the same symbol multiple times in
case the symbol is declared in two or more locations. I added the new
flag SYMBOL_WRITTEN, to track the symbols that have been written.

Anyway, this is a cheesy workaround in order to suppress the issue
as far as defconfig is concerned.

Handling of choices is totally broken. sym_clear_all_valid() is called
every time a user touches a symbol from the GUI interface. To reproduce
it, just add a new symbol drivers/usb/gadget/legacy/Kconfig, then touch
around unrelated symbols from menuconfig. USB_FUNCTIONFS will disappear
from the .config file.

I added the Fixes tag since it is more fatal than before. But, this
has been broken since long long time before, and still it is.
We should take a closer look to fix this correctly somehow.

Fixes: 00c864f8903d ("kconfig: allow all config targets to write auto.conf if missing")
Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Reported-by: Joonas Kylmälä <joonas.kylmala@iki.fi>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 scripts/kconfig/confdata.c | 7 +++----
 scripts/kconfig/expr.h     | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index cbb6efa4a5a6..e0972b255aac 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -895,7 +895,8 @@ int conf_write(const char *name)
 				     "# %s\n"
 				     "#\n", str);
 			need_newline = false;
-		} else if (!(sym->flags & SYMBOL_CHOICE)) {
+		} else if (!(sym->flags & SYMBOL_CHOICE) &&
+			   !(sym->flags & SYMBOL_WRITTEN)) {
 			sym_calc_value(sym);
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
@@ -903,7 +904,7 @@ int conf_write(const char *name)
 				fprintf(out, "\n");
 				need_newline = false;
 			}
-			sym->flags &= ~SYMBOL_WRITE;
+			sym->flags |= SYMBOL_WRITTEN;
 			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
 		}
 
@@ -1063,8 +1064,6 @@ int conf_write_autoconf(int overwrite)
 	if (!overwrite && is_present(autoconf_name))
 		return 0;
 
-	sym_clear_all_valid();
-
 	conf_write_dep("include/config/auto.conf.cmd");
 
 	if (conf_touch_deps())
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 8dde65bc3165..017843c9a4f4 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -141,6 +141,7 @@ struct symbol {
 #define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
 #define SYMBOL_WRITE      0x0200  /* write symbol to file (KCONFIG_CONFIG) */
 #define SYMBOL_CHANGED    0x0400  /* ? */
+#define SYMBOL_WRITTEN    0x0800  /* track info to avoid double-write to .config */
 #define SYMBOL_NO_WRITE   0x1000  /* Symbol for internal use only; it will not be written */
 #define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
 #define SYMBOL_WARNED     0x8000  /* warning has been issued */
-- 
2.17.1

