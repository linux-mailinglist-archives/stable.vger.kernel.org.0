Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6924F27D5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiDEIJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiDEH6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE5C986EE;
        Tue,  5 Apr 2022 00:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466A8616DF;
        Tue,  5 Apr 2022 07:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DE4C340EE;
        Tue,  5 Apr 2022 07:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145107;
        bh=SPMSx1SXb3gyDlMxrLqouAtL5UjJNeBlv1lst3UzYa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoE+Ufm/4VFmFkBD9kvhxqcfAStr4K9MCBzg3xbQciHxCwEIXzpeNh5vLixId9KUa
         sTm+gdqVo8TVQExwdIctpD+PNpL6I6uL+wBxbRC6HBcU49OxBTtoqsjJIKJUgU8ocJ
         VOBirPRPGCC96Qfy0+HwID+tL+EDpQ5uwIb3Hr38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0260/1126] crypto: qat - fix initialization of pfvf rts_map_msg structures
Date:   Tue,  5 Apr 2022 09:16:47 +0200
Message-Id: <20220405070415.243168067@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 44dbd0c61bf1480be55dbb0cac793d861d1957b9 ]

Initialize fully the structures rts_map_msg containing the ring to
service map from the host.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:

    drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c:144:51: warning: missing field 'map' initializer [-Wmissing-field-initializers]
            struct ring_to_svc_map_v1 rts_map_msg = { { 0 }, };
                                                             ^
Fixes: e1b176af3d7e ("crypto: qat - exchange ring-to-service mappings over PFVF")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index c5b326f63e95..1141258db4b6 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -141,7 +141,7 @@ int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev)
 
 int adf_vf2pf_get_ring_to_svc(struct adf_accel_dev *accel_dev)
 {
-	struct ring_to_svc_map_v1 rts_map_msg = { { 0 }, };
+	struct ring_to_svc_map_v1 rts_map_msg = { 0 };
 	unsigned int len = sizeof(rts_map_msg);
 
 	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_RING_TO_SVC_MAP)
-- 
2.34.1



