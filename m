Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665131E2B96
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403846AbgEZTGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403815AbgEZTGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C59C20873;
        Tue, 26 May 2020 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519998;
        bh=r/ZhJS3TFnJvUkfTEaJFVxbdWUpnvSUCDvWHnEm187c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWFyoEKShB8j7mse37uxZiz4IpO1xvYs2vGg7v7YCpyck0n1kfKkmHEi1aPy9guXn
         6X3iPMEuTHkRtBGbSp+Z5P/G+eqU7WuEissMO39k4TF2rz2QmZZGBuyQV0iNifNv57
         AaNwMrsPeNA0TH3R7HP0LhrxFiIcnoELZQnV2eh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/111] net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()
Date:   Tue, 26 May 2020 20:52:37 +0200
Message-Id: <20200526183934.486055216@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1cd9b3abf5332102d4d967555e7ed861a75094bf ]

In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.

The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
from being 'm' when NET_DEVLINK=y.

With the planned Kconfig change that relaxes the 'imply', the
combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.

Use IS_REACHABLE() to avoid the vmlinux link error for this case.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/drop_monitor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
index 2ab668461463..f68bc373544a 100644
--- a/include/net/drop_monitor.h
+++ b/include/net/drop_monitor.h
@@ -19,7 +19,7 @@ struct net_dm_hw_metadata {
 	struct net_device *input_dev;
 };
 
-#if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
+#if IS_REACHABLE(CONFIG_NET_DROP_MONITOR)
 void net_dm_hw_report(struct sk_buff *skb,
 		      const struct net_dm_hw_metadata *hw_metadata);
 #else
-- 
2.25.1



