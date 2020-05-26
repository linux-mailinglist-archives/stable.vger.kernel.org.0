Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CE71E2E4D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390577AbgEZTDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391164AbgEZTDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:03:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B112086A;
        Tue, 26 May 2020 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519784;
        bh=EanFI+SBZZbT72qK/LBCpv2onY/LJ857zPpdtpQPQzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9PGN8lbQpkCdzFr8JBtih5gQiUpHBdaWNEhhl/ZJA5mTWOcFS9Hs2yn25uiu/VjZ
         r8PY3cMKXzaRtmM0+6QTR+m5pu7trcTenlW93gNE33o84vs5xRgTvir898efOtxcoF
         wUR9h3G0mXi+lmR7lDAIlPN0i78Plelq4viKs58E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/81] ima: Fix return value of ima_write_policy()
Date:   Tue, 26 May 2020 20:52:43 +0200
Message-Id: <20200526183925.589297461@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
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
index cfb8cc3b975e..604cdac63d84 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -343,8 +343,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
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



