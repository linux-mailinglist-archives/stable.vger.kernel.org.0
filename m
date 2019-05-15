Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED61F128
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbfEOLV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbfEOLV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:21:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B966F206BF;
        Wed, 15 May 2019 11:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919288;
        bh=llpclzGwnL3zP91thyCqSmhhwD6Du3MwcCp19NEdLtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2Y5JQhstPuY3Ac66HkvSNV0XbhJ9HE2LoUbficFDzNoCMlmHO8VJ+Gf90RcEa09+
         SR5wOUmDdrAqw9Zyxb3+fvDiO4NhCvCLibTGnbCB89Z/nA/kO5Cy8QxM2a2jlOnITS
         W+WDtKswUK3eQDW0y1o1okLXbCDHK/xWxMrVn4P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/113] mac80211: fix unaligned access in mesh table hash function
Date:   Wed, 15 May 2019 12:55:10 +0200
Message-Id: <20190515090654.939869893@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 40586e3fc400c00c11151804dcdc93f8c831c808 ]

The pointer to the last four bytes of the address is not guaranteed to be
aligned, so we need to use __get_unaligned_cpu32 here

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c3a7396fb9556..49a90217622bd 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -23,7 +23,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl, struct mesh_path *mpath);
 static u32 mesh_table_hash(const void *addr, u32 len, u32 seed)
 {
 	/* Use last four bytes of hw addr as hash index */
-	return jhash_1word(*(u32 *)(addr+2), seed);
+	return jhash_1word(__get_unaligned_cpu32((u8 *)addr + 2), seed);
 }
 
 static const struct rhashtable_params mesh_rht_params = {
-- 
2.20.1



