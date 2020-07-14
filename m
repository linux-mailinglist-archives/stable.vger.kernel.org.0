Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D021FCE6
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgGNSrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbgGNSrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D604D22AAA;
        Tue, 14 Jul 2020 18:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752426;
        bh=1t8cL7Yb5oaNNipT4W6oOQDJSSsS4oYq2lD4Wf4LBG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dmKxSZ6yndfoHCR7/In75RdKaQrev54VeHZlwBoda0BfEAGzU/XprcvqI6/vvAan
         cIfHTnqfMS5IOq0PY++gMa8U/XRSrSsaHSeX/+qdfM7UEVdiwC9fC9mx6578OiN0T7
         Dbh1F9Nc02QkhheenYYakBjJZW09MMgIHAXVjym8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xidongwang <wangxidong_97@163.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 38/58] ALSA: opl3: fix infoleak in opl3
Date:   Tue, 14 Jul 2020 20:44:11 +0200
Message-Id: <20200714184058.021766944@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
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
@@ -105,6 +105,8 @@ int snd_opl3_ioctl(struct snd_hwdep * hw
 		{
 			struct snd_dm_fm_info info;
 
+			memset(&info, 0, sizeof(info));
+
 			info.fm_mode = opl3->fm_mode;
 			info.rhythm = opl3->rhythm;
 			if (copy_to_user(argp, &info, sizeof(struct snd_dm_fm_info)))


