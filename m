Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A8E2E3FC6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503201AbgL1OZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:25:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503197AbgL1OZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C833229C5;
        Mon, 28 Dec 2020 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165485;
        bh=AiQ5/sQNlZG7KPCDNVwAS1q8blgrB27JK5GC4mhyu84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7qaYDyDACVpBMqjpHSzrjNw2Mvf23mlaOogFz5A5tOcw9LhaILIMnNRsIJCHdS5Q
         pW20UMK0j1zMELUdbpv7u1plZBflMrG2PKIpvTEwG7OtF08y1lw4gvKD3cJSMAAaxK
         G4tr0A8RCiONX9RmV9P1L1S6SpsgEXTLO1hdAP+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 508/717] Smack: Handle io_uring kernel thread privileges
Date:   Mon, 28 Dec 2020 13:48:26 +0100
Message-Id: <20201228125045.299088799@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit 942cb357ae7d9249088e3687ee6a00ed2745a0c7 ]

Smack assumes that kernel threads are privileged for smackfs
operations. This was necessary because the credential of the
kernel thread was not related to a user operation. With io_uring
the credential does reflect a user's rights and can be used.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_access.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index efe2406a39609..7eabb448acab4 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -688,9 +688,10 @@ bool smack_privileged_cred(int cap, const struct cred *cred)
 bool smack_privileged(int cap)
 {
 	/*
-	 * All kernel tasks are privileged
+	 * Kernel threads may not have credentials we can use.
+	 * The io_uring kernel threads do have reliable credentials.
 	 */
-	if (unlikely(current->flags & PF_KTHREAD))
+	if ((current->flags & (PF_KTHREAD | PF_IO_WORKER)) == PF_KTHREAD)
 		return true;
 
 	return smack_privileged_cred(cap, current_cred());
-- 
2.27.0



