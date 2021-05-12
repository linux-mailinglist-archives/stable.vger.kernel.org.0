Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98D937CC27
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhELQnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242422AbhELQet (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7F461CCA;
        Wed, 12 May 2021 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835173;
        bh=0IVvSVebnVdgoLKxhi56Y4juJaSbU5MhpuKJAxQaG4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZBVYL8i9rIZFsStGwzWUuJyKlPxxKjvlYCN9a4HWeqUOJOWPGWTEFZAVAJOCbnnr
         AIz8iJp7wGDVE0wy1AxyxvgPqLI9AlG3sLCYsNtKWxALjc+2jmfQILTWMkiQC06Pde
         icr0tMEx69Yfr1mqROeuDUYIAw8muPpA/C5JwldQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 238/677] soc: mediatek: pm-domains: Fix missing error code in scpsys_add_subdomain()
Date:   Wed, 12 May 2021 16:44:44 +0200
Message-Id: <20210512144845.146952957@linuxfoundation.org>
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

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 9950588a45241b0efcfc312ab0e414260ceca709 ]

Adding one power domain in scpsys_add_subdomain is missing to assign an
error code when it fails. Fix that assigning an error code to 'ret',
this also fixes the follwowing smatch warning.

  drivers/soc/mediatek/mtk-pm-domains.c:492 scpsys_add_subdomain() warn: missing error code 'ret'

Fixes: dd65030295e2 ("soc: mediatek: pm-domains: Don't print an error if child domain is deferred")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20210303091054.796975-1-enric.balletbo@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-pm-domains.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-pm-domains.c b/drivers/soc/mediatek/mtk-pm-domains.c
index b7f697666bdd..06aaf03b194c 100644
--- a/drivers/soc/mediatek/mtk-pm-domains.c
+++ b/drivers/soc/mediatek/mtk-pm-domains.c
@@ -487,8 +487,9 @@ static int scpsys_add_subdomain(struct scpsys *scpsys, struct device_node *paren
 
 		child_pd = scpsys_add_one_domain(scpsys, child);
 		if (IS_ERR(child_pd)) {
-			dev_err_probe(scpsys->dev, PTR_ERR(child_pd),
-				      "%pOF: failed to get child domain id\n", child);
+			ret = PTR_ERR(child_pd);
+			dev_err_probe(scpsys->dev, ret, "%pOF: failed to get child domain id\n",
+				      child);
 			goto err_put_node;
 		}
 
-- 
2.30.2



