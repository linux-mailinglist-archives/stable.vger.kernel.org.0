Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DC1499395
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385921AbiAXUer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34708 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383789AbiAXU1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:27:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2211EB8122C;
        Mon, 24 Jan 2022 20:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C91C340E5;
        Mon, 24 Jan 2022 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056066;
        bh=utsPrtpcWIvwCt9tvxNIxDq0GM9C7hpc0Yc/H/vxqiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtikcpBj34yj2nWAIPW0HTJhwF/GgtXpgLKK4DiSFgvckZuGTQf17yTFQE+Ms926Z
         4dWhQOnwARdF9DZfmk/Hf4jFl7Egfemzbh2tuXjpFLeqYWhcuXIxHJS+EjqDo3k7W6
         34DkSITV+iMk+gVq9QfIu4SCOMpVUqbKupCzMgP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/846] tpm: add request_locality before write TPM_INT_ENABLE
Date:   Mon, 24 Jan 2022 19:37:55 +0100
Message-Id: <20220124184113.281721674@linuxfoundation.org>
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

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 0ef333f5ba7f24f5d8478425c163d3097f1c7afd ]

Locality is not appropriately requested before writing the int mask.
Add the missing boilerplate.

Fixes: e6aef069b6e9 ("tpm_tis: convert to using locality callbacks")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index b2659a4c40168..e2df1098a812f 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -994,7 +994,15 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
+
+	rc = request_locality(chip, 0);
+	if (rc < 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
+	release_locality(chip, 0);
 
 	rc = tpm_chip_start(chip);
 	if (rc)
-- 
2.34.1



