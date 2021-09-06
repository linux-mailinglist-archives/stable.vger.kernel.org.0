Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB550401BEB
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242729AbhIFNAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243498AbhIFM7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4DFE61076;
        Mon,  6 Sep 2021 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933119;
        bh=3+eCbje3fW8UTEA3knV/RI8TVK4lmKHcXv9hEXGbr98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itERQJFWlYVDYhqFIy2uKyrhxKor5hOG6UxwXcjfFeMyNrA4MFrudKYA+73l9lMDE
         hNjGM9paQvP70czS04f6WYY61r2K904YmbuT8qUXeOtyjRdtBfHCj8Eup6YymKAmoR
         Ov5nois44r0i+GaacSboGYB4j2y6jqZgecRU3PtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zubin Mithra <zsm@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 12/14] ALSA: pcm: fix divide error in snd_pcm_lib_ioctl
Date:   Mon,  6 Sep 2021 14:55:58 +0200
Message-Id: <20210906125448.596897554@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zubin Mithra <zsm@chromium.org>

commit f3eef46f0518a2b32ca1244015820c35a22cfe4a upstream.

Syzkaller reported a divide error in snd_pcm_lib_ioctl. fifo_size
is of type snd_pcm_uframes_t(unsigned long). If frame_size
is 0x100000000, the error occurs.

Fixes: a9960e6a293e ("ALSA: pcm: fix fifo_size frame calculation")
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210827153735.789452-1-zsm@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1746,7 +1746,7 @@ static int snd_pcm_lib_ioctl_fifo_size(s
 		channels = params_channels(params);
 		frame_size = snd_pcm_format_size(format, channels);
 		if (frame_size > 0)
-			params->fifo_size /= (unsigned)frame_size;
+			params->fifo_size /= frame_size;
 	}
 	return 0;
 }


