Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B9A37CC90
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbhELQpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234846AbhELQhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:37:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436076194C;
        Wed, 12 May 2021 16:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835363;
        bh=J+KCR/JHuFNb5leR5t7iNHJ9NMLQiyDLagRuTdZTMWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2Gfnw9Yao4cA9M/ShCRXmjBs1d8+DZ/Hxwq9ydjtIL11ZX0NHsmOFxHAaF/lM9gM
         OWYg45thkNq6Uy9231htx+JlZbBu+cWHXW3IIdGGOdFu9pm6XvilLtkK38KoabdgEd
         wH8qIt3A2IjKnl2w1XUqNZYB5dwR4MhhWzCRTBsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 315/677] char: tpm: fix error return code in tpm_cr50_i2c_tis_recv()
Date:   Wed, 12 May 2021 16:46:01 +0200
Message-Id: <20210512144847.681716557@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 3d785d73b4c1014839d9f9af0ee526f8d5706a73 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3a253caaad11 ("char: tpm: add i2c driver for cr50")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_i2c_cr50.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_tis_i2c_cr50.c b/drivers/char/tpm/tpm_tis_i2c_cr50.c
index ec9a65e7887d..f19c227d20f4 100644
--- a/drivers/char/tpm/tpm_tis_i2c_cr50.c
+++ b/drivers/char/tpm/tpm_tis_i2c_cr50.c
@@ -483,6 +483,7 @@ static int tpm_cr50_i2c_tis_recv(struct tpm_chip *chip, u8 *buf, size_t buf_len)
 	expected = be32_to_cpup((__be32 *)(buf + 2));
 	if (expected > buf_len) {
 		dev_err(&chip->dev, "Buffer too small to receive i2c data\n");
+		rc = -E2BIG;
 		goto out_err;
 	}
 
-- 
2.30.2



