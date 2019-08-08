Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2822986A0E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404556AbfHHTJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405198AbfHHTJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C8E2173E;
        Thu,  8 Aug 2019 19:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291395;
        bh=lTIh+rR60xSDF5NEuETvZM/WBWtqBmp3S+sEd4l2e7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBi9xgWq00t49pJkekcleGBi4Z8GxxueZ3s4vHjgypfHL6CeXAqTR1hfZVReCdEkL
         oY8SDGgLdv5KUXhUWUpvOIHIwTC3UIlsEAPkbCI/gU+u6H+hI7L3eY2E+wiIg1x1EZ
         1DzvNF4jroWu6ITWPkrob6waupG7cZ7RNlU1UgvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.19 43/45] cgroup: css_task_iter_skip()d iterators must be advanced before accessed
Date:   Thu,  8 Aug 2019 21:05:29 +0200
Message-Id: <20190808190456.328123880@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit cee0c33c546a93957a52ae9ab6bebadbee765ec5 upstream.

b636fd38dc40 ("cgroup: Implement css_task_iter_skip()") introduced
css_task_iter_skip() which is used to fix task iterations skipping
dying threadgroup leaders with live threads.  Skipping is implemented
as a subportion of full advancing but css_task_iter_next() forgot to
fully advance a skipped iterator before determining the next task to
visit causing it to return invalid task pointers.

Fix it by making css_task_iter_next() fully advance the iterator if it
has been skipped since the previous iteration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: syzbot
Link: http://lkml.kernel.org/r/00000000000097025d058a7fd785@google.com
Fixes: b636fd38dc40 ("cgroup: Implement css_task_iter_skip()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4303,6 +4303,10 @@ struct task_struct *css_task_iter_next(s
 
 	spin_lock_irq(&css_set_lock);
 
+	/* @it may be half-advanced by skips, finish advancing */
+	if (it->flags & CSS_TASK_ITER_SKIPPED)
+		css_task_iter_advance(it);
+
 	if (it->task_pos) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
 					  cg_list);


