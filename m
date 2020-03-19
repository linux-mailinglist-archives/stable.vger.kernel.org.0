Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DE18B565
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgCSNSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbgCSNSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:18:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 998D9206D7;
        Thu, 19 Mar 2020 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623883;
        bh=mwst+dBFMWQvD2GtYzncPLfCVIHE0q3HaiZ5TbF0oAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jx4sTb/GP6TAplwtG6uZGr7D5JfR+afT9TkdmsknexV2cHSIuI+oMXIrj3scPQvl4
         KoBeWkqWJ7VBSasr0rHRZz4B5XaqRW1eE0Cy1ES9cu+798q7v6WRyo3HYlxDe9PQy4
         n/g3TjSsIeTCkhCrJ+SQYEZMuuM0zv4Ep13bHMOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 86/99] cfg80211: check reg_rule for NULL in handle_channel_custom()
Date:   Thu, 19 Mar 2020 14:04:04 +0100
Message-Id: <20200319124006.242387577@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a7ee7d44b57c9ae174088e53a668852b7f4f452d ]

We may end up with a NULL reg_rule after the loop in
handle_channel_custom() if the bandwidth didn't fit,
check if this is the case and bail out if so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200221104449.3b558a50201c.I4ad3725c4dacaefd2d18d3cc65ba6d18acd5dbfe@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a520f433d4765..b95d1c2bdef7e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1733,7 +1733,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 			break;
 	}
 
-	if (IS_ERR(reg_rule)) {
+	if (IS_ERR_OR_NULL(reg_rule)) {
 		pr_debug("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			 chan->center_freq);
 		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
-- 
2.20.1



