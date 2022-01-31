Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5355D4A4106
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiAaLBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48518 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbiAaLAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21614B82A62;
        Mon, 31 Jan 2022 11:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D544C340E8;
        Mon, 31 Jan 2022 11:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626843;
        bh=GZs9L7T9/6ZSXdD31buqSGJavwQTf+8MmVZed58b7SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv9LgpoeGUL7Wmf7oqHg17ZJBJAObTt0ituSXn/YHqWrUjg64w9abCwARJJckzp8F
         kZrLkFej3mo6QXXeRAK8RAoHRUoAbWuQG3WYy2oc+6VvqBNONFb67o86TusDX7QzXM
         k9DFwmCwj4kPq5IvA0Rm6IcGzp2MCJyVBibRr2qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/64] yam: fix a memory leak in yam_siocdevprivate()
Date:   Mon, 31 Jan 2022 11:56:42 +0100
Message-Id: <20220131105217.601561681@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 29eb31542787e1019208a2e1047bb7c76c069536 ]

ym needs to be free when ym->cmd != SIOCYAMSMCS.

Fixes: 0781168e23a2 ("yam: fix a missing-check bug")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/yam.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5ab53e9942f30..5d30b3e1806ab 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -951,9 +951,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				 sizeof(struct yamdrv_ioctl_mcs));
 		if (IS_ERR(ym))
 			return PTR_ERR(ym);
-		if (ym->cmd != SIOCYAMSMCS)
-			return -EINVAL;
-		if (ym->bitrate > YAM_MAXBITRATE) {
+		if (ym->cmd != SIOCYAMSMCS || ym->bitrate > YAM_MAXBITRATE) {
 			kfree(ym);
 			return -EINVAL;
 		}
-- 
2.34.1



