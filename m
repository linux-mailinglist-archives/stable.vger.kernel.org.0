Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1AC304A8F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbhAZFDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbhAYSwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06EA3207B3;
        Mon, 25 Jan 2021 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600726;
        bh=3K10St3s58240WSqIOqKLB+NAIfeA136ZwchuuDuv6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECBeMm3xgmPEFaIq203zIdNE3Sh0WDrh4SRCpPDCEGBtMGJvHXrGcr0VG2ojPbhA0
         vTfCAmB3cRVOeUjrsHvyRmpYmtrJDdtHvBQmK4gY73mC/F+fp54BVpS60fDbf6pbgZ
         3PpF0bgavV4Kdhe29ssVWvLMFIT9t8e0FWDg+eq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/199] iov_iter: fix the uaccess area in copy_compat_iovec_from_user
Date:   Mon, 25 Jan 2021 19:38:39 +0100
Message-Id: <20210125183220.372090233@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a959a9782fa87669feeed095ced5d78181a7c02d ]

sizeof needs to be called on the compat pointer, not the native one.

Fixes: 89cd35c58bc2 ("iov_iter: transparently handle compat iovecs in import_iovec")
Reported-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2a..a21e6a5792c5a 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1658,7 +1658,7 @@ static int copy_compat_iovec_from_user(struct iovec *iov,
 		(const struct compat_iovec __user *)uvec;
 	int ret = -EFAULT, i;
 
-	if (!user_access_begin(uvec, nr_segs * sizeof(*uvec)))
+	if (!user_access_begin(uiov, nr_segs * sizeof(*uiov)))
 		return -EFAULT;
 
 	for (i = 0; i < nr_segs; i++) {
-- 
2.27.0



