Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1340B594A25
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353890AbiHOXjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346108AbiHOXhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:37:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D19152436;
        Mon, 15 Aug 2022 13:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09739B81135;
        Mon, 15 Aug 2022 20:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C3FC433C1;
        Mon, 15 Aug 2022 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594185;
        bh=VcECr1scfMi6H8ackDqfW47OlIEhZMW7KEnHNf/qPdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBVtPQj9O6H7UkzU0D15oZE6GayGUI7AfAyHcr9rJzPZ6etXGHnA7orR1xo4U8yei
         bx8kcah5rqBMFFMuqIMfeeiF5tEMVbjj1JgpIpaaB+udMpF1Wl+gdJdPS/9IF+DRp3
         gfmVIwV9PfGthbF4mYRcMYPiSAUs9XaHciENHBac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1069/1095] tpm: Add check for Failure mode for TPM2 modules
Date:   Mon, 15 Aug 2022 20:07:48 +0200
Message-Id: <20220815180513.262690780@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mårten Lindahl <marten.lindahl@axis.com>

[ Upstream commit 863ed94c589fcd1984f4e3080f069d30508044bb ]

In commit 0aa698787aa2 ("tpm: Add Upgrade/Reduced mode support for
TPM2 modules") it was said that:

"If the TPM is in Failure mode, it will successfully respond to both
tpm2_do_selftest() and tpm2_startup() calls. Although, will fail to
answer to tpm2_get_cc_attrs_tbl(). Use this fact to conclude that TPM
is in Failure mode."

But a check was never added in the commit when calling
tpm2_get_cc_attrs_tbl() to conclude that the TPM is in Failure mode.
This commit corrects this by adding a check.

Fixes: 0aa698787aa2 ("tpm: Add Upgrade/Reduced mode support for TPM2 modules")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 04a3e23a4afc..4419593d9531 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -752,6 +752,12 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	}
 
 	rc = tpm2_get_cc_attrs_tbl(chip);
+	if (rc == TPM2_RC_FAILURE || (rc < 0 && rc != -ENOMEM)) {
+		dev_info(&chip->dev,
+			 "TPM in field failure mode, requires firmware upgrade\n");
+		chip->flags |= TPM_CHIP_FLAG_FIRMWARE_UPGRADE;
+		rc = 0;
+	}
 
 out:
 	if (rc == TPM2_RC_UPGRADE) {
-- 
2.35.1



