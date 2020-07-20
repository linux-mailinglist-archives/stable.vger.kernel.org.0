Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF99F22650E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgGTPu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbgGTPuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:50:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5115C20657;
        Mon, 20 Jul 2020 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260224;
        bh=9R5qCD+xKMNoXqsCLklYv2WYXTd1y0xTvOQ8L4C5nlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrOG6xAHIc8fIWU8EhKElJQa4Zdec9YScSwPVZrM9pTCZe/hL5vk4frpiBFys0QMU
         MLsQ8R28nyA7IXLGJ6tVROtF/icYY37P0CJSLbXHClfTscjXPs6qq7NRIdA53QqL6l
         9RpHpNOCacQwlr4Py68jGLtsOqgm6wZjYxs0lmoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/133] tpm_tis: extra chip->ops check on error path in tpm_tis_core_init
Date:   Mon, 20 Jul 2020 17:36:12 +0200
Message-Id: <20200720152804.954496013@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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



