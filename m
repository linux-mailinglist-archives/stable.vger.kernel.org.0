Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C3341C4F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhCSMUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230356AbhCSMTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB5AC64E6B;
        Fri, 19 Mar 2021 12:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156395;
        bh=X1wwdFM5WtvcEG+7IaS7I6fTZxYiQTN2BDMJV391pzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgpcLUnIyOh19mHngPsATM+Yv//UfUxttuhJSptMaFbUjScBiD9bGupBVklV429SK
         wXfJOtNPOFutXIvGcAR/k7155GAL+ldS9ns1ltNPhvfxgLeVbenMDFGTsNxZQSG5tL
         KXkpHYzEzY63CjelLGFmxN7m156jQN44Of4957x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 10/13] Revert "nfsd4: remove check_conflicting_opens warning"
Date:   Fri, 19 Mar 2021 13:19:07 +0100
Message-Id: <20210319121745.440078590@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
References: <20210319121745.112612545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 4aa5e002034f0701c3335379fd6c22d7f3338cce upstream.

This reverts commit 50747dd5e47b "nfsd4: remove check_conflicting_opens
warning", as a prerequisite for reverting 94415b06eb8a, which has a
serious bug.

Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4957,6 +4957,7 @@ static int nfsd4_check_conflicting_opens
 		writes--;
 	if (fp->fi_fds[O_RDWR])
 		writes--;
+	WARN_ON_ONCE(writes < 0);
 	if (writes > 0)
 		return -EAGAIN;
 	spin_lock(&fp->fi_lock);


