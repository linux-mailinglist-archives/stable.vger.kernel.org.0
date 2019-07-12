Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355C166EB0
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfGLMZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbfGLMZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992AD2171F;
        Fri, 12 Jul 2019 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934314;
        bh=foU8/SdRjmkg8g68VdEPgAvGDd0f6MXFPOujEykaolc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noCDBPPWXBkBB/ajvbAdlks9eXXuoeWRupleZHK2yMYqtpqo0snyM1wfnxdeqKFsH
         +GGuBhC18GgYKUTkyGBVZUVcdXo/18DNvnlv4hsLGVdQMmGSVwcKpThjMA0TLX+MWZ
         sWeV3jsjjM9SUB0AI7vhBFbQbL9XjdKMHz2+crXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        John Crispin <john@phrozen.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 015/138] mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()
Date:   Fri, 12 Jul 2019 14:17:59 +0200
Message-Id: <20190712121629.308138963@linuxfoundation.org>
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

[ Upstream commit 25d16d124a5e249e947c0487678b61dcff25cf8b ]

The reported rate is not scaled down correctly. After applying this patch,
the function will behave just like the v/ht equivalents.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 75899b62bdc9..5a03f38788e7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1237,7 +1237,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (rate->he_dcm)
 		result /= 2;
 
-	return result;
+	return result / 10000;
 }
 
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
-- 
2.20.1



