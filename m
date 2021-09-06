Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA8E4012BB
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhIFBWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238822AbhIFBVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008A46103C;
        Mon,  6 Sep 2021 01:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891241;
        bh=K4uaTHapmH3U6xH9ucIb0nunIP0v4qwcdxnoKEqCHMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrCi+8eWN/a6RHkTa53qAHjT1qISYZQjwr4wH/PwNr4+MT4WNMJySt8yo7Ws7Wyie
         Oy/F+vJgwBc5dW63wk/PV8Ut5Fwn/FOEJi22HwuRIIjSnai6KQ+7NLJCo7U2Q899ll
         PzFE20X+unDjWwefgH/V6w7S2k/zW/OB1rKDMnO7O3Vy6Ws/Pr8sUqCj/6JaBz7Zzm
         FH8tHn3oNaTCpq/uh4gUKYPKHLhmJCxvau3DxEQ8RG5HPsHOYQ8/xiTxnZGSWXaFmF
         xcSl0hAgjR5jG9CNC+kY/bgyVStxZ3n7DRjFL/04/vqOkTtpA4ZLQnSXNVLv2X8LOy
         EtETa0TYWlIRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stian Skjelstad <stian.skjelstad@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 40/47] udf_get_extendedattr() had no boundary checks.
Date:   Sun,  5 Sep 2021 21:19:44 -0400
Message-Id: <20210906011951.928679-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stian Skjelstad <stian.skjelstad@gmail.com>

[ Upstream commit 58bc6d1be2f3b0ceecb6027dfa17513ec6aa2abb ]

When parsing the ExtendedAttr data, malicous or corrupt attribute length
could cause kernel hangs and buffer overruns in some special cases.

Link: https://lore.kernel.org/r/20210822093332.25234-1-stian.skjelstad@gmail.com
Signed-off-by: Stian Skjelstad <stian.skjelstad@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/misc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index eab94527340d..1614d308d0f0 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -173,13 +173,22 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 		else
 			offset = le32_to_cpu(eahd->appAttrLocation);
 
-		while (offset < iinfo->i_lenEAttr) {
+		while (offset + sizeof(*gaf) < iinfo->i_lenEAttr) {
+			uint32_t attrLength;
+
 			gaf = (struct genericFormat *)&ea[offset];
+			attrLength = le32_to_cpu(gaf->attrLength);
+
+			/* Detect undersized elements and buffer overflows */
+			if ((attrLength < sizeof(*gaf)) ||
+			    (attrLength > (iinfo->i_lenEAttr - offset)))
+				break;
+
 			if (le32_to_cpu(gaf->attrType) == type &&
 					gaf->attrSubtype == subtype)
 				return gaf;
 			else
-				offset += le32_to_cpu(gaf->attrLength);
+				offset += attrLength;
 		}
 	}
 
-- 
2.30.2

