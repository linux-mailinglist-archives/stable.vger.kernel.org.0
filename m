Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3122565D8E6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbjADQTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239990AbjADQTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:19:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD89167CF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:19:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECC536177C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C5BC433EF;
        Wed,  4 Jan 2023 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849168;
        bh=7orFaXyleBTcXT6eB+VPsacBMCA2FRG3jFzj99kMvPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXEC6yPcqAPfEtr+imphGDCmqSr7M4Hui/sZOyvzN3FZ315f0nORYW7AsYY2Q6UL+
         yl2OrKF5/9AJKxYmJyWjJPiGLcvWT90cn83fsQ8tHkhFV30ae3lXjdr7faJWBoscft
         c+5AJe1VVwZDBHfumfFYQ6FFcMxx7WyoZ7t90NB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 145/207] remoteproc: imx_rproc: Correct i.MX93 DRAM mapping
Date:   Wed,  4 Jan 2023 17:06:43 +0100
Message-Id: <20230104160516.508816052@linuxfoundation.org>
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


