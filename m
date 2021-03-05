Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2F032EA34
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCEMhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:37:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhCEMge (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:36:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA5165004;
        Fri,  5 Mar 2021 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947794;
        bh=h1z53uxqsHam5ZsBYZw50JLpUZtyU6R90jbtUyzn+VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0h9CiRu78i72Ii1OP3zpLHsdDdcY/SdHEvyCmPnSi7APhC6dsYHsTWaklASV/L2fV
         b44HyRCW0d0ap86Gf6v9dBhEIiPXslyb1LvUnxcZxSZDU18XyoMar+NU4gzi7DawzJ
         brFMww93Rqjl7Yz4JAsRUNQIPw6CV/5gVR6tzlng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a71a442385a0b2815497@syzkaller.appspotmail.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.19 14/52] smackfs: restrict bytes count in smackfs write functions
Date:   Fri,  5 Mar 2021 13:21:45 +0100
Message-Id: <20210305120854.367243408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

commit 7ef4c19d245f3dc233fd4be5acea436edd1d83d8 upstream.

syzbot found WARNINGs in several smackfs write operations where
bytes count is passed to memdup_user_nul which exceeds
GFP MAX_ORDER. Check count size if bigger than PAGE_SIZE.

Per smackfs doc, smk_write_net4addr accepts any label or -CIPSO,
smk_write_net6addr accepts any label or -DELETE. I couldn't find
any general rule for other label lengths except SMK_LABELLEN,
SMK_LONGLABEL, SMK_CIPSOMAX which are documented.

Let's constrain, in general, smackfs label lengths for PAGE_SIZE.
Although fuzzer crashes write to smackfs/netlabel on 0x400000 length.

Here is a quick way to reproduce the WARNING:
python -c "print('A' * 0x400000)" > /sys/fs/smackfs/netlabel

Reported-by: syzbot+a71a442385a0b2815497@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/smack/smackfs.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1191,7 +1191,7 @@ static ssize_t smk_write_net4addr(struct
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN)
+	if (count < SMK_NETLBLADDRMIN || count > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
@@ -1451,7 +1451,7 @@ static ssize_t smk_write_net6addr(struct
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN)
+	if (count < SMK_NETLBLADDRMIN || count > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
@@ -1858,6 +1858,10 @@ static ssize_t smk_write_ambient(struct
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	/* Enough data must be present */
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2029,6 +2033,9 @@ static ssize_t smk_write_onlycap(struct
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	if (count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2116,6 +2123,9 @@ static ssize_t smk_write_unconfined(stru
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	if (count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2669,6 +2679,10 @@ static ssize_t smk_write_syslog(struct f
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
+	/* Enough data must be present */
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -2761,10 +2775,13 @@ static ssize_t smk_write_relabel_self(st
 		return -EPERM;
 
 	/*
+	 * No partial write.
 	 * Enough data must be present.
 	 */
 	if (*ppos != 0)
 		return -EINVAL;
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))


