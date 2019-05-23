Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564CD289A6
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390072AbfEWTUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390104AbfEWTUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DE2205ED;
        Thu, 23 May 2019 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639242;
        bh=yYNf1zVuhoEeRuypyC/W2y1Bfdmnjxnu8XItGxfg3y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8dXcb5vHSLbvTC54SPNpSmx0wRSm3iyHppmH35c5vzOV5KKqGuoxSodJKbq8uANE
         niCOpU/Am4E8oPXLA6evPWxCpVrLABFXsjeS8fkpJ3llVNw+rrKRIr6zK3QrZzWTLf
         28avXNwynLcILkEwmFuecNmh6CQY4Ir9fsR6Z2pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "chengjian (D)" <cj.chengjian@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.morris@microsoft.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 5.0 032/139] proc: prevent changes to overridden credentials
Date:   Thu, 23 May 2019 21:05:20 +0200
Message-Id: <20190523181724.900531524@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
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
@@ -2550,6 +2550,11 @@ static ssize_t proc_pid_attr_write(struc
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


