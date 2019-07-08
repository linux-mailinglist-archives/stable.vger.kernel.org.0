Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89376233B
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390334AbfGHPdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390347AbfGHPdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F166020665;
        Mon,  8 Jul 2019 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600003;
        bh=nBB6RH8DlhwgZizyYTe+f/eNVq+Li7TO2zarQoSczqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hok8xvPyXbCCxH8n26lJw5PturgKN1E21O3dVLY0ks/scNEZC2Hwq16FXsr54NLVn
         Lf2v1DZ95cAW0orj/YkSqCAOT2MJ8BrKBhBM/Hjq6H48QDQ4AdDhDQni0yIzqjAURU
         yFpTWL4ffrJJlPvmupOt0vSDw778+ru/4f5ZOlVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 62/96] ALSA: usb-audio: fix sign unintended sign extension on left shifts
Date:   Mon,  8 Jul 2019 17:13:34 +0200
Message-Id: <20190708150529.827837657@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 2acf5a3e6e9371e63c9e4ff54d84d08f630467a0 upstream.

There are a couple of left shifts of unsigned 8 bit values that
first get promoted to signed ints and hence get sign extended
on the shift if the top bit of the 8 bit values are set. Fix
this by casting the 8 bit values to unsigned ints to stop the
unintentional sign extension.

Addresses-Coverity: ("Unintended sign extension")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -754,7 +754,7 @@ static int snd_ni_control_init_val(struc
 		return err;
 	}
 
-	kctl->private_value |= (value << 24);
+	kctl->private_value |= ((unsigned int)value << 24);
 	return 0;
 }
 
@@ -915,7 +915,7 @@ static int snd_ftu_eff_switch_init(struc
 	if (err < 0)
 		return err;
 
-	kctl->private_value |= value[0] << 24;
+	kctl->private_value |= (unsigned int)value[0] << 24;
 	return 0;
 }
 


