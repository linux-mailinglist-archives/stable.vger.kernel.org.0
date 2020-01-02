Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCCF12ED1A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgABWYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbgABWYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B7B920866;
        Thu,  2 Jan 2020 22:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003891;
        bh=NitZFmkUU14PrjVIlTGxXu1q1LKT2NOe/iiTj0wOUEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prtbVK3sLyNp2RdsvULJ8oJljQqlgACIJ9JLh4YndTt6REyDcyTP5PsWPdB+2KYA0
         ZCu8Ai32HaeWJ3IMydW5cLzliI76pLjZ7QxQSxyLm0qQRJIHmGrHbwOE0XfxEP+Nil
         XAZ3jBNKaxkUQ+D58MvrQDmecCIseSkN9iNfhy0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/91] apparmor: fix unsigned len comparison with less than zero
Date:   Thu,  2 Jan 2020 23:07:25 +0100
Message-Id: <20200102220434.364866728@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c5b99b954580..ea63710442ae 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1463,11 +1463,13 @@ static inline bool use_label_hname(struct aa_ns *ns, struct aa_label *label,
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
@@ -1602,7 +1604,7 @@ int aa_label_snxprint(char *str, size_t size, struct aa_ns *ns,
 	struct aa_ns *prev_ns = NULL;
 	struct label_it i;
 	int count = 0, total = 0;
-	size_t len;
+	ssize_t len;
 
 	AA_BUG(!str && size != 0);
 	AA_BUG(!label);
-- 
2.20.1



