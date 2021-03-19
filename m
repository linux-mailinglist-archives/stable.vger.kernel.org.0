Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D63341C95
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhCSMVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231473AbhCSMVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F8064E6B;
        Fri, 19 Mar 2021 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156473;
        bh=X1wwdFM5WtvcEG+7IaS7I6fTZxYiQTN2BDMJV391pzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFryo5Trh08f3fShx3MCE0R1lJQ/RvXT00dKXKfYBbLL7WpQm92d9kb4KyXWzNu5d
         5K27kMtjFX24f2dUymyarzX8IWhzQBROd+kCZfT28YwipsFWRapjLBuIqopYG+bOTJ
         3GxXo+jfCztXnBdErZe0GmwAvTemzwWw0ITp3SZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.11 28/31] Revert "nfsd4: remove check_conflicting_opens warning"
Date:   Fri, 19 Mar 2021 13:19:22 +0100
Message-Id: <20210319121748.110813942@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
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


