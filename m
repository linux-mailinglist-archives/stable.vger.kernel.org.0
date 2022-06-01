Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69E153A6F0
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353608AbiFAN5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353822AbiFANzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4694395A39;
        Wed,  1 Jun 2022 06:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A6F6B8175B;
        Wed,  1 Jun 2022 13:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D134C385A5;
        Wed,  1 Jun 2022 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091686;
        bh=etlSzNB3grrboXbbp7K/HPtPiQ3/vS9tQOuqaVtCEwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfktdDBTkjwjyyvgmu2tvNu+Qr6YZEg2wM47Ol4tB83uKUFIdKXIDzb3CNv+o1a2g
         iWEQttT+VSoMto0xK8+gbZYaYind6yFF8QhkumJbTBcG5kitLEG/5iSsoAgkQwOkAd
         u2d+eHZBYKRlvKDIxUO+ECmlK3qh6QeXMAc33bHQXIU8otTJNEnPHUSJOwY3gw+MA/
         SYNgbnc3D54w8S2Mc29zDWPROaKnuy6+ItpLlVfyQXJPdcuzCBvsA7AEPiV91V0Q8S
         JnD2ToO+wr+2gOUMZ5Ssil+cSwkxeXKvF0JbIxPrQP9KvXPUgwRWQjWdjxSxzsjmSD
         1UUokPSvgozsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        fiona.trahe@intel.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 11/48] crypto: qat - fix off-by-one error in PFVF debug print
Date:   Wed,  1 Jun 2022 09:53:44 -0400
Message-Id: <20220601135421.2003328-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

[ Upstream commit dd3d081b7ea6754913222ed0313fcf644edcc7e6 ]

PFVF Block Message requests for CRC use 0-based values to indicate
amounts, which have to be remapped to 1-based values on the receiving
side.

This patch fixes one debug print which was however using the wire value.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 588352de1ef0..d17318d3f63a 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -154,7 +154,7 @@ static struct pfvf_message handle_blkmsg_req(struct adf_accel_vf_info *vf_info,
 	if (FIELD_GET(ADF_VF2PF_BLOCK_CRC_REQ_MASK, req.data)) {
 		dev_dbg(&GET_DEV(vf_info->accel_dev),
 			"BlockMsg of type %d for CRC over %d bytes received from VF%d\n",
-			blk_type, blk_byte, vf_info->vf_nr);
+			blk_type, blk_byte + 1, vf_info->vf_nr);
 
 		if (!adf_pf2vf_blkmsg_get_data(vf_info, blk_type, blk_byte,
 					       byte_max, &resp_data,
-- 
2.35.1

