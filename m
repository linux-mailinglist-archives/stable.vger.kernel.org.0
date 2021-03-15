Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6A233B534
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhCONxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhCONxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A05364EB6;
        Mon, 15 Mar 2021 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816392;
        bh=iCfk0fsPyZmGgTK3B/NujRE3T36dFsaT/uXT8AA+360=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVP5imEQOI1AUbAZTCy3r1olIZ4Y+LR4DxiUUmzrkRO2y17IRp5H8erUJQOcP+iPs
         Imvxl9tWVwIabo/M9WXzBu2Y1lfBAfUD2N3uYrAhHpA/EXXnW6iiudC6kcsYW6RIDO
         jJLdR1nAtGXsbwQ8FBIvemENnInv0UEYrUOgoWYQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 18/75] media: usbtv: Fix deadlock on suspend
Date:   Mon, 15 Mar 2021 14:51:32 +0100
Message-Id: <20210315135208.849888886@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Maxim Mikityanskiy <maxtram95@gmail.com>

commit 8a7e27fd5cd696ba564a3f62cedef7269cfd0723 upstream.

usbtv doesn't support power management, so on system suspend the
.disconnect callback of the driver is called. The teardown sequence
includes a call to snd_card_free. Its implementation waits until the
refcount of the sound card device drops to zero, however, if its file is
open, snd_card_file_add takes a reference, which can't be dropped during
the suspend, because the userspace processes are already frozen at this
point. snd_card_free waits for completion forever, leading to a hang on
suspend.

This commit fixes this deadlock condition by replacing snd_card_free
with snd_card_free_when_closed, that doesn't wait until all references
are released, allowing suspend to progress.

Fixes: 63ddf68de52e ("[media] usbtv: add audio support")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -384,7 +384,7 @@ void usbtv_audio_free(struct usbtv *usbt
 	cancel_work_sync(&usbtv->snd_trigger);
 
 	if (usbtv->snd && usbtv->udev) {
-		snd_card_free(usbtv->snd);
+		snd_card_free_when_closed(usbtv->snd);
 		usbtv->snd = NULL;
 	}
 }


