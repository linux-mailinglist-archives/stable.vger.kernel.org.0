Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAB84F3FF3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377891AbiDEMXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356146AbiDEKW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A2DB91B9;
        Tue,  5 Apr 2022 03:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0448B81C86;
        Tue,  5 Apr 2022 10:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6598EC385A2;
        Tue,  5 Apr 2022 10:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153212;
        bh=m9IdsWkhwEHDsIk1mPp3Sw2dqcl6n6tF8/nLt+2Yvdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd6nxQv+19zHv8YcO1A4c6PQEcbdWePO8R6uH1ipLcyO37loPUHSQoP77H0OcESFl
         INloMuJTPrx1iNgGlfbKel8Sh8uxHyQ+wN3NOgd6ppb/7/dzhBfDA4daYthg+MQtdc
         j+3jOEKAlVTlV9VIIpNkUHXYsivCm4jMq7+81OYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/599] crypto: ccree - dont attempt 0 len DMA mappings
Date:   Tue,  5 Apr 2022 09:27:16 +0200
Message-Id: <20220405070303.067867519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 1fb37b5692c915edcc2448a6b37255738c7c77e0 ]

Refuse to try mapping zero bytes as this may cause a fault
on some configurations / platforms and it seems the prev.
attempt is not enough and we need to be more explicit.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Fixes: ce0fc6db38de ("crypto: ccree - protect against empty or NULL
scatterlists")
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index a5e041d9d2cf..11e0278c8631 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -258,6 +258,13 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 {
 	int ret = 0;
 
+	if (!nbytes) {
+		*mapped_nents = 0;
+		*lbytes = 0;
+		*nents = 0;
+		return 0;
+	}
+
 	*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
 	if (*nents > max_sg_nents) {
 		*nents = 0;
-- 
2.34.1



