Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF0594D11
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiHPBCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344044AbiHPBAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:00:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCE8DC08B;
        Mon, 15 Aug 2022 13:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 118E6B8114A;
        Mon, 15 Aug 2022 20:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B44C433D6;
        Mon, 15 Aug 2022 20:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596600;
        bh=NkKMkHknrqEudYOT5PSgk8GZD5Ar1acRpy+li8bhK/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF/4DYqPZb/KX0MCpzhrxZZjsxuLqn7as7oRTdbhiFHa6WlQPw25yG2MLbPYGI3nv
         scDo8RFqVO515xpEyV+wIAxPRgF5W3zewtp48U44Nod4BnNH550Uc4hdONlmvYI0R2
         B9Gdpn66UZ44izxiYMhJhJdHEKFQd1uDnGds4PsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1132/1157] tpm: Add check for Failure mode for TPM2 modules
Date:   Mon, 15 Aug 2022 20:08:08 +0200
Message-Id: <20220815180525.685846400@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index c1eb5d223839..65d03867e114 100644
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
 	/*
-- 
2.35.1



