Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751D053CEEF
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbiFCRtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345004AbiFCRsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF185541AA;
        Fri,  3 Jun 2022 10:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C25A60A6B;
        Fri,  3 Jun 2022 17:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB3BC385B8;
        Fri,  3 Jun 2022 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278323;
        bh=e1GvVuGQ+unzosyZcj6xC7FjpppfWqxA/blqXv1Kyd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faVpcDpdOgk7m2EIL3xxanoDyuwZWeSsd+calvMaG0P7GpQSTXgmEA4vBb199+EB/
         ekf8C3fSsr/YIJooKRhHk8toGdZH4jV5r2bX2QWL0RKAIhBDsbsmoZj8yg8dnaSdwA
         AqAnloLn8Qh7vlqnizWLbkyC5cTVeY0CEuNFfv3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 29/34] tpm: Fix buffer access in tpm2_get_tpm_pt()
Date:   Fri,  3 Jun 2022 19:43:25 +0200
Message-Id: <20220603173817.028616126@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>

commit e57b2523bd37e6434f4e64c7a685e3715ad21e9a upstream.

Under certain conditions uninitialized memory will be accessed.
As described by TCG Trusted Platform Module Library Specification,
rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
requesting a capability, the TPM in field upgrade mode may return a
zero length list.
Check the property count in tpm2_get_tpm_pt().

Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -706,7 +706,16 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip
 	if (!rc) {
 		out = (struct tpm2_get_cap_out *)
 			&buf.data[TPM_HEADER_SIZE];
-		*value = be32_to_cpu(out->value);
+		/*
+		 * To prevent failing boot up of some systems, Infineon TPM2.0
+		 * returns SUCCESS on TPM2_Startup in field upgrade mode. Also
+		 * the TPM2_Getcapability command returns a zero length list
+		 * in field upgrade mode.
+		 */
+		if (be32_to_cpu(out->property_cnt) > 0)
+			*value = be32_to_cpu(out->value);
+		else
+			rc = -ENODATA;
 	}
 	tpm_buf_destroy(&buf);
 	return rc;


