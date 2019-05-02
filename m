Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60CD11E34
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfEBP1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbfEBP1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:27:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7E520675;
        Thu,  2 May 2019 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810820;
        bh=JQbYPHIpqP8fqYTV7zW572CvJ9OkL86ocBrnCAKxIwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTb0L0scw2rXGGZRsiIjlzPsa+ByVsdFHk7+Exw3tAgkUvClry/iHtZQQqZyeD+jY
         WVNzHFwy6Lfw3yyzi5bsxz00OhMrxZxzf2e5RflGxJgIEZz+NatsS9hjrqCfN2AGIq
         By795rdyQyDuyYKcxLnPox+6Y3oCwbN5LGVCTvC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Mukesh Ojha <mojha@codeaurora.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 40/72] staging: rtlwifi: Fix potential NULL pointer dereference of kzalloc
Date:   Thu,  2 May 2019 17:21:02 +0200
Message-Id: <20190502143336.695229343@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6a8ca24590a2136921439b376c926c11a6effc0e ]

phydm.internal is allocated using kzalloc which is used multiple
times without a check for NULL pointer. This patch avoids such a
scenario by returning 0, consistent with the failure case.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/staging/rtlwifi/phydm/rtl_phydm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtlwifi/phydm/rtl_phydm.c b/drivers/staging/rtlwifi/phydm/rtl_phydm.c
index 9930ed954abb..4cc77b2016e1 100644
--- a/drivers/staging/rtlwifi/phydm/rtl_phydm.c
+++ b/drivers/staging/rtlwifi/phydm/rtl_phydm.c
@@ -180,6 +180,8 @@ static int rtl_phydm_init_priv(struct rtl_priv *rtlpriv,
 
 	rtlpriv->phydm.internal =
 		kzalloc(sizeof(struct phy_dm_struct), GFP_KERNEL);
+	if (!rtlpriv->phydm.internal)
+		return 0;
 
 	_rtl_phydm_init_com_info(rtlpriv, ic, params);
 
-- 
2.19.1



