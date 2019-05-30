Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6914D2EB6A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbfE3DMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729282AbfE3DMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:52 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2D521BE2;
        Thu, 30 May 2019 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185972;
        bh=2HFrA1Syu5LHtOeNK0QxU2MnJ/8ZxGAovQXoZHNkB6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sErnmPBZiHV+R/GWr2NwDccq2eupqocwlMiU40S6H0LK3NHM8xliNZ5pPvuwBW4qx
         DNbHRFM3UweZ7eF/O+cE/+GUMvcveWkZe8IXCuOzVgWq51sFsRfscJlss6Z9mtfE7u
         HEZNr3QbS3ky2BWRjoJgSR6pY82hL6VsHRPT7eKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+228a82b263b5da91883d@syzkaller.appspotmail.com,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 405/405] NFS: Fix a double unlock from nfs_match,get_client
Date:   Wed, 29 May 2019 20:06:43 -0700
Message-Id: <20190530030601.022642520@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c260121a97a3e4df6536edbc2f26e166eff370ce ]

Now that nfs_match_client drops the nfs_client_lock, we should be
careful
to always return it in the same condition: locked.

Fixes: 950a578c6128 ("NFS: make nfs_match_client killable")
Reported-by: syzbot+228a82b263b5da91883d@syzkaller.appspotmail.com
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 350cfa561e0e8..dfb796eab9121 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -299,9 +299,9 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
 			spin_unlock(&nn->nfs_client_lock);
 			error = nfs_wait_client_init_complete(clp);
 			nfs_put_client(clp);
+			spin_lock(&nn->nfs_client_lock);
 			if (error < 0)
 				return ERR_PTR(error);
-			spin_lock(&nn->nfs_client_lock);
 			goto again;
 		}
 
-- 
2.20.1



