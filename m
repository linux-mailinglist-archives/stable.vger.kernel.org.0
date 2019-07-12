Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7B66EB6
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfGLMkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbfGLMZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE88321019;
        Fri, 12 Jul 2019 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934320;
        bh=DDcxO7wSGYZlws8b7PBLpP2BhHVd7B9Pkx8sqcmCuvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoXe/Ry53tBk0qJmlvXmTpQP18NfqOTWaMyfwdHLhutsqnyOD1FrXI/AOHCG0RVgF
         jcENg28mMWgzhx2bsK+AjsYBG07/fGKpojxnqg30WZM148ED5/JmwMl5tAOy8oM0iI
         /vPcs/ImtZjSW5Th8/HRTmPXGvByI/smIa3S7xgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 017/138] soundwire: stream: fix out of boundary access on port properties
Date:   Fri, 12 Jul 2019 14:18:01 +0200
Message-Id: <20190712121629.380616400@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



