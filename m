Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE61E2351A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390649AbfETMdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390453AbfETMdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8512204FD;
        Mon, 20 May 2019 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355584;
        bh=EU67Q5dW9HDV5St97CrceoJ8fxnFxFU67gPhW95rM6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHmi5i3gkiPX9IwCHSyreaoZ0Pla6dPeP6C+Nq4wxa/GxBYq/DVXRoifv23vevNcY
         hwn187KFLACkm6B8JK10/HCIX07997bW9HClQaN66AeQNE/2H5j/X58lnBlaEV7sjR
         VRdp4gCNgPgG+pU1L7/O4CwV9M4N5tI1UogrIpjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 049/128] ALSA: usb-audio: Fix a memory leak bug
Date:   Mon, 20 May 2019 14:13:56 +0200
Message-Id: <20190520115253.082305457@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

commit cb5173594d50c72b7bfa14113dfc5084b4d2f726 upstream.

In parse_audio_selector_unit(), the string array 'namelist' is allocated
through kmalloc_array(), and each string pointer in this array, i.e.,
'namelist[]', is allocated through kmalloc() in the following for loop.
Then, a control instance 'kctl' is created by invoking snd_ctl_new1(). If
an error occurs during the creation process, the string array 'namelist',
including all string pointers in the array 'namelist[]', should be freed,
before the error code ENOMEM is returned. However, the current code does
not free 'namelist[]', resulting in memory leaks.

To fix the above issue, free all string pointers 'namelist[]' in a loop.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2675,6 +2675,8 @@ static int parse_audio_selector_unit(str
 	kctl = snd_ctl_new1(&mixer_selectunit_ctl, cval);
 	if (! kctl) {
 		usb_audio_err(state->chip, "cannot malloc kcontrol\n");
+		for (i = 0; i < desc->bNrInPins; i++)
+			kfree(namelist[i]);
 		kfree(namelist);
 		kfree(cval);
 		return -ENOMEM;


