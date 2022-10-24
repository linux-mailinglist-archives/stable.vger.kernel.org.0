Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA17760AC92
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbiJXOKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiJXOHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:07:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5035A80487;
        Mon, 24 Oct 2022 05:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C45E61298;
        Mon, 24 Oct 2022 12:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696D4C433D7;
        Mon, 24 Oct 2022 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615832;
        bh=tzkFWHdBR1QJkTnAVZrUmtw9WJSWAiTSqmAiaamAgSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H28Hq6P/2A7Gn+o64idRa4+Xsw5HxXQ/CuIhX3fjUnPmhUK3BM69zkmFFN67b9yuX
         PHBLB2bYOCZAG/22DXVN6cC6hphpeoMqV6YP2BlREMwkMdP3HDYWHSL0XLT5aHzOFS
         dwAw2GrFe4tjdFVVzljn1nS9OKxvliHqvmyTLRu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/530] crypto: marvell/octeontx - prevent integer overflows
Date:   Mon, 24 Oct 2022 13:32:17 +0200
Message-Id: <20221024113102.860384626@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit caca37cf6c749ff0303f68418cfe7b757a4e0697 ]

The "code_length" value comes from the firmware file.  If your firmware
is untrusted realistically there is probably very little you can do to
protect yourself.  Still we try to limit the damage as much as possible.
Also Smatch marks any data read from the filesystem as untrusted and
prints warnings if it not capped correctly.

The "code_length * 2" can overflow.  The round_up(ucode_size, 16) +
sizeof() expression can overflow too.  Prevent these overflows.

Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/marvell/octeontx/otx_cptpf_ucode.c  | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 40b482198ebc..a765eefb18c2 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -286,6 +286,7 @@ static int process_tar_file(struct device *dev,
 	struct tar_ucode_info_t *tar_info;
 	struct otx_cpt_ucode_hdr *ucode_hdr;
 	int ucode_type, ucode_size;
+	unsigned int code_length;
 
 	/*
 	 * If size is less than microcode header size then don't report
@@ -303,7 +304,13 @@ static int process_tar_file(struct device *dev,
 	if (get_ucode_type(ucode_hdr, &ucode_type))
 		return 0;
 
-	ucode_size = ntohl(ucode_hdr->code_length) * 2;
+	code_length = ntohl(ucode_hdr->code_length);
+	if (code_length >= INT_MAX / 2) {
+		dev_err(dev, "Invalid code_length %u\n", code_length);
+		return -EINVAL;
+	}
+
+	ucode_size = code_length * 2;
 	if (!ucode_size || (size < round_up(ucode_size, 16) +
 	    sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
 		dev_err(dev, "Ucode %s invalid size\n", filename);
@@ -886,6 +893,7 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 {
 	struct otx_cpt_ucode_hdr *ucode_hdr;
 	const struct firmware *fw;
+	unsigned int code_length;
 	int ret;
 
 	set_ucode_filename(ucode, ucode_filename);
@@ -896,7 +904,13 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 	ucode_hdr = (struct otx_cpt_ucode_hdr *) fw->data;
 	memcpy(ucode->ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
 	ucode->ver_num = ucode_hdr->ver_num;
-	ucode->size = ntohl(ucode_hdr->code_length) * 2;
+	code_length = ntohl(ucode_hdr->code_length);
+	if (code_length >= INT_MAX / 2) {
+		dev_err(dev, "Ucode invalid code_length %u\n", code_length);
+		ret = -EINVAL;
+		goto release_fw;
+	}
+	ucode->size = code_length * 2;
 	if (!ucode->size || (fw->size < round_up(ucode->size, 16)
 	    + sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
 		dev_err(dev, "Ucode %s invalid size\n", ucode_filename);
-- 
2.35.1



