Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397E2200D43
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389937AbgFSOzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389930AbgFSOzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ECE2217D8;
        Fri, 19 Jun 2020 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578507;
        bh=1eSZjQgKfVVsLLfXTxtQ3rjM7XN6sZefKgC7r3UjGBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VQFMJSgN8QIssoTvjahCai/VTUr41oFbwR22U5j/1Vlr8AmyUaOsxiU6rn/TawAq
         HU30lJUlWBdnjAvZnD8jl121V1MfSYgHibOLp9lw2LVN1nBc7c67JT2BDEg6knwgTu
         0F0iAxmNE3e+Fu8LwXSkjGSPXatdCVYPWYWqKAAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 048/267] ALSA: pcm: disallow linking stream to itself
Date:   Fri, 19 Jun 2020 16:30:33 +0200
Message-Id: <20200619141651.194116930@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 951e2736f4b11b58dc44d41964fa17c3527d882a upstream.

Prevent SNDRV_PCM_IOCTL_LINK linking stream to itself - the code
can't handle it. Fixed commit is not where bug was introduced, but
changes the context significantly.

Cc: stable@vger.kernel.org
Fixes: 0888c321de70 ("pcm_native: switch to fdget()/fdput()")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/89c4a2487609a0ed6af3ecf01cc972bdc59a7a2d.1591634956.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 sound/core/pcm_native.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1982,6 +1982,11 @@ static int snd_pcm_link(struct snd_pcm_s
 	}
 	pcm_file = f.file->private_data;
 	substream1 = pcm_file->substream;
+	if (substream == substream1) {
+		res = -EINVAL;
+		goto _badf;
+	}
+
 	group = kmalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		res = -ENOMEM;


