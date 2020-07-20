Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42272226C41
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgGTPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbgGTPis (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BFA22CB2;
        Mon, 20 Jul 2020 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259527;
        bh=PM2qco3AhDYbAW67Wclmbb4zJkBAlFrUSZOS3nlXwbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZujYuSinZy7GDH1HsgVNr+UAmt26A5RWLLc6cNoJyJV3kB0kZxtVTEjzH7Ubh7eft
         w8M+Gl6kl3MG4kZl59vy/hdOwTViXuvs5JAfaMy2WjSxV1R4ndgMAXFPbNIW05BzZu
         9fYlDnRo90Ic0K54v0LeSN7IJQaZjfoGhwBGo0Gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xidongwang <wangxidong_97@163.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 10/58] ALSA: opl3: fix infoleak in opl3
Date:   Mon, 20 Jul 2020 17:36:26 +0200
Message-Id: <20200720152747.652616720@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
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


