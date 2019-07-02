Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1D45CBEA
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfGBIDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfGBIDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3086821850;
        Tue,  2 Jul 2019 08:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054583;
        bh=pilKMYlTiwamuYx57A5kVWVrG8sar5JjJhKOHSt7ncM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGd+A8pOT4FEjFW1ruBjW/mau5C/e5rkVfnJfrJ1cQmXdAvXQpexaxj/NcZHrHos9
         lzE6L41M/n+sy51H8v1DhfsUgW74B8hTyiAyk0sIQgptPWcXiFrYmmy0l3w8n+5nti
         x6wO5oub6qL7qQUGcTMrYwgQJQbImpAQ+sQy4eFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 02/55] Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"
Date:   Tue,  2 Jul 2019 10:01:10 +0200
Message-Id: <20190702080124.204331150@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit b65b70ba068b7cdbfeb65eee87cce84a74618603, which was
upstream commit 4a6c91fbdef846ec7250b82f2eeeb87ac5f18cf9.

On Tue, Jun 25, 2019 at 09:39:45AM +0200, Sebastian Andrzej Siewior wrote:
>Please backport commit e74deb11931ff682b59d5b9d387f7115f689698e to
>stable _or_ revert the backport of commit 4a6c91fbdef84 ("x86/uaccess,
>ftrace: Fix ftrace_likely_update() vs. SMAP"). It uses
>user_access_{save|restore}() which has been introduced in the following
>commit.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_branch.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 3ea65cdff30d..4ad967453b6f 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -205,8 +205,6 @@ void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 			  int expect, int is_constant)
 {
-	unsigned long flags = user_access_save();
-
 	/* A constant is always correct */
 	if (is_constant) {
 		f->constant++;
@@ -225,8 +223,6 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 		f->data.correct++;
 	else
 		f->data.incorrect++;
-
-	user_access_restore(flags);
 }
 EXPORT_SYMBOL(ftrace_likely_update);
 
-- 
2.20.1



