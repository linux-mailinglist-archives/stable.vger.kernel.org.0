Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA6E499AED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574197AbiAXVsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457320AbiAXVl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D65C07A944;
        Mon, 24 Jan 2022 12:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E1DCB81255;
        Mon, 24 Jan 2022 20:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B13C340E5;
        Mon, 24 Jan 2022 20:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056070;
        bh=zspjBTPA65ubtgbkRw3QgH1nHju9jZUDsFEcbrEiT9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzDOeoUIlQiDGjimS0n4gjBaeSYZdhrGIdbx3dBcNYmI3GLnrkJ8dIVOMS4v0n/6k
         SgQVuDGWsCKmOiiqkCWGU3boQI173fTJly+CWyjmaIYXvrC9Z1cx3JT3op1ZU/naDw
         RC5gKNjBO4DEC4LHi9iTjt5hfREJj+GAyux82lr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/846] tpm_tis: Fix an error handling path in tpm_tis_core_init()
Date:   Mon, 24 Jan 2022 19:37:56 +0100
Message-Id: <20220124184113.310952890@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



