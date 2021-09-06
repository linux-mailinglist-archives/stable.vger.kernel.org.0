Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653C840148C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351891AbhIFBd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351931AbhIFBbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C0661050;
        Mon,  6 Sep 2021 01:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891487;
        bh=ygTgi3ZOuywsl37Y3rfKuIb8lCI6FVLBpXonPSgzYwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocbcrS5JdIHOsZQLi1FCta2nLVTNOeWzkjN2DCRI2axtbCghMvyOA1G4wGCg4GDsV
         f7atlsP+IWSZOIbSu7YtMkIh+oxp1TNIu5j/7IaWHdnb21JEx1j6V1MU3raUSK5w9q
         AMqIBeF93ycf9M+Be35VYNKiUhuj4lXFOdUik+5RO314jkeErEo/NVOC3j8VX1OU4l
         ZmhtYJu3CNTjJHLyJWKWfhlRyAjQ0aNspShuo3R8S0rn88SJU2ZOPVEm/52RfQK0qc
         KrMS9Zdi8dyW3+cOnDijL5qnekxhhRaGpHtLG9x4qJHT2SXcAa+WCOMpTLMv0PJfW4
         mQoVotJOOZ10g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stian Skjelstad <stian.skjelstad@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 9/9] udf_get_extendedattr() had no boundary checks.
Date:   Sun,  5 Sep 2021 21:24:34 -0400
Message-Id: <20210906012435.931318-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012435.931318-1-sashal@kernel.org>
References: <20210906012435.931318-1-sashal@kernel.org>
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
index 71d1c25f360d..8c7f9ea251e5 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -175,13 +175,22 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
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

