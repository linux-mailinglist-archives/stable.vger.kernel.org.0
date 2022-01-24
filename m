Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280EC49901F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352319AbiAXT6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:58:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351696AbiAXTwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:52:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E7FB60920;
        Mon, 24 Jan 2022 19:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC24C340E5;
        Mon, 24 Jan 2022 19:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053957;
        bh=zspjBTPA65ubtgbkRw3QgH1nHju9jZUDsFEcbrEiT9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8HfIj9VkZrmyCnYROBtyVinJBCr3DBldeKOkGeLt3C/Mhi+MVlStMTHRUuSddhnq
         VzOfjwguvCx2sH0A0PTvxVPW1+HkYI+RlHVXFKHF2xmqlacTQG1//Vj+1TIQuKRPLd
         mesF016zkwbHL/lpmAQlggQBd7NCvmmrf7s+Fks4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/563] tpm_tis: Fix an error handling path in tpm_tis_core_init()
Date:   Mon, 24 Jan 2022 19:39:57 +0100
Message-Id: <20220124184032.471516850@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



