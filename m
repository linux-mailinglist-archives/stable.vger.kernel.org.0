Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929DD26FDD
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfEVT7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730870AbfEVTXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:23:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D4DC2173C;
        Wed, 22 May 2019 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553004;
        bh=AGbvE1qAgHxbpS5g4jJ4OEIjLr+GAfO0a8RcO+5NDSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InNxT5Yt0mtqRxt08qqHPgQlNfg0H4BYl2wrZ96DzDQxKTEj8I+8m8+5MssUQpgQB
         O8NOF8/7s5+AtnnpjKeSD/SRkJzaOEHalvWHJSWPMImvtEThpOEiNhP6Ys5JA+miZ8
         0O1c0YqWQv/xwX/hNcDEiWETR1j083fkCqJ8TGiQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 072/375] s390: qeth: address type mismatch warning
Date:   Wed, 22 May 2019 15:16:12 -0400
Message-Id: <20190522192115.22666-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 46b83629dede262315aa82179d105581f11763b6 ]

clang produces a harmless warning for each use for the qeth_adp_supported
macro:

drivers/s390/net/qeth_l2_main.c:559:31: warning: implicit conversion from enumeration type 'enum qeth_ipa_setadp_cmd' to
      different enumeration type 'enum qeth_ipa_funcs' [-Wenum-conversion]
        if (qeth_adp_supported(card, IPA_SETADP_SET_PROMISC_MODE))
            ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/s390/net/qeth_core.h:179:41: note: expanded from macro 'qeth_adp_supported'
        qeth_is_ipa_supported(&c->options.adp, f)
        ~~~~~~~~~~~~~~~~~~~~~                  ^

Add a version of this macro that uses the correct types, and
remove the unused qeth_adp_enabled() macro that has the same
problem.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index c851cf6e01c43..d603dfea97ab2 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -163,6 +163,12 @@ struct qeth_vnicc_info {
 	bool rx_bcast_enabled;
 };
 
+static inline int qeth_is_adp_supported(struct qeth_ipa_info *ipa,
+		enum qeth_ipa_setadp_cmd func)
+{
+	return (ipa->supported_funcs & func);
+}
+
 static inline int qeth_is_ipa_supported(struct qeth_ipa_info *ipa,
 		enum qeth_ipa_funcs func)
 {
@@ -176,9 +182,7 @@ static inline int qeth_is_ipa_enabled(struct qeth_ipa_info *ipa,
 }
 
 #define qeth_adp_supported(c, f) \
-	qeth_is_ipa_supported(&c->options.adp, f)
-#define qeth_adp_enabled(c, f) \
-	qeth_is_ipa_enabled(&c->options.adp, f)
+	qeth_is_adp_supported(&c->options.adp, f)
 #define qeth_is_supported(c, f) \
 	qeth_is_ipa_supported(&c->options.ipa4, f)
 #define qeth_is_enabled(c, f) \
-- 
2.20.1

