Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B14F11B349
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387498AbfLKP1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:27:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387491AbfLKP1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE2CA2465B;
        Wed, 11 Dec 2019 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078073;
        bh=8mtBwPBN3NtL3DgrPx4KHMNZWOYFzJum+MD9APM3m5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7C8YSim/gWdGO/LsxResYqRSHvXJSf4YEnhzNsmns5wsLkals9U400wIBvMZPtd5
         qUwmhcvJy0AkLlyRqaO7faTf5HA1d419Zu+UpRIHcx8iZVWYjba5oEtYAlBP1rKkng
         pCQMs256CfAPS2tTwJtYme9LkEaq2idPRKfGQ9DA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 64/79] apparmor: fix unsigned len comparison with less than zero
Date:   Wed, 11 Dec 2019 10:26:28 -0500
Message-Id: <20191211152643.23056-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 00e0590dbaec6f1bcaa36a85467d7e3497ced522 ]

The sanity check in macro update_for_len checks to see if len
is less than zero, however, len is a size_t so it can never be
less than zero, so this sanity check is a no-op.  Fix this by
making len a ssize_t so the comparison will work and add ulen
that is a size_t copy of len so that the min() macro won't
throw warnings about comparing different types.

Addresses-Coverity: ("Macro compares unsigned to 0")
Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index ba11bdf9043aa..2469549842d24 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1462,11 +1462,13 @@ static inline bool use_label_hname(struct aa_ns *ns, struct aa_label *label,
 /* helper macro for snprint routines */
 #define update_for_len(total, len, size, str)	\
 do {					\
+	size_t ulen = len;		\
+					\
 	AA_BUG(len < 0);		\
-	total += len;			\
-	len = min(len, size);		\
-	size -= len;			\
-	str += len;			\
+	total += ulen;			\
+	ulen = min(ulen, size);		\
+	size -= ulen;			\
+	str += ulen;			\
 } while (0)
 
 /**
@@ -1601,7 +1603,7 @@ int aa_label_snxprint(char *str, size_t size, struct aa_ns *ns,
 	struct aa_ns *prev_ns = NULL;
 	struct label_it i;
 	int count = 0, total = 0;
-	size_t len;
+	ssize_t len;
 
 	AA_BUG(!str && size != 0);
 	AA_BUG(!label);
-- 
2.20.1

