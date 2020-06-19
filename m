Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E0D200EE1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403896AbgFSPM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403893AbgFSPM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 490A1218AC;
        Fri, 19 Jun 2020 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579547;
        bh=5zDBVAFJrwyDxCfgdBXSmgfoQKxnhCZ1XUdjhqvLSnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0spGQOXo0Oweie5vVrwzeMU0gBDc1PKoB3W9hBB/MfNhPucxEzAc4zcRJuz9sMrSi
         y89+QYUNY3J7MNbvGyH1RRnzGUbhlYQI/QqsbrHfdnNxU6WG/deJ0Z7lSHFTXApVCv
         ImLm0JbyfKuQhj3lgt8DtVGJagtpPzwkNl8vRgvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 176/261] ima: Evaluate error in init_ima()
Date:   Fri, 19 Jun 2020 16:33:07 +0200
Message-Id: <20200619141658.356242269@linuxfoundation.org>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

commit e144d6b265415ddbdc54b3f17f4f95133effa5a8 upstream.

Evaluate error in init_ima() before register_blocking_lsm_notifier() and
return if not zero.

Cc: stable@vger.kernel.org # 5.3.x
Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -712,6 +712,9 @@ static int __init init_ima(void)
 		error = ima_init();
 	}
 
+	if (error)
+		return error;
+
 	error = register_blocking_lsm_notifier(&ima_lsm_policy_notifier);
 	if (error)
 		pr_warn("Couldn't register LSM notifier, error %d\n", error);


