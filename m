Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8272F4013C0
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhIFB2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240723AbhIFB0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:26:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 929426117A;
        Mon,  6 Sep 2021 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891356;
        bh=K4uaTHapmH3U6xH9ucIb0nunIP0v4qwcdxnoKEqCHMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAJQZMj86OrjNFbwRcND/01J/ekamji1GS9U5GYHWI+uNrnbaIoOSEk1G0vedkIpH
         pVR0xFC9wb9LE1GY8e+5OudLL2umREVEwhskg8j+CbPnWyrbXF5SbnXIs4CKYzsflJ
         FuIXOqiKJrAhcKM2paiHu0V+x0ag2rr87FP1ooPe4GtxZ6VTzepmYfPz6XQAy1As8l
         yblE4MB2LAJzwYuNAylAFOSN0NeTza7WJdkpr4evvIW5BCMHfEl22b/osocB/eiT1i
         zrxRYBbvTYA3UL9SjbtYop/SpEt9BPuIMziPRonLPLyGAqkFu+BjxJY5sWcLbaZtgV
         cTg2irEg4sWlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stian Skjelstad <stian.skjelstad@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 34/39] udf_get_extendedattr() had no boundary checks.
Date:   Sun,  5 Sep 2021 21:21:48 -0400
Message-Id: <20210906012153.929962-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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

