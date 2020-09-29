Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5817927C6DC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgI2LtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731191AbgI2LtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5806208B8;
        Tue, 29 Sep 2020 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380159;
        bh=uPVt/+A8SPP8nk6yfw0iRBBkK/tfiz8wyJFIYaXNVNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8Oclsp66iXGHqzzDU/x51trlFLKjmqQ25MpfGRf7Dt8N5tbu3zagJiT+SYuujiH0
         0McC7ZUfAorxawsML7hrucSGXqvzlSVTBJUU2XeY2EDpo6IlnHM022nu6lOKtNQOSc
         sZqY1dkgPfp4gNqLo38FTkja9Pnaal4/auJzTP7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 53/99] lib80211: fix unmet direct dependendices config warning when !CRYPTO
Date:   Tue, 29 Sep 2020 13:01:36 +0200
Message-Id: <20200929105932.338743420@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
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
index faf74850a1b52..27026f587fa61 100644
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



