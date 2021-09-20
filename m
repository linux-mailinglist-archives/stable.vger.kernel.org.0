Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A52411C50
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346599AbhITRH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344424AbhITRF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AC266136F;
        Mon, 20 Sep 2021 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156911;
        bh=b8Ip5Tlfr4+O+jheC+jZU1Z375KCC7CxM8QX+LyED5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zA2j+Jkm2OqghzpM3EVcmRsyFMQ82BGU7uR7gIcQCC08wnODwaCt9Q98QOocSoVw3
         8kWVKMlndkGyz204xOg0iM//WEv2CD6+5wn/5zgnODV6u/dEWAEZLCHU4XLcD6oC6E
         sEAlCv0JbRF+iIfmYbh+cSjQ00s8EQhOUhhWyDzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 110/175] Smack: Fix wrong semantics in smk_access_entry()
Date:   Mon, 20 Sep 2021 18:42:39 +0200
Message-Id: <20210920163921.670744144@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 6d14f5c7028eea70760df284057fe198ce7778dd ]

In the smk_access_entry() function, if no matching rule is found
in the rust_list, a negative error code will be used to perform bit
operations with the MAY_ enumeration value. This is semantically
wrong. This patch fixes this issue.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_access.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index e5d5c7fb2dac..b25cc69ef7ba 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -90,23 +90,22 @@ int log_policy = SMACK_AUDIT_DENIED;
 int smk_access_entry(char *subject_label, char *object_label,
 			struct list_head *rule_list)
 {
-	int may = -ENOENT;
 	struct smack_rule *srp;
 
 	list_for_each_entry_rcu(srp, rule_list, list) {
 		if (srp->smk_object->smk_known == object_label &&
 		    srp->smk_subject->smk_known == subject_label) {
-			may = srp->smk_access;
-			break;
+			int may = srp->smk_access;
+			/*
+			 * MAY_WRITE implies MAY_LOCK.
+			 */
+			if ((may & MAY_WRITE) == MAY_WRITE)
+				may |= MAY_LOCK;
+			return may;
 		}
 	}
 
-	/*
-	 * MAY_WRITE implies MAY_LOCK.
-	 */
-	if ((may & MAY_WRITE) == MAY_WRITE)
-		may |= MAY_LOCK;
-	return may;
+	return -ENOENT;
 }
 
 /**
-- 
2.30.2



