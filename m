Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671D018A69B
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgCRVJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbgCRUxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6196208CA;
        Wed, 18 Mar 2020 20:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564827;
        bh=bo1kmxKygf1+05+yVGvsocCAXK1sIxbPtOqlS/ftcrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTrAdIPtOLxwshkkanD4QxprvF/0Q3KWGIvdpp8fmiVhPr4ZHvE/hqa7sZhEy9ZKG
         aQQ0oSfFEGU562P8hcwJp9SHKE9L6sK9uVqiRWqT0nSQqjH/tV6wObBgnZaCgOx7qL
         MijxIQzpFEMiqyBGpcZTOqWeNFziFdeI7+mBC8ns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/73] pinctrl: core: Remove extra kref_get which blocks hogs being freed
Date:   Wed, 18 Mar 2020 16:52:32 -0400
Message-Id: <20200318205337.16279-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit aafd56fc79041bf36f97712d4b35208cbe07db90 ]

kref_init starts with the reference count at 1, which will be balanced
by the pinctrl_put in pinctrl_unregister. The additional kref_get in
pinctrl_claim_hogs will increase this count to 2 and cause the hogs to
not get freed when pinctrl_unregister is called.

Fixes: 6118714275f0 ("pinctrl: core: Fix pinctrl_register_and_init() with pinctrl_enable()")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200228154142.13860-1-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2bbd8ee935075..6381745e3bb18 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2025,7 +2025,6 @@ static int pinctrl_claim_hogs(struct pinctrl_dev *pctldev)
 		return PTR_ERR(pctldev->p);
 	}
 
-	kref_get(&pctldev->p->users);
 	pctldev->hog_default =
 		pinctrl_lookup_state(pctldev->p, PINCTRL_STATE_DEFAULT);
 	if (IS_ERR(pctldev->hog_default)) {
-- 
2.20.1

