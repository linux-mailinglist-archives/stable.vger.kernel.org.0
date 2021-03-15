Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82E933B7CF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhCOOBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhCON7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 432C364F17;
        Mon, 15 Mar 2021 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816766;
        bh=1+oiQI9T+BEZ7+cq5WdB+SVZL/j02OZ6fOiHXpw0xMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqRYMX1HqE3MYE1Ag60mIzD9QSgRHfUEmbWxh/rVrqwPMbNI/nuks7/PLu3NtNLMf
         0BhjBwwjZHbhZDVOGop27NnC3o4t6kIHfJk+W6/h4ZxL2qapD86RqCxAziD9+iLcU/
         37vS8B5hFfMGtsQKeV22yr1jnSTapaL4EVE2Eqno=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 102/290] media: usbtv: Fix deadlock on suspend
Date:   Mon, 15 Mar 2021 14:53:15 +0100
Message-Id: <20210315135545.366669444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -371,7 +371,7 @@ void usbtv_audio_free(struct usbtv *usbt
 	cancel_work_sync(&usbtv->snd_trigger);
 
 	if (usbtv->snd && usbtv->udev) {
-		snd_card_free(usbtv->snd);
+		snd_card_free_when_closed(usbtv->snd);
 		usbtv->snd = NULL;
 	}
 }


