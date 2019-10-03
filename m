Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43CCCA8BB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403880AbfJCQbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403874AbfJCQbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:31:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CB220867;
        Thu,  3 Oct 2019 16:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120295;
        bh=almqlEgrShZjlwAf+YmnkiSQmi+dQpvSMs4EOo+e5No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM6exgv+fSeDHTuLXY3nLH7BndK2iJ+KwVUEOgSci1qxYWsJU4x1WLjK1/mTXAY8M
         2Sk6UG50fQYewGO3YbW48wXKYQRStNHKijzmJDxcQ96gEM6TiesgNad5dTE6h9sXKS
         bCNEfV1bPtlCaw7/MottZZGruprWmJ/A08hkPUzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 170/313] ACPI: custom_method: fix memory leaks
Date:   Thu,  3 Oct 2019 17:52:28 +0200
Message-Id: <20191003154549.729370674@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 03d1571d9513369c17e6848476763ebbd10ec2cb ]

In cm_write(), 'buf' is allocated through kzalloc(). In the following
execution, if an error occurs, 'buf' is not deallocated, leading to memory
leaks. To fix this issue, free 'buf' before returning the error.

Fixes: 526b4af47f44 ("ACPI: Split out custom_method functionality into an own driver")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/custom_method.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index b2ef4c2ec955d..fd66a736621cf 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -49,8 +49,10 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 	if ((*ppos > max_size) ||
 	    (*ppos + count > max_size) ||
 	    (*ppos + count < count) ||
-	    (count > uncopied_bytes))
+	    (count > uncopied_bytes)) {
+		kfree(buf);
 		return -EINVAL;
+	}
 
 	if (copy_from_user(buf + (*ppos), user_buf, count)) {
 		kfree(buf);
@@ -70,6 +72,7 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, LOCKDEP_NOW_UNRELIABLE);
 	}
 
+	kfree(buf);
 	return count;
 }
 
-- 
2.20.1



