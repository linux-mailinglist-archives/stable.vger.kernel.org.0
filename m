Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F194646376A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbhK3Oxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45508 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242564AbhK3Owh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E0EFB81A2B;
        Tue, 30 Nov 2021 14:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FE8C53FD1;
        Tue, 30 Nov 2021 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283756;
        bh=XAjwUAiM/j8BKJZ3MPSJmE9O/lcstYIzLJvobanl0m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE1uv6JYjkcPsBKRy7xLaEF0adEj+lqBZYQSChZtob/Ne5au2lUksGcq2ssfSg7Jv
         ggvVPc5Cfc1ZSIiV0fGblj4iZIdvvRE+XRJR6NPNC9Pe40Du9Sx7JJ7AaTHh0xRclM
         PlbwdwBGytspLPOLmJOvE/ACWdXY3rZ415jPuclUlOtyG8yBHWa6dl8ZIAhvWVEq4N
         lHEFGBaez49sCNB2QbCTrnsxPBFOCjHwTz+cZ5dMpc0hCs3SGlP6teB8kw/kYsGcBe
         v0Q+Cn3pkrjhc1wEMgG9eJ+Sth/qmjabm9o6+3hQahwarqcT3qhH6rPCw8ND6a9eIk
         d3cScjsrNK7iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.15 51/68] xen: flag pvcalls-front to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:46:47 -0500
Message-Id: <20211130144707.944580-51-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 03e143b2acebe23c893f22ebed9abc0fe2a7f27e ]

The Xen pvcalls device is not essential for booting. Set the respective
flag.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-5-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-front.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 7984645b59563..3c9ae156b597f 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -1275,6 +1275,7 @@ static struct xenbus_driver pvcalls_front_driver = {
 	.probe = pvcalls_front_probe,
 	.remove = pvcalls_front_remove,
 	.otherend_changed = pvcalls_front_changed,
+	.not_essential = true,
 };
 
 static int __init pvcalls_frontend_init(void)
-- 
2.33.0

