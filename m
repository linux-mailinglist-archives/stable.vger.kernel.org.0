Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24B1676E85
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjAVPLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjAVPLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:11:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A73E2004D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9D6B60C57
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB865C433EF;
        Sun, 22 Jan 2023 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400285;
        bh=Ml9/XpIrujd9fA8j46izKKPpTquPXiz4Gq+WV7YeRPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNn6dRe8HCaJbXAjysi14G15YwIzLCh1zaiFwKKk/EeeuM8PnczAXRxJl7PT9sBos
         JBtgHlsId5rzHuycKGuyoGywpTLQYlz7Is1RpSSVNaw/3rljkWNtjc1kPVquAzm5LB
         zXRrRRoiPs0CAPwObo6iZIuGpkk+6Ac4tAz6dmpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/98] net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
Date:   Sun, 22 Jan 2023 16:03:21 +0100
Message-Id: <20230122150229.620565267@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 9deb1e9fb88b1120a908676fa33bdf9e2eeaefce ]

It's not very useful to copy back an empty ethtool_stats struct and
return 0 if we didn't actually have any stats. This also allows for
further simplification of this function in the future commits.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 47c2dd4a9b9f..12bf740e2fb3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2052,7 +2052,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
 		return -ENOMEM;
-	WARN_ON_ONCE(!n_stats);
+	if (WARN_ON_ONCE(!n_stats))
+		return -EOPNOTSUPP;
 
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
-- 
2.35.1



