Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04422CFE54
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 20:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgLETYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 14:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgLETYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Dec 2020 14:24:32 -0500
Subject: patch "of: fix linker-section match-table corruption" added to driver-core-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183024;
        bh=rA0fbF60t+DNj+1HhMc4pqbG2H9qpjfUMAGy2d07l5A=;
        h=To:From:Date:From;
        b=tDQgqP2QuRi2gp+5baQoPW62UQtQZFzwlLOZ459a9VzRRj/WE34nA6jH6NU4z7FQo
         xskvPfjZ1Zv9UDb31v5OwoVZXTrH8vyw9xL74UA6Nk43thYd1ju7ZImOIO8jIvB/fU
         Ag58Yd1ELgonSOFPkN4pU3HIdH5kMi1CDv6P25kA=
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Dec 2020 16:44:58 +0100
Message-ID: <1607183098209143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    of: fix linker-section match-table corruption

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 5812b32e01c6d86ba7a84110702b46d8a8531fe9 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 23 Nov 2020 11:23:12 +0100
Subject: of: fix linker-section match-table corruption

Specify type alignment when declaring linker-section match-table entries
to prevent gcc from increasing alignment and corrupting the various
tables with padding (e.g. timers, irqchips, clocks, reserved memory).

This is specifically needed on x86 where gcc (typically) aligns larger
objects like struct of_device_id with static extent on 32-byte
boundaries which at best prevents matching on anything but the first
entry. Specifying alignment when declaring variables suppresses this
optimisation.

Here's a 64-bit example where all entries are corrupt as 16 bytes of
padding has been inserted before the first entry:

	ffffffff8266b4b0 D __clk_of_table
	ffffffff8266b4c0 d __of_table_fixed_factor_clk
	ffffffff8266b5a0 d __of_table_fixed_clk
	ffffffff8266b680 d __clk_of_table_sentinel

And here's a 32-bit example where the 8-byte-aligned table happens to be
placed on a 32-byte boundary so that all but the first entry are corrupt
due to the 28 bytes of padding inserted between entries:

	812b3ec0 D __irqchip_of_table
	812b3ec0 d __of_table_irqchip1
	812b3fa0 d __of_table_irqchip2
	812b4080 d __of_table_irqchip3
	812b4160 d irqchip_of_match_end

Verified on x86 using gcc-9.3 and gcc-4.9 (which uses 64-byte
alignment), and on arm using gcc-7.2.

Note that there are no in-tree users of these tables on x86 currently
(even if they are included in the image).

Fixes: 54196ccbe0ba ("of: consolidate linker section OF match table declarations")
Fixes: f6e916b82022 ("irqchip: add basic infrastructure")
Cc: stable <stable@vger.kernel.org>     # 3.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20201123102319.8090-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/of.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5d51891cbf1a..af655d264f10 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1300,6 +1300,7 @@ static inline int of_get_available_child_count(const struct device_node *np)
 #define _OF_DECLARE(table, name, compat, fn, fn_type)			\
 	static const struct of_device_id __of_table_##name		\
 		__used __section("__" #table "_of_table")		\
+		__aligned(__alignof__(struct of_device_id))		\
 		 = { .compatible = compat,				\
 		     .data = (fn == (fn_type)NULL) ? fn : fn  }
 #else
-- 
2.29.2


