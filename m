Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BCB401B96
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbhIFM6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242590AbhIFM5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2CF660F45;
        Mon,  6 Sep 2021 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933007;
        bh=zzZYbRVDraUoc0oA9+YhFRQ6DMVSyL974DZGEkBCgrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8eiYac7dpZFtIIRIgtX40vaYZiaBEL+EIoKhUX0FUNTvQhPJXD1woUCk35lp9mRU
         CMvDyj4xqLnH8/KmUr9FfeaG7S8VwXRJdH1zYP9hwXfeAeYTrFeoQwtMJyJAjOqi10
         XI9g675WUpkET0ASinY6xDNCycNq5JRTBUnHfsNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/29] Revert "ucounts: Increase ucounts reference counter before the security hook"
Date:   Mon,  6 Sep 2021 14:55:21 +0200
Message-Id: <20210906125449.987593657@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b493af3a66e067f93e5e03465507866ddeabff9e which is
commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb upstream.

The "original" commit 905ae01c4ae2 ("Add a reference to ucounts for each
cred"), should not have been applied to the 5.10.y tree, so revert it,
and the follow-on fixup patches as well.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/r/87v93k4bl6.fsf@disp2133
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -286,11 +286,11 @@ struct cred *prepare_creds(void)
 	new->security = NULL;
 #endif
 
-	new->ucounts = get_ucounts(new->ucounts);
-	if (!new->ucounts)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+	new->ucounts = get_ucounts(new->ucounts);
+	if (!new->ucounts)
 		goto error;
 
 	validate_creds(new);
@@ -753,11 +753,11 @@ struct cred *prepare_kernel_cred(struct
 #ifdef CONFIG_SECURITY
 	new->security = NULL;
 #endif
-	new->ucounts = get_ucounts(new->ucounts);
-	if (!new->ucounts)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+	new->ucounts = get_ucounts(new->ucounts);
+	if (!new->ucounts)
 		goto error;
 
 	put_cred(old);


