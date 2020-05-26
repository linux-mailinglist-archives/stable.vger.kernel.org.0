Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5F41E2C11
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391645AbgEZTLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391739AbgEZTLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7AE208A7;
        Tue, 26 May 2020 19:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520301;
        bh=TjVIzJCh0CEfsQLND/3pcn51jPC8iMMpkKt8EVaLwEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2LHmyldeqfEwxNx9mrQlCJjACIoWDv/P5C+ZyyocuQZY9dYunTKqBjLMVEosgQBm
         D33N77zjT8mXkDznHtvZVObrDALu61hRMzF5TdB5AM7ZK0aFz6N4dFJk3NT1dSsRU4
         CJpWqbk/khfskKsrnhZWd1kutsLmsUtWBgO3Qp6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 005/126] ima: Fix return value of ima_write_policy()
Date:   Tue, 26 May 2020 20:52:22 +0200
Message-Id: <20200526183937.954242103@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
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
index 2000e8df0301..68571c40d61f 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -340,8 +340,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
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



