Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F27411B8A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243483AbhITRAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243786AbhITQ5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC9686138E;
        Mon, 20 Sep 2021 16:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156702;
        bh=ygTgi3ZOuywsl37Y3rfKuIb8lCI6FVLBpXonPSgzYwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnjVsizdktTdK3x4bE95pTLo1BT9hm3oSXCU5SuO/Giq0p7fFILLbsRAbMkh1uGbv
         LEjKsFzUi/sA4zeZq31fXWTtko/6WMnekJUbC/ok12O3Cx51rFg++ZxH+b3W9aNA52
         7McmR/Gzo29fuKb27gkaKx7qCdUSdJWp37t/GDdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stian Skjelstad <stian.skjelstad@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 047/175] udf_get_extendedattr() had no boundary checks.
Date:   Mon, 20 Sep 2021 18:41:36 +0200
Message-Id: <20210920163919.594131280@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



