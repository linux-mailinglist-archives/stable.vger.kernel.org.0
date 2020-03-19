Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6235418B6EB
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgCSN3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730113AbgCSNXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9414C20724;
        Thu, 19 Mar 2020 13:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624229;
        bh=iUS63HzURkdNWPqhwTnoxFpkn4beUpwEPN/ZA6lYULI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5i9Xb8d4vt2Iq/F4gXZjW2u8hRC6pY8OQBydyUtrHjTDR5kCabJ4E9Mqd7LUMnzo
         rfeYMFBoGfLIxk7hZeiSF2zaXtdX2TAa8KDFrxGd2MR1zVRmVeWFbMHvonmCkZTjWc
         yZhhqC5zPbrhBo8aH/AMUUEdjc8t0vBFuW6QTp4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/60] cfg80211: check reg_rule for NULL in handle_channel_custom()
Date:   Thu, 19 Mar 2020 14:04:01 +0100
Message-Id: <20200319123926.711932098@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
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
index fff9a74891fc4..1a8218f1bbe07 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2276,7 +2276,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 			break;
 	}
 
-	if (IS_ERR(reg_rule)) {
+	if (IS_ERR_OR_NULL(reg_rule)) {
 		pr_debug("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			 chan->center_freq);
 		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
-- 
2.20.1



