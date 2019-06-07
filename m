Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97839027
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbfFGPtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731965AbfFGPtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732FB20657;
        Fri,  7 Jun 2019 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922570;
        bh=QsYZ9HZpUUYKJYJT/QDNZdU6WI+ataWXCsOdcchD/+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzKDjRaC3TFAcXdObj6jSJRfBB6PrlsFhOo4b71nEYRjXV7ycsgumtpkTA0E4skwg
         O8787JUr0zZet0Bfr+ezMRCm4L0jq0FX/8SBpDxgJV0xg+zmRcc5hwaTiuZVvTIG0h
         JvAQPGfs8FeOINOQz9Prr9AOYG92NrvpbHlmve+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <pvorel@suse.cz>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.1 59/85] ima: fix wrong signed policy requirement when not appraising
Date:   Fri,  7 Jun 2019 17:39:44 +0200
Message-Id: <20190607153856.007058193@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <pvorel@suse.cz>

commit f40019475bbbe9b455e7fd4385fcf13896c492ca upstream.

Kernel booted just with ima_policy=tcb (not with
ima_policy=appraise_tcb) shouldn't require signed policy.

Regression found with LTP test ima_policy.sh.

Fixes: c52657d93b05 ("ima: refactor ima_init_policy()")
Cc: stable@vger.kernel.org  (linux-5.0)
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_policy.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -498,10 +498,11 @@ static void add_rules(struct ima_rule_en
 
 			list_add_tail(&entry->list, &ima_policy_rules);
 		}
-		if (entries[i].action == APPRAISE)
+		if (entries[i].action == APPRAISE) {
 			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
-		if (entries[i].func == POLICY_CHECK)
-			temp_ima_appraise |= IMA_APPRAISE_POLICY;
+			if (entries[i].func == POLICY_CHECK)
+				temp_ima_appraise |= IMA_APPRAISE_POLICY;
+		}
 	}
 }
 


