Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC3598E15
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 22:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiHRUdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 16:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiHRUdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 16:33:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE633A0E;
        Thu, 18 Aug 2022 13:33:51 -0700 (PDT)
Received: from whitebuilder.lan (192-222-136-102.qc.cable.ebox.net [192.222.136.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: nicolas)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 026F96601B46;
        Thu, 18 Aug 2022 21:33:47 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660854830;
        bh=pggMW/0Bxy8VjFzlvpemyaipfIDNrL2BmOAkso3LhhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2yfagMG57Nh3EXsVf9/Smr/3esiSEbIWwaYOIiLAHA+6nV2niIE9P/2HYaJiywov
         G8QzDCDnzOeAeslg/Tnf6Y9Fa3il7jyPDhLjVbM7IVs/H25Cncmgrkt9lNIanNMXIH
         osCQAXJsYJM/LZFnYttXjTZGnrlrEAZGby67oDBvlz6EPuX9kn5AGAraiJ8vISeafA
         KZV1o2iv9NY/0c63k5T/OFe3i3YohHc1x0KoPwBvSjXyfhTNG0GaSs3gFmR3bVKV1j
         rwpyCFPLSBmjLyK3NVkNNEQlz6x/P9B6B1wKrascvZhZh9JV39AGv6CnYK47ccsQ/a
         wNOz5rtW8yh6Q==
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] media: cedrus: Fix watchdog race condition
Date:   Thu, 18 Aug 2022 16:33:06 -0400
Message-Id: <20220818203308.439043-2-nicolas.dufresne@collabora.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The watchdog needs to be schedule before we trigger the decode
operation, otherwise there is a risk that the decoder IRQ will be
called before we have schedule the watchdog. As a side effect, the
watchdog would never be cancelled and its function would be called
at an inappropriate time.

This was observed while running Fluster with GStreamer as a backend.
Some programming error would cause the decoder IRQ to be call very
quickly after the trigger. Later calls into the driver would deadlock
due to the unbalanced state.

Cc: stable@vger.kernel.org
Fixes: 7c38a551bda1 ("media: cedrus: Add watchdog for job completion")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index 3b6aa78a2985f..e7f7602a5ab40 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -106,11 +106,11 @@ void cedrus_device_run(void *priv)
 
 	/* Trigger decoding if setup went well, bail out otherwise. */
 	if (!error) {
-		dev->dec_ops[ctx->current_codec]->trigger(ctx);
-
 		/* Start the watchdog timer. */
 		schedule_delayed_work(&dev->watchdog_work,
 				      msecs_to_jiffies(2000));
+
+		dev->dec_ops[ctx->current_codec]->trigger(ctx);
 	} else {
 		v4l2_m2m_buf_done_and_job_finish(ctx->dev->m2m_dev,
 						 ctx->fh.m2m_ctx,
-- 
2.37.2

