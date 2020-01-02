Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179E812F12D
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgABWPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbgABWPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A178C24649;
        Thu,  2 Jan 2020 22:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003323;
        bh=P3a/ZEkweCnG571B9JxdD9lRevBt7k9vKFOiEEnafLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYny6OlfeiX0VvqWuYEYiKca7ub+mtW8iCbxidyCY6bacKZjgQVYL5y79+Ekis+do
         oUN+STMaEqUfr/f3prTSAhFdR9UUDPC6lmoRz/zbewf1wdBXbyk9qYFW0B9pHqbQs3
         r60PGbDpxZe6UmWzvfSj+HkrjCHZLd6dWvlkqz84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/191] of: unittest: fix memory leak in attach_node_and_children
Date:   Thu,  2 Jan 2020 23:06:34 +0100
Message-Id: <20200102215841.878154675@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erhard Furtner <erhard_f@mailbox.org>

[ Upstream commit 2aacace6dbbb6b6ce4e177e6c7ea901f389c0472 ]

In attach_node_and_children memory is allocated for full_name via
kasprintf. If the condition of the 1st if is not met the function
returns early without freeing the memory. Add a kfree() to fix that.

This has been detected with kmemleak:
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205327

It looks like the leak was introduced by this commit:
Fixes: 5babefb7f7ab ("of: unittest: allow base devicetree to have symbol metadata")

Signed-off-by: Erhard Furtner <erhard_f@mailbox.org>
Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 92e895d86458..ca7823eef2b4 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1146,8 +1146,10 @@ static void attach_node_and_children(struct device_node *np)
 	full_name = kasprintf(GFP_KERNEL, "%pOF", np);
 
 	if (!strcmp(full_name, "/__local_fixups__") ||
-	    !strcmp(full_name, "/__fixups__"))
+	    !strcmp(full_name, "/__fixups__")) {
+		kfree(full_name);
 		return;
+	}
 
 	dup = of_find_node_by_path(full_name);
 	kfree(full_name);
-- 
2.20.1



