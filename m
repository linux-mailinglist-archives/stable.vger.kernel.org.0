Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81CE498D7E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353069AbiAXTci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352382AbiAXTaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42514B8122F;
        Mon, 24 Jan 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B42C340E7;
        Mon, 24 Jan 2022 19:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052614;
        bh=PFeTHSrNpzz1bgPoR2Teyu2aWXU6Hm+6TN+LgWwf3lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrBITipzEvpw0KcRjL6d/VnQnoa+TEjGC4j/XmH/NNCmhOh0BBReI7nJqv/AO8PYc
         9jnpxB8iZ2ahVe29VVAG7X0wfqD9goAZrhmcMgeZzzOA0n7raMJoGoSlYtUKs0sljM
         bkO5qUhcSBhJw+SyIyBi8gozg7TbLARYGsMb0wvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/320] tpm: add request_locality before write TPM_INT_ENABLE
Date:   Mon, 24 Jan 2022 19:41:41 +0100
Message-Id: <20220124183957.676049670@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 2fe26ec03552b..70f7859942287 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -877,7 +877,15 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
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



