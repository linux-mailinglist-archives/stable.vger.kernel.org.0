Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99D320632F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389717AbgFWUSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389443AbgFWUSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9552064B;
        Tue, 23 Jun 2020 20:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943528;
        bh=IVRB9q9/6/QXpG+dXxWFNhybvoHx+eg0H3V+4CyDGDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08KjDKszeWh7Uvwd7efC14pB4S2aICxIjZvLFsrM4LBMhXHy0OrdjsOLFani+Stdo
         MJn1bh0AsWtrhAM8TdhkImGO3Xc4iwmspIe4RfafSfQN61G03+QsfManyGzq09vkZU
         uMCIYHLTxIS5me8BaLrb6IdmX/O3WpxV32HOmgsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.7 427/477] selinux: fix a double free in cond_read_node()/cond_read_list()
Date:   Tue, 23 Jun 2020 21:57:04 +0200
Message-Id: <20200623195427.714040921@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit aa449a7965a6172a89d48844c313708962216f1f upstream.

Clang static analysis reports this double free error

security/selinux/ss/conditional.c:139:2: warning: Attempt to free released memory [unix.Malloc]
        kfree(node->expr.nodes);
        ^~~~~~~~~~~~~~~~~~~~~~~

When cond_read_node fails, it calls cond_node_destroy which frees the
node but does not poison the entry in the node list.  So when it
returns to its caller cond_read_list, cond_read_list deletes the
partial list.  The latest entry in the list will be deleted twice.

So instead of freeing the node in cond_read_node, let list freeing in
code_read_list handle the freeing the problem node along with all of the
earlier nodes.

Because cond_read_node no longer does any error handling, the goto's
the error case are redundant.  Instead just return the error code.

Cc: stable@vger.kernel.org
Fixes: 60abd3181db2 ("selinux: convert cond_list to array")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/ss/conditional.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -392,27 +392,19 @@ static int cond_read_node(struct policyd
 
 		rc = next_entry(buf, fp, sizeof(u32) * 2);
 		if (rc)
-			goto err;
+			return rc;
 
 		expr->expr_type = le32_to_cpu(buf[0]);
 		expr->bool = le32_to_cpu(buf[1]);
 
-		if (!expr_node_isvalid(p, expr)) {
-			rc = -EINVAL;
-			goto err;
-		}
+		if (!expr_node_isvalid(p, expr))
+			return -EINVAL;
 	}
 
 	rc = cond_read_av_list(p, fp, &node->true_list, NULL);
 	if (rc)
-		goto err;
-	rc = cond_read_av_list(p, fp, &node->false_list, &node->true_list);
-	if (rc)
-		goto err;
-	return 0;
-err:
-	cond_node_destroy(node);
-	return rc;
+		return rc;
+	return cond_read_av_list(p, fp, &node->false_list, &node->true_list);
 }
 
 int cond_read_list(struct policydb *p, void *fp)


