Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0AF66D39
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfGLM1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbfGLM1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:27:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D36A2084B;
        Fri, 12 Jul 2019 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934465;
        bh=Z2D7VmgLRn4bBj7uuHlx3DG9p9aGq6l3mqAOp7Iv3BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRa/EMxSj0rRejAqfIHcLOd/Fi3C/LMCQW+euLmQ0juAmOqPbGzwFFz3/tUO/3Z88
         Gp39LRKGjXXYWVuXVjZEXGfhl+4Ilv+BlC9d9xFTIF5P4Ad1Nqypev9LZuRkKwktR5
         JlOA1j/LhcwCc9NkFLdHfxrQCpf2K400oXj7EuYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 063/138] cfg80211: report measurement start TSF correctly
Date:   Fri, 12 Jul 2019 14:18:47 +0200
Message-Id: <20190712121631.095478375@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b65842025335711e2a0259feb4dbadb0c9ffb6d9 ]

Instead of reporting the AP's TSF, host time was reported. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 5e2ab01d325c..d06d514f0bba 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  */
 #ifndef __PMSR_H
 #define __PMSR_H
@@ -446,7 +446,7 @@ static int nl80211_pmsr_send_result(struct sk_buff *msg,
 
 	if (res->ap_tsf_valid &&
 	    nla_put_u64_64bit(msg, NL80211_PMSR_RESP_ATTR_AP_TSF,
-			      res->host_time, NL80211_PMSR_RESP_ATTR_PAD))
+			      res->ap_tsf, NL80211_PMSR_RESP_ATTR_PAD))
 		goto error;
 
 	if (res->final && nla_put_flag(msg, NL80211_PMSR_RESP_ATTR_FINAL))
-- 
2.20.1



