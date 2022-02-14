Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24414B4A32
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346484AbiBNKVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:21:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347459AbiBNKVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:21:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D8D6E2A3;
        Mon, 14 Feb 2022 01:55:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42379B80DBE;
        Mon, 14 Feb 2022 09:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D333C340E9;
        Mon, 14 Feb 2022 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832520;
        bh=EKHOewFeeT6MRfjkdUWbNby2Elw2HxvVWZiR6+uY1sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAonglvq239ylkWH5v6U5yICx9YzFHXzQON9NL6enULe6VjBXq2Dhc4XzqB+H1zW6
         2HWnpJBJdixpJ3IiK0lQcMB/+TVNmYS3apdnIG5JS9vRcl13fcgs7Ae3dk+2ZqV3Iq
         QWLyJMeKvNKMCdsQsLAoMeKL6jusoFVNIabvvjic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.16 009/203] mmc: sh_mmcif: Check for null res pointer
Date:   Mon, 14 Feb 2022 10:24:13 +0100
Message-Id: <20220214092510.532676701@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit 4d315357b3d6c315a7260420c6c6fc076e58d14b upstream.

If there is no suitable resource, platform_get_resource() will return
NULL.
Therefore in order to avoid the dereference of the NULL pointer, it
should be better to check the 'res'.

Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: stable@vger.kernel.org # v5.16+
Link: https://lore.kernel.org/r/20220119120006.1426964-1-jiasheng@iscas.ac.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sh_mmcif.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -405,6 +405,9 @@ static int sh_mmcif_dma_slave_config(str
 	struct dma_slave_config cfg = { 0, };
 
 	res = platform_get_resource(host->pd, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
 	cfg.direction = direction;
 
 	if (direction == DMA_DEV_TO_MEM) {


