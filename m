Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EEB1E2EBB
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390406AbgEZS6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390400AbgEZS6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B84B2084C;
        Tue, 26 May 2020 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519527;
        bh=NggTwWB4h5a6XcBcy4V/G/PG1JIy21Q8VRrMocZwruQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndv3rf0NjJmdlxDd++6CN2dQWGadwVSHG7UzUQvY0D0HcjJRCerTU0/sIBb+CXqPp
         4QGTdQPkIsYzPbo6itXeBRsMLugW4qKunbZJmyKaSTwbEdsca52WMy2/Mqsm4Ty4d8
         smzxWWpVpFbpo+P7TSEYxFfRfGCbqL8AiZWr+I+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/64] ima: Fix return value of ima_write_policy()
Date:   Tue, 26 May 2020 20:52:36 +0200
Message-Id: <20200526183915.613897186@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 2e3a34e9f409ebe83d1af7cd2f49fca7af97dfac ]

This patch fixes the return value of ima_write_policy() when a new policy
is directly passed to IMA and the current policy requires appraisal of the
file containing the policy. Currently, if appraisal is not in ENFORCE mode,
ima_write_policy() returns 0 and leads user space applications to an
endless loop. Fix this issue by denying the operation regardless of the
appraisal mode.

Cc: stable@vger.kernel.org # 4.10.x
Fixes: 19f8a84713edc ("ima: measure and appraise the IMA policy itself")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 44b44d7e0dbc..853a7d2333b3 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -331,8 +331,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL,
 				    "policy_update", "signed policy required",
 				    1, 0);
-		if (ima_appraise & IMA_APPRAISE_ENFORCE)
-			result = -EACCES;
+		result = -EACCES;
 	} else {
 		result = ima_parse_add_rule(data);
 	}
-- 
2.25.1



