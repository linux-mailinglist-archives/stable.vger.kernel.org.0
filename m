Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E166C9E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfGLMVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfGLMVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA6A21670;
        Fri, 12 Jul 2019 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934109;
        bh=pUKI/A5Oz7rfvis28dXWUiv9SGLePMjDtVFHxg5NV/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06UH63RHVWcBxDTfP6QapZLhLs7cFPfIrb+u/qimnrn/3ZkQoNORtPnzB0A0LCAkM
         to8BvrKkVo5faJ4FEiWZdo0jKUjyoBq2todFxFoXzRHSTiDxMH+eNy0ogDmo8dfalA
         lbNKAC83TAyLT8iCx2MsQ+qQ3gcowVEDP/5JsY7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        John Crispin <john@phrozen.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/91] mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()
Date:   Fri, 12 Jul 2019 14:18:11 +0200
Message-Id: <20190712121621.865066947@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
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
index aad1c8e858e5..d57e2f679a3e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1219,7 +1219,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (rate->he_dcm)
 		result /= 2;
 
-	return result;
+	return result / 10000;
 }
 
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
-- 
2.20.1



