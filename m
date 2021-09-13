Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBB408D87
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbhIMN06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240714AbhIMNYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 162FC6121F;
        Mon, 13 Sep 2021 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539329;
        bh=e3e5napruXIrkiDjQDDOcdyWnCKtkl4GGRK1tVVhW7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5viaPvAguowbCSjmjUfeSmJnBxXYn0pSM7MVAAVWUTfmVL9uFLSn8P15YtKdjUj5
         zRUTYMauamPdAKFcPGHWP7zL5EfhLEY7YuiYh/ssjW3nyoPkgdS1oCaeMHiD1C5wGL
         7u8tvm7aoHrt2tUvWFVlasIQjClenddiYBZBaB+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/144] lockd: Fix invalid lockowner cast after vfs_test_lock
Date:   Mon, 13 Sep 2021 15:14:37 +0200
Message-Id: <20210913131051.152078160@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit cd2d644ddba183ec7b451b7c20d5c7cc06fcf0d7 ]

After calling vfs_test_lock() the pointer to a conflicting lock can be
returned, and that lock is not guarunteed to be owned by nlm.  In that
case, we cannot cast it to struct nlm_lockowner.  Instead return the pid
of that conflicting lock.

Fixes: 646d73e91b42 ("lockd: Show pid of lockd for remote locks")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 61d3cc2283dc..498cb70c2c0d 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -634,7 +634,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	conflock->caller = "somehost";	/* FIXME */
 	conflock->len = strlen(conflock->caller);
 	conflock->oh.len = 0;		/* don't return OH info */
-	conflock->svid = ((struct nlm_lockowner *)lock->fl.fl_owner)->pid;
+	conflock->svid = lock->fl.fl_pid;
 	conflock->fl.fl_type = lock->fl.fl_type;
 	conflock->fl.fl_start = lock->fl.fl_start;
 	conflock->fl.fl_end = lock->fl.fl_end;
-- 
2.30.2



