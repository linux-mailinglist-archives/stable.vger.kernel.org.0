Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4929040145B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbhIFBdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351533AbhIFBai (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E1561221;
        Mon,  6 Sep 2021 01:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891432;
        bh=E3trja30u49PQGxLI5iO0/3F9tdhTe9oBxHfSyclHs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2SFFIvBE8YX4UbMezLflFVkNSFho2xAbmgfDDW1tXMgyEs020z8vMvbvWZAbIm4Q
         HZdrpPzk4eehpy7ppcbIG2PORr6Sqj/dFGmz2p3WbkiDaAEVXKsZNu2kA0IFAV+rr5
         iwZgnju5E5BIXWORv1eb/vPetuLh5sa0YYXPqEx5BnCQYyNmQ3q8ECw6v1Rn+IPoct
         WNZXsOFA7VWzMygt2k84qODE0BbW8QWjKbX5IhyzRvUqqEwBQ8jmN/WLDXdoKOdSXk
         bjWsyygclQ8wRfTm+M5RdnVeM2zB9/69JQmuuBHJlDVtnHU3ONKcQfDRbq9UFMhJyi
         a/WVI95C65Hug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stian Skjelstad <stian.skjelstad@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 23/23] udf_get_extendedattr() had no boundary checks.
Date:   Sun,  5 Sep 2021 21:23:22 -0400
Message-Id: <20210906012322.930668-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
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
index 401e64cde1be..853bcff51043 100644
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

