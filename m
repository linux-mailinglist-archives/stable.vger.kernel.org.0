Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACF32F00D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfE3EAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfE3DS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48D272474D;
        Thu, 30 May 2019 03:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186309;
        bh=q4GEWxI8zFJV+i2pxijjdsUKmJrEI9Khc/QMjifhyWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nexOqOp1JoiymgRlfP8mtw+7Kibcaa7XhNr76WG+PYY1LqGW5aoJ3OP9uiKtTfoMg
         FDPWCCtzAsUcn0ZUpE1jnYDTlIpsVZ0GZm993CtrDpQSLMjHdH48jiD4W4AWkf2Jjq
         laUCtc6E5+FGM/iG4UM7jQYIYOwHLHD4Sj+21Vh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+228a82b263b5da91883d@syzkaller.appspotmail.com,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 276/276] NFS: Fix a double unlock from nfs_match,get_client
Date:   Wed, 29 May 2019 20:07:14 -0700
Message-Id: <20190530030542.445869259@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index 846d45cb1a3c8..c092661147b30 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -305,9 +305,9 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
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



