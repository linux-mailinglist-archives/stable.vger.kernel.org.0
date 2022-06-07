Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8FD540B6B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbiFGS2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350204AbiFGSXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2D4C5E5D;
        Tue,  7 Jun 2022 10:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50697617ED;
        Tue,  7 Jun 2022 17:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2D6C385A5;
        Tue,  7 Jun 2022 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624437;
        bh=Es88hOl7dOsT5p4S16j5QOi4YudCVRc+UBvDlBjPxw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NASDzK+Go+FaPliYVEVwMt2x0uRZ/kZbCG4vM/QkTFlsssnR14s9BnqbZEAScx5xh
         3nPRkm2B34nZoFHWxma2ETQuqb6MfnoqR8sP03uGTgHWFF/fGX57GK4QSRRQvw7Avp
         Wf5b353PhEspijPqBOi2eGeyj4io8K/AYvrUPFzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/667] media: atmel: atmel-sama5d2-isc: fix wrong mask in YUYV format check
Date:   Tue,  7 Jun 2022 18:59:52 +0200
Message-Id: <20220607164944.576619529@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 91f49b80983f7bffdea9498209b2b896231ac776 ]

While this does not happen in production, this check should be done
versus the mask, as checking with the YCYC value may not include
some bits that may be set.
It is correct and safe to check the whole mask.

Fixes: 123aaf816b95 ("media: atmel: atmel-sama5d2-isc: fix YUYV format")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-sama5d2-isc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index c8ed9315ef31..7421bc51709c 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -267,7 +267,7 @@ static void isc_sama5d2_config_rlp(struct isc_device *isc)
 	 * Thus, if the YCYC mode is selected, replace it with the
 	 * sama5d2-compliant mode which is YYCC .
 	 */
-	if ((rlp_mode & ISC_RLP_CFG_MODE_YCYC) == ISC_RLP_CFG_MODE_YCYC) {
+	if ((rlp_mode & ISC_RLP_CFG_MODE_MASK) == ISC_RLP_CFG_MODE_YCYC) {
 		rlp_mode &= ~ISC_RLP_CFG_MODE_MASK;
 		rlp_mode |= ISC_RLP_CFG_MODE_YYCC;
 	}
-- 
2.35.1



