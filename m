Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D55218C1
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 15:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfEQNBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 09:01:36 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:59093 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728407AbfEQNBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 09:01:36 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 709BD45C;
        Fri, 17 May 2019 09:01:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 09:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Eht6l/
        isQhd4zZdODzlKFHG06cgHQUazL7+GK3YEDlY=; b=cYuvME90wft5hdAQxSE/2n
        0UNM2PVymG/tfe67KfgXX0XgVoKsU10DoOyR0hr+kQf0MzLuBt/eZRwLnYPepNdA
        SjQRLaOhvkf/Ho4OtL4/hweSzzM1Qu6QiEaP6cqPo8IXc9y5o8GjxXvWPsGi27Jt
        L7v7c2VIbbY5MA39eGNfttU08MAaJMOxhoj/xpH4p53FeMiZmACbKqXRdIqkepmo
        4FKOQELy7bIrZKC7xGqiBoppHDF5j7YcOaReZS46HWLjiWbEgbRvsqnaVbc/jR+J
        a9WOBakX/jkhNfLnxLtQMrPmL4o4b0TJarq4Zbm2Aa9sdfrxzlOkB2ACOpCFT0zQ
        ==
X-ME-Sender: <xms:rrDeXKSmai8d0sVgpsQ--SHfVYl26oqpw_udcPzjKHO4_DQsKn79RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:rrDeXA-fcxZOAxtfy6KNhrzfMtDPJmMtETvkNEM4RyYF5JdxcLgneA>
    <xmx:rrDeXIQdsfjOqiY-yKa3tkFH6e2wii0aSzJJQRlA1zZ5JpB6FcQfQQ>
    <xmx:rrDeXPas6S0fqshu1B6jw9Sp0EqOCzZZrqTeWX92iMyDQrw77C6NGg>
    <xmx:r7DeXFP1ZmYAf1t1MlyxDNp7IPswFNWnZq8cT6BBHf_Vvgb3zvjKOw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FF5480061;
        Fri, 17 May 2019 09:01:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: wm_adsp: Avoid calling snd_compr_stop_error from WDT" failed to apply to 5.1-stable tree
To:     ckeepax@opensource.cirrus.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 15:01:00 +0200
Message-ID: <1558098060357@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa612f2b006aa3552871dabcd6a8e90e33f65e09 Mon Sep 17 00:00:00 2001
From: Charles Keepax <ckeepax@opensource.cirrus.com>
Date: Thu, 4 Apr 2019 13:56:01 +0100
Subject: [PATCH] ASoC: wm_adsp: Avoid calling snd_compr_stop_error from WDT
 expiry

It is unsafe to call snd_compr_stop_error from outside of the
compressed ops. Firstly the compressed device lock needs to be held
and secondly it queues error work to issue a trigger stop which
should not happen after the stream has been freed. To avoid these
issues use the same trick used for the IRQ handling, simply send a
snd_compr_fragment_elapsed to cause user-space to wake on the poll,
then report the error when user-space issues the pointer request
after it wakes.

Fixes: a2bcbc1b9ac2f ("ASoC: wm_adsp: Shutdown any compressed streams on DSP watchdog timeout")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@kernel.org

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index c8c49d5b8ac9..a9298bfddd9c 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -4092,7 +4092,7 @@ int wm_adsp_compr_pointer(struct snd_compr_stream *stream,
 
 	buf = compr->buf;
 
-	if (!buf || buf->error) {
+	if (dsp->fatal_error || !buf || buf->error) {
 		snd_compr_stop_error(stream, SNDRV_PCM_STATE_XRUN);
 		ret = -EIO;
 		goto out;
@@ -4196,12 +4196,13 @@ static int wm_adsp_buffer_capture_block(struct wm_adsp_compr *compr, int target)
 static int wm_adsp_compr_read(struct wm_adsp_compr *compr,
 			      char __user *buf, size_t count)
 {
+	struct wm_adsp *dsp = compr->dsp;
 	int ntotal = 0;
 	int nwords, nbytes;
 
 	compr_dbg(compr, "Requested read of %zu bytes\n", count);
 
-	if (!compr->buf || compr->buf->error) {
+	if (dsp->fatal_error || !compr->buf || compr->buf->error) {
 		snd_compr_stop_error(compr->stream, SNDRV_PCM_STATE_XRUN);
 		return -EIO;
 	}
@@ -4262,11 +4263,8 @@ static void wm_adsp_fatal_error(struct wm_adsp *dsp)
 	dsp->fatal_error = true;
 
 	list_for_each_entry(compr, &dsp->compr_list, list) {
-		if (compr->stream) {
-			snd_compr_stop_error(compr->stream,
-					     SNDRV_PCM_STATE_XRUN);
+		if (compr->stream)
 			snd_compr_fragment_elapsed(compr->stream);
-		}
 	}
 }
 

