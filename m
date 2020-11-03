Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CF02A51BA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgKCUn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730712AbgKCUn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B860223AC;
        Tue,  3 Nov 2020 20:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436207;
        bh=GWBZ3BQU8bcnU0lZCleC02h0tx0fhq8h+mqO1SuTPxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpga0HB/5I14A5u9Gw6RmLtvHuQ0wy1HSVDgOp/xhpbo8wmxd6RjzwQWU6UPWl5su
         2l06KxcQ8SGyRUvUmZEznfrqUGoPQI8LMLF+Tt2RzRX2K6Qefj1Sa2lANsPmzOEWiH
         Wd4ojOPvbqd88NNo3RnjmlO7IUWfwcys22bWHacc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 150/391] nfsd4: remove check_conflicting_opens warning
Date:   Tue,  3 Nov 2020 21:33:21 +0100
Message-Id: <20201103203356.953466047@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 50747dd5e47bde3b7d7f839c84d0d3b554090497 ]

There are actually rare races where this is possible (e.g. if a new open
intervenes between the read of i_writecount and the fi_fds).

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 0525acfe31314..1f646a27481fb 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4954,7 +4954,6 @@ static int nfsd4_check_conflicting_opens(struct nfs4_client *clp,
 		writes--;
 	if (fp->fi_fds[O_RDWR])
 		writes--;
-	WARN_ON_ONCE(writes < 0);
 	if (writes > 0)
 		return -EAGAIN;
 	spin_lock(&fp->fi_lock);
-- 
2.27.0



