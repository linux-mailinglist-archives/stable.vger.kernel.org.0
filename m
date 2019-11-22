Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D71F106C9F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfKVKxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729601AbfKVKx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3186C2072E;
        Fri, 22 Nov 2019 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420006;
        bh=6ae5gLZHT9rVDPo0bjsJcFqpzYZgUkjFH0R3EQ7FAyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDLJ7GO3vngwVatEPelLFZjJMBcSIbsMHCQIbTaIO2irL44GqVjjyUF4+LUdyHdub
         SaBOD1W+eIfl3sQzpazONWbvLUj12ww9hpTQzPcDzKsVLSZcIoXgfLmycw+36GGgAQ
         OQMiC7qgYBn514Mvqbz7utzpU4uPwd0OpAIKqj7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/122] xfrm: use correct size to initialise sp->ovec
Date:   Fri, 22 Nov 2019 11:28:57 +0100
Message-Id: <20191122100824.017707589@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit f1193e915748291fb205a908db33bd3debece6e2 ]

This place should want to initialize array, not a element,
so it should be sizeof(array) instead of sizeof(element)

but now this array only has one element, so no error in
this condition that XFRM_MAX_OFFLOAD_DEPTH is 1

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 06dec32503bd6..fc0a9ce1be18f 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -130,7 +130,7 @@ struct sec_path *secpath_dup(struct sec_path *src)
 	sp->len = 0;
 	sp->olen = 0;
 
-	memset(sp->ovec, 0, sizeof(sp->ovec[XFRM_MAX_OFFLOAD_DEPTH]));
+	memset(sp->ovec, 0, sizeof(sp->ovec));
 
 	if (src) {
 		int i;
-- 
2.20.1



