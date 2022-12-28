Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00871658266
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiL1QfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiL1QeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773731D0DF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:31:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F223CB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E973C433F1;
        Wed, 28 Dec 2022 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245098;
        bh=0Jbbn8+jP72XcL5qZalCNK0o7c/74yj6l/iRWNN7ZM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbZSDmghiRosHeU5UF9kLx7w+j3T1CCk6lEnp+xonQxE9C2L5nHlBF/zCjCzg67z2
         8XZHXTGDFs4/VlJgEk5ubCwrB86OBzE/fdR4YtooZbkdcNYWzqBslQgSNY5vcDyEFQ
         pbPXGn1TyW1Ahqin086GSXC/1uaOAmSDLm2OMXw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0796/1146] remoteproc: core: Auto select rproc-virtio device id
Date:   Wed, 28 Dec 2022 15:38:55 +0100
Message-Id: <20221228144351.769955711@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 65fcf3872f83d63fb7268e05d4b02640df14126e ]

With multiple remoteproc device, there will below error:

sysfs: cannot create duplicate filename '/bus/platform/devices/rproc-virtio.0'

The rvdev_data.index is duplicate, that cause issue, so
need to use the PLATFORM_DEVID_AUTO instead. After fixing
device name it becomes something like:
/bus/platform/devices/rproc-virtio.2.auto

Fixes: 1d7b61c06dc3 ("remoteproc: virtio: Create platform device for the remoteproc_virtio")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Tested-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1666100644-27010-1-git-send-email-shengjiu.wang@nxp.com
[Fixed typographical error in comment block]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 8768cb64f560..cb1d414a2389 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -509,7 +509,13 @@ static int rproc_handle_vdev(struct rproc *rproc, void *ptr,
 	rvdev_data.rsc_offset = offset;
 	rvdev_data.rsc = rsc;
 
-	pdev = platform_device_register_data(dev, "rproc-virtio", rvdev_data.index, &rvdev_data,
+	/*
+	 * When there is more than one remote processor, rproc->nb_vdev number is
+	 * same for each separate instances of "rproc". If rvdev_data.index is used
+	 * as device id, then we get duplication in sysfs, so need to use
+	 * PLATFORM_DEVID_AUTO to auto select device id.
+	 */
+	pdev = platform_device_register_data(dev, "rproc-virtio", PLATFORM_DEVID_AUTO, &rvdev_data,
 					     sizeof(rvdev_data));
 	if (IS_ERR(pdev)) {
 		dev_err(dev, "failed to create rproc-virtio device\n");
-- 
2.35.1



