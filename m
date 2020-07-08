Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D083D218BE5
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgGHPm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730642AbgGHPmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:42:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 710D420720;
        Wed,  8 Jul 2020 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222925;
        bh=9R5qCD+xKMNoXqsCLklYv2WYXTd1y0xTvOQ8L4C5nlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2Z//uEW9BwmFb99SsBZa1udsFniEAZc37NNM5QfrtBoDF4ouyrNBX4Irf3YqGYcM
         0OQ3f4SSdFYYJ22Nm4wfvkSGA2IcKeMHZNEa90fe7iAs9RMpz6rfuCROaBOs/z10kD
         NSC8Lzlz1eAhPd9cpVsmJHM/GTVGMdIp2HoOCWxY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/8] tpm_tis: extra chip->ops check on error path in tpm_tis_core_init
Date:   Wed,  8 Jul 2020 11:41:54 -0400
Message-Id: <20200708154157.3200116-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154157.3200116-1-sashal@kernel.org>
References: <20200708154157.3200116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5d8f8f018984d..280d60cba1f8c 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1007,7 +1007,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 
 	return 0;
 out_err:
-	if ((chip->ops != NULL) && (chip->ops->clk_enable != NULL))
+	if (chip->ops->clk_enable != NULL)
 		chip->ops->clk_enable(chip, false);
 
 	tpm_tis_remove(chip);
-- 
2.25.1

