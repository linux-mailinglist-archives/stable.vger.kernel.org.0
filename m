Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EEB716C2
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 13:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbfGWLMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 07:12:02 -0400
Received: from condef-10.nifty.com ([202.248.20.75]:53121 "EHLO
        condef-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfGWLMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 07:12:02 -0400
Received: from conuserg-12.nifty.com ([10.126.8.75])by condef-10.nifty.com with ESMTP id x6NBAAD7029643
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 20:10:10 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x6NB9kOf031858;
        Tue, 23 Jul 2019 20:09:47 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x6NB9kOf031858
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1563880187;
        bh=H0xKH8XYyw1pLSpni1NwGuzWDnIGeDUTkgKs4VWfmIQ=;
        h=From:To:Cc:Subject:Date:From;
        b=wevNmvch3JKbBo4fiwTB+Sjsud33OoIqdIF6JnrFH4ZPJF+H8yhrdVUItvF126xwE
         3RdC4xVDxKx8ABX4T7gxdgmuov88JNNklltgOlwSsS/21yOCezF34pqw2XBLM79km8
         yO7sBGfMm4rReCyQZtw0pn/OYh9N9fMrPWcYPG0CVkNEIsEQEQ/38cm/7Ub6poC4A+
         3QVX509hG4MqTjL+ww0VR3FFYqelO+LPUv6OWADg2JxcTppPnWGBsWB+kqMz+yGb0s
         +BH7y2/sgdXC3Z4Zpj90uvJhp8a8Qv61P2s2otCwZ+qRdrIzllkw090MEba5vK2NzR
         lGdUqMEJxkFWQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 4.19] kconfig: fix missing choice values in auto.conf
Date:   Tue, 23 Jul 2019 20:09:36 +0900
Message-Id: <20190723110936.13159-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8e2442a5f86e1f77b86401fce274a7f622740bc4 upstream.

Since commit 00c864f8903d ("kconfig: allow all config targets to write
auto.conf if missing"), Kconfig creates include/config/auto.conf in the
defconfig stage when it is missing.

Joonas Kylmälä reported incorrect auto.conf generation under some
circumstances.

To reproduce it, apply the following diff:

|  --- a/arch/arm/configs/imx_v6_v7_defconfig
|  +++ b/arch/arm/configs/imx_v6_v7_defconfig
|  @@ -345,14 +345,7 @@ CONFIG_USB_CONFIGFS_F_MIDI=y
|   CONFIG_USB_CONFIGFS_F_HID=y
|   CONFIG_USB_CONFIGFS_F_UVC=y
|   CONFIG_USB_CONFIGFS_F_PRINTER=y
|  -CONFIG_USB_ZERO=m
|  -CONFIG_USB_AUDIO=m
|  -CONFIG_USB_ETH=m
|  -CONFIG_USB_G_NCM=m
|  -CONFIG_USB_GADGETFS=m
|  -CONFIG_USB_FUNCTIONFS=m
|  -CONFIG_USB_MASS_STORAGE=m
|  -CONFIG_USB_G_SERIAL=m
|  +CONFIG_USB_FUNCTIONFS=y
|   CONFIG_MMC=y
|   CONFIG_MMC_SDHCI=y
|   CONFIG_MMC_SDHCI_PLTFM=y

And then, run:

$ make ARCH=arm mrproper imx_v6_v7_defconfig

You will see CONFIG_USB_FUNCTIONFS=y is correctly contained in the
.config, but not in the auto.conf.

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

It is crazy to repeat set and unset of internal flags. However, we
cannot simply get rid of "sym->flags &= flags | ~SYMBOL_DEF_USER;"
Doing so would re-introduce the problem solved by commit 5d09598d488f
("kconfig: fix new choices being skipped upon config update").

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
Tested-by: Joonas Kylmälä <joonas.kylmala@iki.fi>
---
 scripts/kconfig/confdata.c | 7 +++----
 scripts/kconfig/expr.h     | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 91d0a5c014ac..fd99ae90a618 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -834,11 +834,12 @@ int conf_write(const char *name)
 				     "#\n"
 				     "# %s\n"
 				     "#\n", str);
-		} else if (!(sym->flags & SYMBOL_CHOICE)) {
+		} else if (!(sym->flags & SYMBOL_CHOICE) &&
+			   !(sym->flags & SYMBOL_WRITTEN)) {
 			sym_calc_value(sym);
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
-			sym->flags &= ~SYMBOL_WRITE;
+			sym->flags |= SYMBOL_WRITTEN;
 
 			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
 		}
@@ -1024,8 +1025,6 @@ int conf_write_autoconf(int overwrite)
 	if (!overwrite && is_present(autoconf_name))
 		return 0;
 
-	sym_clear_all_valid();
-
 	conf_write_dep("include/config/auto.conf.cmd");
 
 	if (conf_split_config())
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 7c329e179007..43a87f8ea738 100644
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

