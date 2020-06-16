Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DB81FB745
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgFPPoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731990AbgFPPoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE32208D5;
        Tue, 16 Jun 2020 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322272;
        bh=oy8Ne+jeLXvgmLgXt/ubGvSCJ8wk0wvHtZ/C7KZN9qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeiBtGWxB1MrZoz6+JuM3F4Uw10rkjYn/m95KPbiL9V+siMeecfWvUGsetiHd6LyS
         hdg6WJGNh/4J5muXmvHvN/43ZnJHCyBfU0WEhMThy/AwI96O6hhFjWVUyk12wvh4bv
         IdbFEtGhyNoCgO2UerCRah5QzRzs15SNQbRSDFmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 068/163] ALSA: pcm: disallow linking stream to itself
Date:   Tue, 16 Jun 2020 17:34:02 +0200
Message-Id: <20200616153110.103210684@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
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
 sound/core/pcm_native.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2166,6 +2166,12 @@ static int snd_pcm_link(struct snd_pcm_s
 	}
 	pcm_file = f.file->private_data;
 	substream1 = pcm_file->substream;
+
+	if (substream == substream1) {
+		res = -EINVAL;
+		goto _badf;
+	}
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		res = -ENOMEM;


