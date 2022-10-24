Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE760A7C4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiJXM53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiJXM5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:57:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A789557E1D;
        Mon, 24 Oct 2022 05:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5AE4612C3;
        Mon, 24 Oct 2022 12:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDCCC433C1;
        Mon, 24 Oct 2022 12:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613563;
        bh=afOYIS3FPYL4NSLiTIHXXLe3RlmHLDq9fyBIsk/Z1Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgDmtZSo3UvobIAZcREQrAg2VEHgt6X0kHa5Nh6oAjjHi6yB5Qdtc0VVCpKL5IVd7
         q/TmwNr5TEBdT43MnjjLiPipY1PxFvzxdJJ1W4SlS1Dikhau/noUEzJjXSjGXL2p5c
         C1ZyE7QKVBjrlgeSaEFaljWDwI0IrzE02Sik97DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/255] crypto: cavium - prevent integer overflow loading firmware
Date:   Mon, 24 Oct 2022 13:31:33 +0200
Message-Id: <20221024113008.979725077@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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

[ Upstream commit 2526d6bf27d15054bb0778b2f7bc6625fd934905 ]

The "code_length" value comes from the firmware file.  If your firmware
is untrusted realistically there is probably very little you can do to
protect yourself.  Still we try to limit the damage as much as possible.
Also Smatch marks any data read from the filesystem as untrusted and
prints warnings if it not capped correctly.

The "ntohl(ucode->code_length) * 2" multiplication can have an
integer overflow.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 781949027451..d9362199423f 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -254,6 +254,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	const struct firmware *fw_entry;
 	struct device *dev = &cpt->pdev->dev;
 	struct ucode_header *ucode;
+	unsigned int code_length;
 	struct microcode *mcode;
 	int j, ret = 0;
 
@@ -264,11 +265,12 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	ucode = (struct ucode_header *)fw_entry->data;
 	mcode = &cpt->mcode[cpt->next_mc_idx];
 	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
-	mcode->code_size = ntohl(ucode->code_length) * 2;
-	if (!mcode->code_size) {
+	code_length = ntohl(ucode->code_length);
+	if (code_length == 0 || code_length >= INT_MAX / 2) {
 		ret = -EINVAL;
 		goto fw_release;
 	}
+	mcode->code_size = code_length * 2;
 
 	mcode->is_ae = is_ae;
 	mcode->core_mask = 0ULL;
-- 
2.35.1



