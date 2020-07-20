Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C152269FF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbgGTQbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731900AbgGTP5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EF9F20773;
        Mon, 20 Jul 2020 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260641;
        bh=8XBiIIM2ZhO6OoYw5nlgsaf5HZEYTl2YmfjS4xfYdSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAULP6fPLJAs+RfspP/r1EGwAGIP6v1OrBEb+WN5mpLv/zQ3yw94vFOQutmuPqqsL
         lwk6Z6wpCihDE3nUOZiv46tIGX14eKbC3UTM1w5m/b4Xkhb6yC4Hp5+xVHp9paGHSI
         cIryUUCuxDgNpbEKgaP8e5CjLwru2pNn5A82m0D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/215] tpm_tis: extra chip->ops check on error path in tpm_tis_core_init
Date:   Mon, 20 Jul 2020 17:35:24 +0200
Message-Id: <20200720152822.195109454@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit ccf6fb858e17a8f8a914a1c6444d277cfedfeae6 ]

Found by smatch:
drivers/char/tpm/tpm_tis_core.c:1088 tpm_tis_core_init() warn:
 variable dereferenced before check 'chip->ops' (see line 979)

'chip->ops' is assigned in the beginning of function
in tpmm_chip_alloc->tpm_chip_alloc
and is used before first possible goto to error path.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index bdcf8f25cd0d0..63f6bed78d893 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1006,7 +1006,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 
 	return 0;
 out_err:
-	if ((chip->ops != NULL) && (chip->ops->clk_enable != NULL))
+	if (chip->ops->clk_enable != NULL)
 		chip->ops->clk_enable(chip, false);
 
 	tpm_tis_remove(chip);
-- 
2.25.1



