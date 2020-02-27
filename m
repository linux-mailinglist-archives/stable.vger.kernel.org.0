Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8541F171C2F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgB0OJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733262AbgB0OJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:09:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 876C120801;
        Thu, 27 Feb 2020 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812588;
        bh=8dJc3VjqGnWWFG3e8ysCnj4VZcKV3ZJX84/9oq8ZYP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjAiW/PduskoKG/aLvKEthuUq/oF5Sp8nQ8Zav5gY4mS0gAeM1Hu5sJmqFA/ZgGpx
         Tm9gLoVTkSoKmBJBS5ugJRRP2Dob+z010eR7geATHQsYKhoKFez1epVUm75SDMUqSt
         tjcbpiU8fzr+4uJHe39rZxsI3VMh5IyfC3HPwJMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 5.4 076/135] sched/psi: Fix OOB write when writing 0 bytes to PSI files
Date:   Thu, 27 Feb 2020 14:36:56 +0100
Message-Id: <20200227132240.815487769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

commit 6fcca0fa48118e6d63733eb4644c6cd880c15b8f upstream.

Issuing write() with count parameter set to 0 on any file under
/proc/pressure/ will cause an OOB write because of the access to
buf[buf_size-1] when NUL-termination is performed. Fix this by checking
for buf_size to be non-zero.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lkml.kernel.org/r/20200203212216.7076-1-surenb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/psi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1199,6 +1199,9 @@ static ssize_t psi_write(struct file *fi
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
 
+	if (!nbytes)
+		return -EINVAL;
+
 	buf_size = min(nbytes, sizeof(buf));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;


