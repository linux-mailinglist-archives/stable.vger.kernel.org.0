Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904FF401470
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbhIFBdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351692AbhIFBa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38DF761222;
        Mon,  6 Sep 2021 01:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891454;
        bh=dfQULT2cZ6sVpSpjD1dVGD4rSCxzCafGOvflM4ZVMDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkYOQFG64YwwlJ1740ZCRoI2r5LkJ0atpyFMXC3jBV0kUCwHSn2kJ0TztFf1GfZ+u
         kUfXglqF9HXGUxAldlX94vzknzgA4Ezzh50dJh5ZIqL1KTqcIEOX7joh65gj0eJ7dZ
         DPpCa+nmmJikBhw07yHunngz7s+GYTCouELsi0YgQ5l9qJOidPLQPn+vxdU/YyKoV7
         ayiXyHMRpSdyyTVk9slnOBGv4Ae1p4KFvNrdGCaLSdA0toE9CXYMwc9YCoZ4qx4MNX
         jT8vIrQPVYIzjQW6nhsgECtE8zNdrrEzU/p5cbt4xlViamcASBJ3ZX/wxXHnLqLakH
         wdIn6DT6WbuEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stian Skjelstad <stian.skjelstad@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 17/17] udf_get_extendedattr() had no boundary checks.
Date:   Sun,  5 Sep 2021 21:23:52 -0400
Message-Id: <20210906012352.930954-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012352.930954-1-sashal@kernel.org>
References: <20210906012352.930954-1-sashal@kernel.org>
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
index 3949c4bec3a3..e5f4dcde309f 100644
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

