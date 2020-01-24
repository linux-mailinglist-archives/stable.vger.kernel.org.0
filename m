Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC0C147F48
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbgAXLBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387515AbgAXLBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD5F2087E;
        Fri, 24 Jan 2020 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863663;
        bh=A/m/83iiO/OgDRj1Jf2CenkpxzHXvhOCBbjJyAM1yOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ/psPuHV3Hmv4dfOp1zJu925YJLo4fpRBkukPIhOPEU5bUq39s5BdwTm9t2NVBTt
         WN0kwTQWgvQt6eGzs0mR0e7q1Cip/3Ae8g5BkZCEtNeO92PEq3bvReKPsJ+vXBSLqq
         bNtO89Kj5YsP/t6NGNQq1KRopfAUgWKF0E3ApibE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/639] cfg80211: regulatory: make initialization more robust
Date:   Fri, 24 Jan 2020 10:23:31 +0100
Message-Id: <20200124093052.593172030@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 71e5e886806ee3f8e0c44ed945eb2e4d6659c6e3 ]

Since my change to split out the regulatory init to occur later,
any issues during earlier cfg80211_init() or errors during the
platform device allocation would lead to crashes later. Make this
more robust by checking that the earlier initialization succeeded.

Fixes: d7be102f2945 ("cfg80211: initialize regulatory keys/database later")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 64841238df855..5643bdee7198f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3870,6 +3870,15 @@ static int __init regulatory_init_db(void)
 {
 	int err;
 
+	/*
+	 * It's possible that - due to other bugs/issues - cfg80211
+	 * never called regulatory_init() below, or that it failed;
+	 * in that case, don't try to do any further work here as
+	 * it's doomed to lead to crashes.
+	 */
+	if (IS_ERR_OR_NULL(reg_pdev))
+		return -EINVAL;
+
 	err = load_builtin_regdb_keys();
 	if (err)
 		return err;
-- 
2.20.1



