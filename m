Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4903541994
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378007AbiFGVWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380616AbiFGVQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274A321E320;
        Tue,  7 Jun 2022 11:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B63CDB8220B;
        Tue,  7 Jun 2022 18:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20042C385A2;
        Tue,  7 Jun 2022 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628135;
        bh=etlSzNB3grrboXbbp7K/HPtPiQ3/vS9tQOuqaVtCEwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9p03+Txtx5dYwz4YRWmVLTumSRQPf8r16ZTj4WkYIJWC0Zb9FwsgbOEJcX8A1+8C
         LJo3oSxdapE0PM79lPtTc8azCPlPNd0nNpqCb2Aw0imkneib6yrotRTkU0tr0j26Fq
         YSMMMm2qAx5znGYCXeitvI7USMXcQjY8PrqBeFuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 219/879] crypto: qat - fix off-by-one error in PFVF debug print
Date:   Tue,  7 Jun 2022 18:55:37 +0200
Message-Id: <20220607165009.211537519@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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



