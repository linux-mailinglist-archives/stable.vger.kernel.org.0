Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D23F661E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhHXRU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240448AbhHXRSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95DC615E1;
        Tue, 24 Aug 2021 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824579;
        bh=ywLVauCDzDNXw2hG1eGiH7z52eUYR6QHZDN39swFfgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNllUMiDXT0oc6VjN8mdwpGIfQIwGHszTWjtHiEMUe54Z89zGVW278El/fonj7R+j
         zQgJf+UbZCjnVTiC30aY8eKigCbvFXMFBPU2YaP8brg8eIaqBk7u3y/B14gP+CabSu
         M7uogrAaRUG/rRX+CZj+CbakGcvMuqKkBPlvi1osRvndnIEGj7Q+YMTEPJS30k8fx9
         VNzwmxLJVGHAWPNxfiYCO2sXaLm1Tu0Jk7oOIBy3nvivDe7397iYXuVnrhvFcD0H+x
         /SEYScKQ7ADiegzyBONXyeeGz1KCtnrRQnPIf54PXzmEiTIR9ktjaFji239R+qeJgx
         n/yuyCIIyzy3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/84] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
Date:   Tue, 24 Aug 2021 13:01:33 -0400
Message-Id: <20210824170250.710392-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 889d0e7dc68314a273627d89cbb60c09e1cc1c25 ]

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
must be present to fix GPF.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210707155633.1486603-1-mudongliangabcd@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 82f3fbda7dfe..ed60e691cc2b 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -432,7 +432,7 @@ static int hwsim_new_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-- 
2.30.2

