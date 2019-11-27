Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C1410BBEA
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbfK0VQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387469AbfK0VNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8702176D;
        Wed, 27 Nov 2019 21:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889210;
        bh=9RpqjVaDkw21znGwaR35XGWEXFWeKPABmjsg6rBpPiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGDcBaUjx5aPgjC4qAaoiuThXz9imRX5IjJj9cpUGe3noy/+uDKtiYkkDSzqs8r8A
         WeurW3S8t1OFCstSFhvNYux+UzKSU1vznvh4dtHjATITRWVL+Hclbs6Md4cj+ON1Kl
         EJqCx9UTbju6KQ+kE7m+7yXY0klNhT8yEdorGhQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Alex Fellows <alex.fellows@gmail.com>,
        Markus Schroetter <project.m.schroetter@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 30/66] ALSA: usb-audio: Fix Scarlett 6i6 Gen 2 port data
Date:   Wed, 27 Nov 2019 21:32:25 +0100
Message-Id: <20191127202702.937992844@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

commit ce3cba788a1b7b8aed9380c3035d9e850884bd2d upstream.

The s6i6_gen2_info.ports[] array had the Mixer and PCM port type
entries in the wrong place. Use designators to explicitly specify the
array elements being set.

Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Tested-by: Alex Fellows <alex.fellows@gmail.com>
Tested-by: Markus Schroetter <project.m.schroetter@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191110134356.GA31589@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_scarlett_gen2.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -261,34 +261,34 @@ static const struct scarlett2_device_inf
 	},
 
 	.ports = {
-		{
+		[SCARLETT2_PORT_TYPE_NONE] = {
 			.id = 0x000,
 			.num = { 1, 0, 8, 8, 8 },
 			.src_descr = "Off",
 			.src_num_offset = 0,
 		},
-		{
+		[SCARLETT2_PORT_TYPE_ANALOGUE] = {
 			.id = 0x080,
 			.num = { 4, 4, 4, 4, 4 },
 			.src_descr = "Analogue %d",
 			.src_num_offset = 1,
 			.dst_descr = "Analogue Output %02d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_SPDIF] = {
 			.id = 0x180,
 			.num = { 2, 2, 2, 2, 2 },
 			.src_descr = "S/PDIF %d",
 			.src_num_offset = 1,
 			.dst_descr = "S/PDIF Output %d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_MIX] = {
 			.id = 0x300,
 			.num = { 10, 18, 18, 18, 18 },
 			.src_descr = "Mix %c",
 			.src_num_offset = 65,
 			.dst_descr = "Mixer Input %02d Capture"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_PCM] = {
 			.id = 0x600,
 			.num = { 6, 6, 6, 6, 6 },
 			.src_descr = "PCM %d",
@@ -317,44 +317,44 @@ static const struct scarlett2_device_inf
 	},
 
 	.ports = {
-		{
+		[SCARLETT2_PORT_TYPE_NONE] = {
 			.id = 0x000,
 			.num = { 1, 0, 8, 8, 4 },
 			.src_descr = "Off",
 			.src_num_offset = 0,
 		},
-		{
+		[SCARLETT2_PORT_TYPE_ANALOGUE] = {
 			.id = 0x080,
 			.num = { 8, 6, 6, 6, 6 },
 			.src_descr = "Analogue %d",
 			.src_num_offset = 1,
 			.dst_descr = "Analogue Output %02d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_SPDIF] = {
+			.id = 0x180,
 			/* S/PDIF outputs aren't available at 192KHz
 			 * but are included in the USB mux I/O
 			 * assignment message anyway
 			 */
-			.id = 0x180,
 			.num = { 2, 2, 2, 2, 2 },
 			.src_descr = "S/PDIF %d",
 			.src_num_offset = 1,
 			.dst_descr = "S/PDIF Output %d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_ADAT] = {
 			.id = 0x200,
 			.num = { 8, 0, 0, 0, 0 },
 			.src_descr = "ADAT %d",
 			.src_num_offset = 1,
 		},
-		{
+		[SCARLETT2_PORT_TYPE_MIX] = {
 			.id = 0x300,
 			.num = { 10, 18, 18, 18, 18 },
 			.src_descr = "Mix %c",
 			.src_num_offset = 65,
 			.dst_descr = "Mixer Input %02d Capture"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_PCM] = {
 			.id = 0x600,
 			.num = { 20, 18, 18, 14, 10 },
 			.src_descr = "PCM %d",
@@ -387,20 +387,20 @@ static const struct scarlett2_device_inf
 	},
 
 	.ports = {
-		{
+		[SCARLETT2_PORT_TYPE_NONE] = {
 			.id = 0x000,
 			.num = { 1, 0, 8, 8, 6 },
 			.src_descr = "Off",
 			.src_num_offset = 0,
 		},
-		{
+		[SCARLETT2_PORT_TYPE_ANALOGUE] = {
 			.id = 0x080,
 			.num = { 8, 10, 10, 10, 10 },
 			.src_descr = "Analogue %d",
 			.src_num_offset = 1,
 			.dst_descr = "Analogue Output %02d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_SPDIF] = {
 			/* S/PDIF outputs aren't available at 192KHz
 			 * but are included in the USB mux I/O
 			 * assignment message anyway
@@ -411,21 +411,21 @@ static const struct scarlett2_device_inf
 			.src_num_offset = 1,
 			.dst_descr = "S/PDIF Output %d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_ADAT] = {
 			.id = 0x200,
 			.num = { 8, 8, 8, 4, 0 },
 			.src_descr = "ADAT %d",
 			.src_num_offset = 1,
 			.dst_descr = "ADAT Output %d Playback"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_MIX] = {
 			.id = 0x300,
 			.num = { 10, 18, 18, 18, 18 },
 			.src_descr = "Mix %c",
 			.src_num_offset = 65,
 			.dst_descr = "Mixer Input %02d Capture"
 		},
-		{
+		[SCARLETT2_PORT_TYPE_PCM] = {
 			.id = 0x600,
 			.num = { 20, 18, 18, 14, 10 },
 			.src_descr = "PCM %d",


