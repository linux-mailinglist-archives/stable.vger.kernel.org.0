Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389E928A75
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388384AbfEWTPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388886AbfEWTPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:15:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D049A20863;
        Thu, 23 May 2019 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638905;
        bh=7nKQyDwytzw/xeDj6uK0lwRzC4i4TY4rO9siIcdbXiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpdkiCNjZzUrusBVrbUXoZ1oD79bRYee15YgKy4x/vgRe2nDgdoenLOM23rQgnd5c
         9P0vrYB14E/Y8SUV+xJHzi/rYxNmIS4iShp/1uN/Nh6EciFzSaEk9wipdkglfeeQbz
         OkYxOhOBF+rdjVpZu87uhWOOG4TiIYnjj8s7Nm6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "chengjian (D)" <cj.chengjian@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.morris@microsoft.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.19 024/114] proc: prevent changes to overridden credentials
Date:   Thu, 23 May 2019 21:05:23 +0200
Message-Id: <20190523181734.071456391@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit 35a196bef449b5824033865b963ed9a43fb8c730 upstream.

Prevent userspace from changing the the /proc/PID/attr values if the
task's credentials are currently overriden.  This not only makes sense
conceptually, it also prevents some really bizarre error cases caused
when trying to commit credentials to a task with overridden
credentials.

Cc: <stable@vger.kernel.org>
Reported-by: "chengjian (D)" <cj.chengjian@huawei.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Acked-by: John Johansen <john.johansen@canonical.com>
Acked-by: James Morris <james.morris@microsoft.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2542,6 +2542,11 @@ static ssize_t proc_pid_attr_write(struc
 		rcu_read_unlock();
 		return -EACCES;
 	}
+	/* Prevent changes to overridden credentials. */
+	if (current_cred() != current_real_cred()) {
+		rcu_read_unlock();
+		return -EBUSY;
+	}
 	rcu_read_unlock();
 
 	if (count > PAGE_SIZE)


