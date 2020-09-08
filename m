Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B934B261798
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbgIHRhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731691AbgIHQOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7919524909;
        Tue,  8 Sep 2020 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580419;
        bh=be8mms4bynzjUv3v7/LKZ5ue6Mbiq6Mt8ONefCp1C8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/18ivLSqFoQtk/oUVIU5LivBUcw56yYUqcI7YO7fR6+UwNEY5HdpW9bD29ogQQT9
         rmpNPyP0j536X2+Uxk/7a6hC2oLqPvjVmSz/UmvZJTSGLnYoWiqm5BIJdnRnlOX0Mm
         VR4Tt7mIdGxapdrUbP4rKGce6gxnwplxM7yKbtfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Wood <simon@mungewell.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 50/65] ALSA: firewire-digi00x: exclude Avid Adrenaline from detection
Date:   Tue,  8 Sep 2020 17:26:35 +0200
Message-Id: <20200908152219.619119508@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit acd46a6b6de88569654567810acad2b0a0a25cea upstream.

Avid Adrenaline is reported that ALSA firewire-digi00x driver is bound to.
However, as long as he investigated, the design of this model is hardly
similar to the one of Digi 00x family. It's better to exclude the model
from modalias of ALSA firewire-digi00x driver.

This commit changes device entries so that the model is excluded.

$ python3 crpp < ~/git/am-config-rom/misc/avid-adrenaline.img
               ROM header and bus information block
               -----------------------------------------------------------------
400  04203a9c  bus_info_length 4, crc_length 32, crc 15004
404  31333934  bus_name "1394"
408  e064a002  irmc 1, cmc 1, isc 1, bmc 0, cyc_clk_acc 100, max_rec 10 (2048)
40c  00a07e01  company_id 00a07e     |
410  00085257  device_id 0100085257  | EUI-64 00a07e0100085257

               root directory
               -----------------------------------------------------------------
414  0005d08c  directory_length 5, crc 53388
418  0300a07e  vendor
41c  8100000c  --> descriptor leaf at 44c
420  0c008380  node capabilities
424  8d000002  --> eui-64 leaf at 42c
428  d1000004  --> unit directory at 438

               eui-64 leaf at 42c
               -----------------------------------------------------------------
42c  0002410f  leaf_length 2, crc 16655
430  00a07e01  company_id 00a07e     |
434  00085257  device_id 0100085257  | EUI-64 00a07e0100085257

               unit directory at 438
               -----------------------------------------------------------------
438  0004d6c9  directory_length 4, crc 54985
43c  1200a02d  specifier id: 1394 TA
440  13014001  version: Vender Unique and AV/C
444  17000001  model
448  81000009  --> descriptor leaf at 46c

               descriptor leaf at 44c
               -----------------------------------------------------------------
44c  00077205  leaf_length 7, crc 29189
450  00000000  textual descriptor
454  00000000  minimal ASCII
458  41766964  "Avid"
45c  20546563  " Tec"
460  686e6f6c  "hnol"
464  6f677900  "ogy"
468  00000000

               descriptor leaf at 46c
               -----------------------------------------------------------------
46c  000599a5  leaf_length 5, crc 39333
470  00000000  textual descriptor
474  00000000  minimal ASCII
478  41647265  "Adre"
47c  6e616c69  "nali"
480  6e650000  "ne"

Reported-by: Simon Wood <simon@mungewell.org>
Fixes: 9edf723fd858 ("ALSA: firewire-digi00x: add skeleton for Digi 002/003 family")
Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200823075545.56305-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/digi00x/digi00x.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/firewire/digi00x/digi00x.c
+++ b/sound/firewire/digi00x/digi00x.c
@@ -15,6 +15,7 @@ MODULE_LICENSE("GPL v2");
 #define VENDOR_DIGIDESIGN	0x00a07e
 #define MODEL_CONSOLE		0x000001
 #define MODEL_RACK		0x000002
+#define SPEC_VERSION		0x000001
 
 static int name_card(struct snd_dg00x *dg00x)
 {
@@ -185,14 +186,18 @@ static const struct ieee1394_device_id s
 	/* Both of 002/003 use the same ID. */
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_VERSION |
 			       IEEE1394_MATCH_MODEL_ID,
 		.vendor_id = VENDOR_DIGIDESIGN,
+		.version = SPEC_VERSION,
 		.model_id = MODEL_CONSOLE,
 	},
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_VERSION |
 			       IEEE1394_MATCH_MODEL_ID,
 		.vendor_id = VENDOR_DIGIDESIGN,
+		.version = SPEC_VERSION,
 		.model_id = MODEL_RACK,
 	},
 	{}


