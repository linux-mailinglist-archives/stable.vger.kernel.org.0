Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E002E66CB2
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGLMW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGLMVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6455020863;
        Fri, 12 Jul 2019 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934073;
        bh=3TZaRiTzG36r8NuHyChH7usWqs7WCDmM6HmwwYcGreI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjJji5KEsSD3a/JSZg2QvNh+pPP47JmiLFISTjEk3pFcjE4bK5qgllYfLo6grQ3W5
         x5Ey+AQGzxvxJaKUuqXr5y12rotEu8A2OmyDFYHBI7g93B1rtp/HPdpbIB6qhiJuzk
         t/HNBG/n9jo03VfxeBqBLbNrjVb7XL7w6mXyEgEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Chen <zhichen@codeaurora.org>,
        Yibo Zhao <yiboz@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/91] mac80211: only warn once on chanctx_conf being NULL
Date:   Fri, 12 Jul 2019 14:18:39 +0200
Message-Id: <20190712121623.340604828@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 563572340173865a9a356e6bb02579e6998a876d ]

In multiple SSID cases, it takes time to prepare every AP interface
to be ready in initializing phase. If a sta already knows everything it
needs to join one of the APs and sends authentication to the AP which
is not fully prepared at this point of time, AP's channel context
could be NULL. As a result, warning message occurs.

Even worse, if the AP is under attack via tools such as MDK3 and massive
authentication requests are received in a very short time, console will
be hung due to kernel warning messages.

WARN_ON_ONCE() could be a better way for indicating warning messages
without duplicate messages to flood the console.

Johannes: We still need to address the underlying problem, but we
          don't really have a good handle on it yet. Suppress the
          worst side-effects for now.

Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Yibo Zhao <yiboz@codeaurora.org>
[johannes: add note, change subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 35c6dfa13fa8..24f5ced630f5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1410,7 +1410,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON(!chanctx_conf)) {
+	if (WARN_ON_ONCE(!chanctx_conf)) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.20.1



