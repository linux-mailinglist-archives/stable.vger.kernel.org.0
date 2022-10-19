Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6075603E5C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiJSJNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiJSJLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:11:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CC44F3BD;
        Wed, 19 Oct 2022 02:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27D0F6174B;
        Wed, 19 Oct 2022 09:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36041C433D7;
        Wed, 19 Oct 2022 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170130;
        bh=g4F35njtKClTm2AcWT7WheFUPbeErkcDnc/IAYofFMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foGm2pLti9XZRJ4JqtYG1VOz/T7vokLw2J0+2eGLBrd/0XBkUcjSw36R/jhHxIeAF
         80R2s9MxOQQ8iXIZek2QqztJXQh5UYs6WqJfn2jy/VEDdNuTPKiFSkFpBvK1wWIVM6
         R9A/gR+IIVFuKGQnXY3QGFLrdHkzpk4TFSg0/+sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 521/862] remoteproc: Harden rproc_handle_vdev() against integer overflow
Date:   Wed, 19 Oct 2022 10:30:08 +0200
Message-Id: <20221019083313.006320760@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7d7f8fe4e399519cc9ac68a475fec6d3a996341b ]

The struct_size() macro protects against integer overflows but adding
"+ rsc->config_len" introduces the risk of integer overflows again.
Use size_add() to be safe.

Fixes: c87846571587 ("remoteproc: use struct_size() helper")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/YyMyoPoGOJUcEpZT@kili
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index e5279ed9a8d7..4fc5ce2187ac 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -520,12 +520,13 @@ static int rproc_handle_vdev(struct rproc *rproc, void *ptr,
 	struct fw_rsc_vdev *rsc = ptr;
 	struct device *dev = &rproc->dev;
 	struct rproc_vdev *rvdev;
+	size_t rsc_size;
 	int i, ret;
 	char name[16];
 
 	/* make sure resource isn't truncated */
-	if (struct_size(rsc, vring, rsc->num_of_vrings) + rsc->config_len >
-			avail) {
+	rsc_size = struct_size(rsc, vring, rsc->num_of_vrings);
+	if (size_add(rsc_size, rsc->config_len) > avail) {
 		dev_err(dev, "vdev rsc is truncated\n");
 		return -EINVAL;
 	}
-- 
2.35.1



