Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EC31012FA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKSFVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbfKSFVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 709DB22319;
        Tue, 19 Nov 2019 05:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140875;
        bh=r/YU+KvIf+z6ar+xyhrZTY2mGiQKU1TxAIcyDr3xEyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRV5By28tBUUjMraWxWUN6MNK5BCxrnN6nN0TVn08Bx+eVvx/Hhk8fV0kOa9K+8tR
         bUYnuDRFsun1eorWojAIpB7vlhej1zLN486cwiJtu0iVsTQm8IJTkKQDvIuyvQZsij
         cNhOEXHdy+YseeCdBY3T1eH9CA386tmJMVwEFatA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 17/48] ALSA: usb-audio: Fix incorrect size check for processing/extension units
Date:   Tue, 19 Nov 2019 06:19:37 +0100
Message-Id: <20191119051001.355520623@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 976a68f06b2ea49e2ab67a5f84919a8b105db8be upstream.

The recently introduced unit descriptor validation had some bug for
processing and extension units, it counts a bControlSize byte twice so
it expected a bigger size than it should have been.  This seems
resulting in a probe error on a few devices.

Fix the calculation for proper checks of PU and EU.

Fixes: 57f8770620e9 ("ALSA: usb-audio: More validations of descriptor units")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191114165613.7422-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/validate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -81,9 +81,9 @@ static bool validate_processing_unit(con
 	switch (v->protocol) {
 	case UAC_VERSION_1:
 	default:
-		/* bNrChannels, wChannelConfig, iChannelNames, bControlSize */
-		len += 1 + 2 + 1 + 1;
-		if (d->bLength < len) /* bControlSize */
+		/* bNrChannels, wChannelConfig, iChannelNames */
+		len += 1 + 2 + 1;
+		if (d->bLength < len + 1) /* bControlSize */
 			return false;
 		m = hdr[len];
 		len += 1 + m + 1; /* bControlSize, bmControls, iProcessing */


