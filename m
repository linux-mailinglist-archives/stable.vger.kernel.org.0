Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF8743A100
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhJYTg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235465AbhJYTcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2A6361156;
        Mon, 25 Oct 2021 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190103;
        bh=oKOedprlXAMmIjBW+LoonKVEX3UwgkZf3o4aPgFK0FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6nyCGMjkhpH5sI4YDxtrPH7/5K2qYpYg9mEmquW9Ea/+oNQP3QqcC9Wb3QyGe+QS
         4n9doIOQaEadgCgY8VQZi5L8/GV20fP04FtZ120QHD3lCuO8BUuZLPsrIRg/L6WiDH
         VDu+keTvaueBOnTfioEMKMJ/fMu5KlY/UQGWT5NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 34/58] audit: fix possible null-pointer dereference in audit_filter_rules
Date:   Mon, 25 Oct 2021 21:14:51 +0200
Message-Id: <20211025190943.166985103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 6e3ee990c90494561921c756481d0e2125d8b895 upstream.

Fix  possible null-pointer dereference in audit_filter_rules.

audit_filter_rules() error: we previously assumed 'ctx' could be null

Cc: stable@vger.kernel.org
Fixes: bf361231c295 ("audit: add saddr_fam filter field")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -624,7 +624,7 @@ static int audit_filter_rules(struct tas
 			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
 			break;
 		case AUDIT_SADDR_FAM:
-			if (ctx->sockaddr)
+			if (ctx && ctx->sockaddr)
 				result = audit_comparator(ctx->sockaddr->ss_family,
 							  f->op, f->val);
 			break;


