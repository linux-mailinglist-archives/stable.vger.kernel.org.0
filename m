Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B962ACE0A
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbfIHMtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731762AbfIHMtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:51 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395D021920;
        Sun,  8 Sep 2019 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946990;
        bh=nbV8niDWQzCo9PK2wHpxKwFDKLvpEBvq9S8Szap+6pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqapvjWWJIADTCB56JXubVvS4dCEPajFvRa7sR/CdhZcGO0WO3R0agqk/9/SN0crf
         Gqiy2u+Axhlvylb7PjwHRxMkKV5xOY5pGQhhFtJuV8+DHcmwJpYAnmvLHUdRRUdTVU
         F0R8nesN8OYnOYewb+Zyzyw1iyYfegJTQTNwwshw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 20/94] batman-adv: Fix netlink dumping of all mcast_flags buckets
Date:   Sun,  8 Sep 2019 13:41:16 +0100
Message-Id: <20190908121151.017103628@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fa3a03da549a889fc9dbc0d3c5908eb7882cac8f ]

The bucket variable is only updated outside the loop over the mcast_flags
buckets. It will only be updated during a dumping run when the dumping has
to be interrupted and a new message has to be started.

This could result in repeated or missing entries when the multicast flags
are dumped to userspace.

Fixes: d2d489b7d851 ("batman-adv: Add inconsistent multicast netlink dump detection")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index ec54e236e3454..50fe9dfb088b6 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -1653,7 +1653,7 @@ __batadv_mcast_flags_dump(struct sk_buff *msg, u32 portid,
 
 	while (bucket_tmp < hash->size) {
 		if (batadv_mcast_flags_dump_bucket(msg, portid, cb, hash,
-						   *bucket, &idx_tmp))
+						   bucket_tmp, &idx_tmp))
 			break;
 
 		bucket_tmp++;
-- 
2.20.1



