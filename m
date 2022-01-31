Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A630F4A4494
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376777AbiAaLbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377129AbiAaLZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A78A9612FD;
        Mon, 31 Jan 2022 11:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A462C340E8;
        Mon, 31 Jan 2022 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628354;
        bh=bm1Lx8hxm/2CKZpcBvY4tg2wsS1v7I9TTSIO3pmp6Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0BEK9NIDO1n6diQBlzx01+LZoHRHEgQtXYv0XjygVN0I8olvJmufom2RjVY6PdUD
         +vSRv0nylH23mTLfu/z5CDkusI76j6P179K9nYl255XcKzT6u1N5xOn+bGjrpGYX09
         WHPm8/azpn8kY7CKCpXolvnaQol6j+9RCJtnVOs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 172/200] yam: fix a memory leak in yam_siocdevprivate()
Date:   Mon, 31 Jan 2022 11:57:15 +0100
Message-Id: <20220131105239.340611596@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
index 6376b8485976c..980f2be32f05a 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -950,9 +950,7 @@ static int yam_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __
 		ym = memdup_user(data, sizeof(struct yamdrv_ioctl_mcs));
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



