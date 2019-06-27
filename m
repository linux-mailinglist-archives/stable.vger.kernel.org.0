Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4858B578B7
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfF0AbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbfF0AbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:11 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63AA217D9;
        Thu, 27 Jun 2019 00:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595470;
        bh=C/S+sNG+v+PTJKx8SasDZ3EpwV/OjcDAbK3N53syDAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7Lg9MGekNe5cpG9tePCq82ol3WZKSDNGN76GclciVtmyR/+i6peSlRkFUpv+TjSQ
         HDmWDe/1xYQZdRj6iwkNfz47/RTk6PHhWRMwHaPIEibNZKoX99rkhdBApRiWnVHvHz
         GBshGfHOQeiN+rFa3bMkAa3aNp0uE9xuNwvjg/v8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 15/95] soundwire: stream: fix out of boundary access on port properties
Date:   Wed, 26 Jun 2019 20:29:00 -0400
Message-Id: <20190627003021.19867-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 03ecad90d3798be11b033248bbd4bbff4425a1c7 ]

Assigning local iterator to array element and using it again for
indexing would cross the array boundary.
Fix this by directly referring array element without using the local
variable.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index bd879b1a76c8..00618de2ee12 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1401,9 +1401,7 @@ struct sdw_dpn_prop *sdw_get_slave_dpn_prop(struct sdw_slave *slave,
 	}
 
 	for (i = 0; i < num_ports; i++) {
-		dpn_prop = &dpn_prop[i];
-
-		if (dpn_prop->num == port_num)
+		if (dpn_prop[i].num == port_num)
 			return &dpn_prop[i];
 	}
 
-- 
2.20.1

