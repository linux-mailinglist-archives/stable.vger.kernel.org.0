Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCA1200F10
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392318AbgFSPOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392319AbgFSPOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D9C520776;
        Fri, 19 Jun 2020 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579676;
        bh=GGGopzoYp1/UdNTECzraK80uWl1sSWl9CELLGoAzjqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JupD10T2dQ4lxqBXdw8tSgssugMQDq1hq8Yq8+YXqBchNJFa5kvXWOX03GPW8qy4d
         ev9JyfKyLghXj+8J8+iOYYQ/4V6b+zwrNg2G1NzfkjL6VqTRw/tPc/0+tYLRywKkDo
         zhX0HgdBdbeb7RRevBPzY9btNm2GRWSTpfSpxF3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/261] ima: Set again build_ima_appraise variable
Date:   Fri, 19 Jun 2020 16:33:25 +0200
Message-Id: <20200619141659.192504590@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>

[ Upstream commit b59fda449cf07f2db3be3a67142e6c000f5e8d79 ]

After adding the new add_rule() function in commit c52657d93b05
("ima: refactor ima_init_policy()"), all appraisal flags are added to the
temp_ima_appraise variable. Revert to the previous behavior instead of
removing build_ima_appraise, to benefit from the protection offered by
__ro_after_init.

The mentioned commit introduced a bug, as it makes all the flags
modifiable, while build_ima_appraise flags can be protected with
__ro_after_init.

Cc: stable@vger.kernel.org # 5.0.x
Fixes: c52657d93b05 ("ima: refactor ima_init_policy()")
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 86624b1331ef..558a7607bf93 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -590,8 +590,14 @@ static void add_rules(struct ima_rule_entry *entries, int count,
 
 			list_add_tail(&entry->list, &ima_policy_rules);
 		}
-		if (entries[i].action == APPRAISE)
-			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
+		if (entries[i].action == APPRAISE) {
+			if (entries != build_appraise_rules)
+				temp_ima_appraise |=
+					ima_appraise_flag(entries[i].func);
+			else
+				build_ima_appraise |=
+					ima_appraise_flag(entries[i].func);
+		}
 	}
 }
 
-- 
2.25.1



