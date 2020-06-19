Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578A4201113
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393681AbgFSP3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393212AbgFSP3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D1E321924;
        Fri, 19 Jun 2020 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580542;
        bh=aMAUflGFjiinkmyCdQMi13UOBVr4VEg04gzeLOsDXjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFgJC+SamVSOSwCp3+dOyhPIPvDlmim9XGByk2vIkChKgDZmb15pzp7LPvXWvaV6U
         zo5+M7rfQ4rC7SUnwyD5/w8K2WgsW2xemIM/eKakS1FVLBRh8gazSUKqdSyMJGW7Ob
         z/iteWsnpxcrwwMBe7w6ybM46I0LDYtu1IuIq/+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 290/376] ima: Remove redundant policy rule set in add_rules()
Date:   Fri, 19 Jun 2020 16:33:28 +0200
Message-Id: <20200619141724.065020508@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>

[ Upstream commit 6ee28442a465ab4c4be45e3b15015af24b1ba906 ]

Function ima_appraise_flag() returns the flag to be set in
temp_ima_appraise depending on the hook identifier passed as an argument.
It is not necessary to set the flag again for the POLICY_CHECK hook.

Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 1c78cbbd27d8..7414443c19bf 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -643,11 +643,8 @@ static void add_rules(struct ima_rule_entry *entries, int count,
 
 			list_add_tail(&entry->list, &ima_policy_rules);
 		}
-		if (entries[i].action == APPRAISE) {
+		if (entries[i].action == APPRAISE)
 			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
-			if (entries[i].func == POLICY_CHECK)
-				temp_ima_appraise |= IMA_APPRAISE_POLICY;
-		}
 	}
 }
 
-- 
2.25.1



