Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92E665D96A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbjADQZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbjADQYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:24:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE4633D74
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C166177C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F337CC433EF;
        Wed,  4 Jan 2023 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849440;
        bh=7orFaXyleBTcXT6eB+VPsacBMCA2FRG3jFzj99kMvPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps0I/iExCswRWAMg6KLfqNZZo3S36qV9rqVHifdyfQfegghX2P8I8r0ejpj8lcE5I
         44OxfTQeG8JZ+ULV8RtW5o8e5X8KWEnC3NdrE6A+M1rghRD/IEz9egar6jczYkTblE
         qz1HcCvzHBVMr7LxPcac/+/sMc1J//+StaFkD6qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.0 119/177] remoteproc: imx_rproc: Correct i.MX93 DRAM mapping
Date:   Wed,  4 Jan 2023 17:06:50 +0100
Message-Id: <20230104160511.249188755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

commit ee18f2715e85f4ef051851a0c4831ee7ad7d83b3 upstream.

According to updated reference mannual, the M33 DRAM view of
0x[C,D]0000000 maps to A55 0xC0000000, so correct it.

Fixes: 9222fabf0e39 ("remoteproc: imx_rproc: Support i.MX93")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221102111410.38737-1-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -113,8 +113,8 @@ static const struct imx_rproc_att imx_rp
 	{ 0x80000000, 0x80000000, 0x10000000, 0 },
 	{ 0x90000000, 0x80000000, 0x10000000, 0 },
 
-	{ 0xC0000000, 0xa0000000, 0x10000000, 0 },
-	{ 0xD0000000, 0xa0000000, 0x10000000, 0 },
+	{ 0xC0000000, 0xC0000000, 0x10000000, 0 },
+	{ 0xD0000000, 0xC0000000, 0x10000000, 0 },
 };
 
 static const struct imx_rproc_att imx_rproc_att_imx8mn[] = {


