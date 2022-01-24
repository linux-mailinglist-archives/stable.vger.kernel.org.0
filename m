Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35B149A2B6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365939AbiAXXwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843459AbiAXXEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8783FC06C5A6;
        Mon, 24 Jan 2022 13:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46146B8121C;
        Mon, 24 Jan 2022 21:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE0CC340E5;
        Mon, 24 Jan 2022 21:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058881;
        bh=zspjBTPA65ubtgbkRw3QgH1nHju9jZUDsFEcbrEiT9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKxCYiu/sW1KCV/IabqVm12byNDu2BqnH9DlSe3FMJ7Udxlo3SDIJO9Izmj1fKdhQ
         z6E4kTj+IhDSUjYo3Huz4Lt7PuVFQ4XYacHuqL2QSdQEeMTs37XZW3Av1yg4TtDcNL
         UJ+KEUDEz/5R8Q1AwIYYwVt5pP0Gy8C9C5dZf2Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0432/1039] tpm_tis: Fix an error handling path in tpm_tis_core_init()
Date:   Mon, 24 Jan 2022 19:37:01 +0100
Message-Id: <20220124184139.814606762@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

[ Upstream commit e96d52822f5ac0a25de78f95cd23421bcbc93584 ]

Commit 79ca6f74dae0 ("tpm: fix Atmel TPM crash caused by too frequent
queries") has moved some code around without updating the error handling
path.

This is now pointless to 'goto out_err' when neither 'clk_enable()' nor
'ioremap()' have been called yet.

Make a direct return instead to avoid undoing things that have not been
done.

Fixes: 79ca6f74dae0 ("tpm: fix Atmel TPM crash caused by too frequent queries")
Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e2df1098a812f..36d1ad8f479d7 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -952,7 +952,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &vendor);
 	if (rc < 0)
-		goto out_err;
+		return rc;
 
 	priv->manufacturer_id = vendor;
 
-- 
2.34.1



