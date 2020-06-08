Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133FB1F2357
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgFHXN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgFHXNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D205F20897;
        Mon,  8 Jun 2020 23:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658033;
        bh=TjVIzJCh0CEfsQLND/3pcn51jPC8iMMpkKt8EVaLwEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g173U1sG/Klnqgg20gUX7d5aGQt7/lbKnm6Lk4cpGPxw1aAxTmA8f4rCFUIg53Eh/
         VhjtG8XT3q+FabBd4S/HqE/xNUPweUppEb5J1TFwn8qb0PivxS7/PLUPxrJocWdlem
         19xfl4a4JXtUCoV6dbS4adbTeKxgXh2JC7Veng/s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 084/606] ima: Fix return value of ima_write_policy()
Date:   Mon,  8 Jun 2020 19:03:29 -0400
Message-Id: <20200608231211.3363633-84-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

