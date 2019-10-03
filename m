Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1773CA1B4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfJCP6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731228AbfJCP63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:58:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F7DD20830;
        Thu,  3 Oct 2019 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118308;
        bh=pR+ClgwAa37N/fDxFJEZeh8L9HIoIcDQe8dndEsAvIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YgItTmk6/nLAEvOz7CH123pKqbzdu24Td7c0y9dR79N6HhDESwVbEHP9FHBN5hv2
         w+bvR7okD4eKBu/xD2i4RXmQAMbgQNoroOIgRWlQDEStRq4bamJiBcsJpRtytENJPa
         OIrrAMZ9laWzktJ+J1CwYU+2eAvZrtsVSg/+bzBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 64/99] ACPI: custom_method: fix memory leaks
Date:   Thu,  3 Oct 2019 17:53:27 +0200
Message-Id: <20191003154328.303751707@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
index c68e72414a67a..435bd0ffc8c02 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -48,8 +48,10 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
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
@@ -69,6 +71,7 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, LOCKDEP_NOW_UNRELIABLE);
 	}
 
+	kfree(buf);
 	return count;
 }
 
-- 
2.20.1



