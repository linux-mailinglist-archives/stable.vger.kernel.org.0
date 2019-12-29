Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C712C715
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbfL2Rxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732549AbfL2Rxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B92A206A4;
        Sun, 29 Dec 2019 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642029;
        bh=2kkJcZYZafPFoyJZFiFV9/HOohjr0+94qCi+eURcUdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihd39JO6vndtTbqmYKPcZ7v6tuI3O7IbxXivH68TjfMbVHxUGfwuT7lu/XawkoCrY
         NbfXutiXmY+vGgPt/ZQqcPA3Hi1NA4gxoFCxk7yo7zQNdsz4BTePpTL3+D3zbWKhfv
         FAukY4hJN8xq2K0hzYj944N8bHCRLTy40y4KmzhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Paillet <p.paillet@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 311/434] regulator: core: Let boot-on regulators be powered off
Date:   Sun, 29 Dec 2019 18:26:04 +0100
Message-Id: <20191229172722.611712833@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pascal Paillet <p.paillet@st.com>

[ Upstream commit 089b3f61ecfc43ca4ea26d595e1d31ead6de3f7b ]

Boot-on regulators are always kept on because their use_count value
is now incremented at boot time and never cleaned.

Only increment count value for alway-on regulators.
regulator_late_cleanup() is now able to power off boot-on regulators
when unused.

Fixes: 05f224ca6693 ("regulator: core: Clean enabling always-on regulators + their supplies")
Signed-off-by: Pascal Paillet <p.paillet@st.com>
Link: https://lore.kernel.org/r/20191113102737.27831-1-p.paillet@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 51ce280c1ce1..87bc06b386a0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1403,7 +1403,9 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 			rdev_err(rdev, "failed to enable\n");
 			return ret;
 		}
-		rdev->use_count++;
+
+		if (rdev->constraints->always_on)
+			rdev->use_count++;
 	}
 
 	print_constraints(rdev);
-- 
2.20.1



