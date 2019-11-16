Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A9BFF21A
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfKPQRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729531AbfKPPqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:51 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D8E2089D;
        Sat, 16 Nov 2019 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919211;
        bh=ec5cu6iX0BJxkuAKCLot3vx4SnlxHWGsD52ZwXxIf8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/vSchYIi3GaaNAi4zA18NctxMfDkkizyAd1mIl40jvd3acPbPwAR/179GmGtiQ2e
         bFYqXOHKpV4EA6s76D7h2N8xExluRTDnY2RKvu8PdEEnejLdzE1FZL/Z+cCPXmdK/R
         6oLXayuVqna8Vk+Aw6rbXcicWs9c6wUl53fFIxeY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tycho Andersen <tycho@tycho.ws>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 217/237] dlm: don't leak kernel pointer to userspace
Date:   Sat, 16 Nov 2019 10:40:52 -0500
Message-Id: <20191116154113.7417-217-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

[ Upstream commit 9de30f3f7f4d31037cfbb7c787e1089c1944b3a7 ]

In copy_result_to_user(), we first create a struct dlm_lock_result, which
contains a struct dlm_lksb, the last member of which is a pointer to the
lvb. Unfortunately, we copy the entire struct dlm_lksb to the result
struct, which is then copied to userspace at the end of the function,
leaking the contents of sb_lvbptr, which is a valid kernel pointer in some
cases (indeed, later in the same function the data it points to is copied
to userspace).

It is an error to leak kernel pointers to userspace, as it undermines KASLR
protections (see e.g. 65eea8edc31 ("floppy: Do not copy a kernel pointer to
user memory in FDGETPRM ioctl") for another example of this).

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 2a669390cd7f6..13f29409600bb 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -702,7 +702,7 @@ static int copy_result_to_user(struct dlm_user_args *ua, int compat,
 	result.version[0] = DLM_DEVICE_VERSION_MAJOR;
 	result.version[1] = DLM_DEVICE_VERSION_MINOR;
 	result.version[2] = DLM_DEVICE_VERSION_PATCH;
-	memcpy(&result.lksb, &ua->lksb, sizeof(struct dlm_lksb));
+	memcpy(&result.lksb, &ua->lksb, offsetof(struct dlm_lksb, sb_lvbptr));
 	result.user_lksb = ua->user_lksb;
 
 	/* FIXME: dlm1 provides for the user's bastparam/addr to not be updated
-- 
2.20.1

