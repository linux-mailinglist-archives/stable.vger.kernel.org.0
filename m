Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B23616B1
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfGGTlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57716 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727626AbfGGTiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:13 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0006jJ-Me; Sun, 07 Jul 2019 20:38:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005dE-Bq; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Takashi Sakamoto" <o-takashi@sakamocchi.jp>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.892182903@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 086/129] ALSA: bebob: use more identical mod_alias
 for Saffire Pro 10 I/O against Liquid Saffire 56
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 7dc661bd8d3261053b69e4e2d0050cd1ee540fc1 upstream.

ALSA bebob driver has an entry for Focusrite Saffire Pro 10 I/O. The
entry matches vendor_id in root directory and model_id in unit
directory of configuration ROM for IEEE 1394 bus.

On the other hand, configuration ROM of Focusrite Liquid Saffire 56
has the same vendor_id and model_id. This device is an application of
TCAT Dice (TCD2220 a.k.a Dice Jr.) however ALSA bebob driver can be
bound to it randomly instead of ALSA dice driver. At present, drivers
in ALSA firewire stack can not handle this situation appropriately.

This commit uses more identical mod_alias for Focusrite Saffire Pro 10
I/O in ALSA bebob driver.

$ python2 crpp < /sys/bus/firewire/devices/fw1/config_rom
               ROM header and bus information block
               -----------------------------------------------------------------
400  042a829d  bus_info_length 4, crc_length 42, crc 33437
404  31333934  bus_name "1394"
408  f0649222  irmc 1, cmc 1, isc 1, bmc 1, pmc 0, cyc_clk_acc 100,
               max_rec 9 (1024), max_rom 2, gen 2, spd 2 (S400)
40c  00130e01  company_id 00130e     |
410  000606e0  device_id 01000606e0  | EUI-64 00130e01000606e0

               root directory
               -----------------------------------------------------------------
414  0009d31c  directory_length 9, crc 54044
418  04000014  hardware version
41c  0c0083c0  node capabilities per IEEE 1394
420  0300130e  vendor
424  81000012  --> descriptor leaf at 46c
428  17000006  model
42c  81000016  --> descriptor leaf at 484
430  130120c2  version
434  d1000002  --> unit directory at 43c
438  d4000006  --> dependent info directory at 450

               unit directory at 43c
               -----------------------------------------------------------------
43c  0004707c  directory_length 4, crc 28796
440  1200a02d  specifier id: 1394 TA
444  13010001  version: AV/C
448  17000006  model
44c  81000013  --> descriptor leaf at 498

               dependent info directory at 450
               -----------------------------------------------------------------
450  000637c7  directory_length 6, crc 14279
454  120007f5  specifier id
458  13000001  version
45c  3affffc7  (immediate value)
460  3b100000  (immediate value)
464  3cffffc7  (immediate value)
468  3d600000  (immediate value)

               descriptor leaf at 46c
               -----------------------------------------------------------------
46c  00056f3b  leaf_length 5, crc 28475
470  00000000  textual descriptor
474  00000000  minimal ASCII
478  466f6375  "Focu"
47c  73726974  "srit"
480  65000000  "e"

               descriptor leaf at 484
               -----------------------------------------------------------------
484  0004a165  leaf_length 4, crc 41317
488  00000000  textual descriptor
48c  00000000  minimal ASCII
490  50726f31  "Pro1"
494  30494f00  "0IO"

               descriptor leaf at 498
               -----------------------------------------------------------------
498  0004a165  leaf_length 4, crc 41317
49c  00000000  textual descriptor
4a0  00000000  minimal ASCII
4a4  50726f31  "Pro1"
4a8  30494f00  "0IO"

$ python2 crpp < /sys/bus/firewire/devices/fw1/config_rom
               ROM header and bus information block
               -----------------------------------------------------------------
400  040442e4  bus_info_length 4, crc_length 4, crc 17124
404  31333934  bus_name "1394"
408  e0ff8112  irmc 1, cmc 1, isc 1, bmc 0, pmc 0, cyc_clk_acc 255,
               max_rec 8 (512), max_rom 1, gen 1, spd 2 (S400)
40c  00130e04  company_id 00130e     |
410  018001e9  device_id 04018001e9  | EUI-64 00130e04018001e9

               root directory
               -----------------------------------------------------------------
414  00065612  directory_length 6, crc 22034
418  0300130e  vendor
41c  8100000a  --> descriptor leaf at 444
420  17000006  model
424  8100000e  --> descriptor leaf at 45c
428  0c0087c0  node capabilities per IEEE 1394
42c  d1000001  --> unit directory at 430

               unit directory at 430
               -----------------------------------------------------------------
430  000418a0  directory_length 4, crc 6304
434  1200130e  specifier id
438  13000001  version
43c  17000006  model
440  8100000f  --> descriptor leaf at 47c

               descriptor leaf at 444
               -----------------------------------------------------------------
444  00056f3b  leaf_length 5, crc 28475
448  00000000  textual descriptor
44c  00000000  minimal ASCII
450  466f6375  "Focu"
454  73726974  "srit"
458  65000000  "e"

               descriptor leaf at 45c
               -----------------------------------------------------------------
45c  000762c6  leaf_length 7, crc 25286
460  00000000  textual descriptor
464  00000000  minimal ASCII
468  4c495155  "LIQU"
46c  49445f53  "ID_S"
470  41464649  "AFFI"
474  52455f35  "RE_5"
478  36000000  "6"

               descriptor leaf at 47c
               -----------------------------------------------------------------
47c  000762c6  leaf_length 7, crc 25286
480  00000000  textual descriptor
484  00000000  minimal ASCII
488  4c495155  "LIQU"
48c  49445f53  "ID_S"
490  41464649  "AFFI"
494  52455f35  "RE_5"
498  36000000  "6"

Fixes: 25784ec2d034 ("ALSA: bebob: Add support for Focusrite Saffire/SaffirePro series")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/firewire/bebob/bebob.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -396,7 +396,19 @@ static const struct ieee1394_device_id b
 	/* Focusrite, SaffirePro 26 I/O */
 	SND_BEBOB_DEV_ENTRY(VEN_FOCUSRITE, 0x00000003, &saffirepro_26_spec),
 	/* Focusrite, SaffirePro 10 I/O */
-	SND_BEBOB_DEV_ENTRY(VEN_FOCUSRITE, 0x00000006, &saffirepro_10_spec),
+	{
+		// The combination of vendor_id and model_id is the same as the
+		// same as the one of Liquid Saffire 56.
+		.match_flags	= IEEE1394_MATCH_VENDOR_ID |
+				  IEEE1394_MATCH_MODEL_ID |
+				  IEEE1394_MATCH_SPECIFIER_ID |
+				  IEEE1394_MATCH_VERSION,
+		.vendor_id	= VEN_FOCUSRITE,
+		.model_id	= 0x000006,
+		.specifier_id	= 0x00a02d,
+		.version	= 0x010001,
+		.driver_data	= (kernel_ulong_t)&saffirepro_10_spec,
+	},
 	/* Focusrite, Saffire(no label and LE) */
 	SND_BEBOB_DEV_ENTRY(VEN_FOCUSRITE, MODEL_FOCUSRITE_SAFFIRE_BOTH,
 			    &saffire_spec),

