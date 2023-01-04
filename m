Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE39A65D8E1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239954AbjADQTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239955AbjADQTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:19:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E447CD2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D98A61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA25C433D2;
        Wed,  4 Jan 2023 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849153;
        bh=7ktn5HAXB/jRgTYt6YfgA0BoMXWfLTYgjJN5ujsvieE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFYHBBtlcbQ8XPRFbB3LZckw4+AU7YvmyaOJngHI1nC8la3/LiscZ0kQcZr8V4tBR
         NicdLqhUKV5ryK0xz2c2ppc8lScdZbol5rUF4FO2UUYxrEq7B8WDmhTrCkj9qNQL6S
         WKogebkm91Yv9Z/Q1giCFrVObHPeJ5UTST88OV3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 143/207] remoteproc: imx_dsp_rproc: Add mutex protection for workqueue
Date:   Wed,  4 Jan 2023 17:06:41 +0100
Message-Id: <20230104160516.449224920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 47e6ab07018edebf94ce873cf50a05ec76ff2dde upstream.

The workqueue may execute late even after remoteproc is stopped or
stopping, some resources (rpmsg device and endpoint) have been
released in rproc_stop_subdevices(), then rproc_vq_interrupt()
accessing these resources will cause kennel dump.

Call trace:
 virtqueue_add_split+0x1ac/0x560
 virtqueue_add_inbuf+0x4c/0x60
 rpmsg_recv_done+0x15c/0x294
 vring_interrupt+0x6c/0xa4
 rproc_vq_interrupt+0x30/0x50
 imx_dsp_rproc_vq_work+0x24/0x40 [imx_dsp_rproc]
 process_one_work+0x1d0/0x354
 worker_thread+0x13c/0x470
 kthread+0x154/0x160
 ret_from_fork+0x10/0x20

Add mutex protection in imx_dsp_rproc_vq_work(), if the state is
not running, then just skip calling rproc_vq_interrupt().

Also the flush workqueue operation can't be added in rproc stop
for the same reason. The call sequence is

rproc_shutdown
-> rproc_stop
   ->rproc_stop_subdevices
   ->rproc->ops->stop()
     ->imx_dsp_rproc_stop
       ->flush_work
         -> rproc_vq_interrupt

The resource needed by rproc_vq_interrupt has been released in
rproc_stop_subdevices, so flush_work is not safe to be called in
imx_dsp_rproc_stop.

Fixes: ec0e5549f358 ("remoteproc: imx_dsp_rproc: Add remoteproc driver for DSP on i.MX")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1664524216-19949-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_dsp_rproc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -347,9 +347,6 @@ static int imx_dsp_rproc_stop(struct rpr
 	struct device *dev = rproc->dev.parent;
 	int ret = 0;
 
-	/* Make sure work is finished */
-	flush_work(&priv->rproc_work);
-
 	if (rproc->state == RPROC_CRASHED) {
 		priv->flags &= ~REMOTE_IS_READY;
 		return 0;
@@ -432,9 +429,18 @@ static void imx_dsp_rproc_vq_work(struct
 {
 	struct imx_dsp_rproc *priv = container_of(work, struct imx_dsp_rproc,
 						  rproc_work);
+	struct rproc *rproc = priv->rproc;
+
+	mutex_lock(&rproc->lock);
+
+	if (rproc->state != RPROC_RUNNING)
+		goto unlock_mutex;
 
 	rproc_vq_interrupt(priv->rproc, 0);
 	rproc_vq_interrupt(priv->rproc, 1);
+
+unlock_mutex:
+	mutex_unlock(&rproc->lock);
 }
 
 /**


