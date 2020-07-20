Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7558E22648E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgGTPqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgGTPqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E21A206E9;
        Mon, 20 Jul 2020 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259964;
        bh=PM2qco3AhDYbAW67Wclmbb4zJkBAlFrUSZOS3nlXwbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKqfHEqAfhEQhywUSk+ZLtM5+H9SvuIhxYCx+7RjYfGKf+Y2Ypfo5mzMbbtYFk/oK
         WGcdQFtc3xg6gg1n7qFu/oYMJGnCJaGhw6FCgWGVHuw7nDC/AIXVqZ6KUu7uaEr+Z9
         PvU56W3MSMpB9NU3TP61XpxkYkxomjld5A4iU6ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xidongwang <wangxidong_97@163.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 026/125] ALSA: opl3: fix infoleak in opl3
Date:   Mon, 20 Jul 2020 17:36:05 +0200
Message-Id: <20200720152804.253744600@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xidongwang <wangxidong_97@163.com>

commit ad155712bb1ea2151944cf06a0e08c315c70c1e3 upstream.

The stack object “info” in snd_opl3_ioctl() has a leaking problem.
It has 2 padding bytes which are not initialized and leaked via
“copy_to_user”.

Signed-off-by: xidongwang <wangxidong_97@163.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1594006058-30362-1-git-send-email-wangxidong_97@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/drivers/opl3/opl3_synth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/drivers/opl3/opl3_synth.c
+++ b/sound/drivers/opl3/opl3_synth.c
@@ -104,6 +104,8 @@ int snd_opl3_ioctl(struct snd_hwdep * hw
 		{
 			struct snd_dm_fm_info info;
 
+			memset(&info, 0, sizeof(info));
+
 			info.fm_mode = opl3->fm_mode;
 			info.rhythm = opl3->rhythm;
 			if (copy_to_user(argp, &info, sizeof(struct snd_dm_fm_info)))


