Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC7A27C666
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgI2Lot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730892AbgI2Loj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED2C20702;
        Tue, 29 Sep 2020 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379879;
        bh=6WsAP6oYaEi5qf4frf0uSrvl1iykS3EOWOBorPfZp9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc0mqnxwLeA+m8fnaZSMu4ZLEnSYS2wMN19c2d/YJ95YXssK5GLOJV+X77F/a0Eiq
         vQNaxXF1xn1yJVW3cZBlzTNJ4R1G8beQnldiqhhvJkdCrjUF1B9r6GAcduawgxLwJx
         lCFV4x2dwf9vQ1qXSosv2ROVhQOpQgBBtcYjTDxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 358/388] lib80211: fix unmet direct dependendices config warning when !CRYPTO
Date:   Tue, 29 Sep 2020 13:01:29 +0200
Message-Id: <20200929110027.795764686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit b959ba9f468b1c581f40e92661ad58b093abaa03 ]

When LIB80211_CRYPT_CCMP is enabled and CRYPTO is disabled, it results in unmet
direct dependencies config warning. The reason is that LIB80211_CRYPT_CCMP
selects CRYPTO_AES and CRYPTO_CCM, which are subordinate to CRYPTO. This is
reproducible with CRYPTO disabled and R8188EU enabled, where R8188EU selects
LIB80211_CRYPT_CCMP but does not select or depend on CRYPTO.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: a11e2f85481c ("lib80211: use crypto API ccm(aes) transform for CCMP processing")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://lore.kernel.org/r/20200909095452.3080-1-fazilyildiran@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 63cf7131f601c..211007c091d59 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -217,6 +217,7 @@ config LIB80211_CRYPT_WEP
 
 config LIB80211_CRYPT_CCMP
 	tristate
+	select CRYPTO
 	select CRYPTO_AES
 	select CRYPTO_CCM
 
-- 
2.25.1



