Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988B33290EC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbhCAURk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242357AbhCAUHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88AE3653A5;
        Mon,  1 Mar 2021 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621554;
        bh=Kulhy2MCvkLVt8jYTFL2r/udmvV5csCCCe0oPcklBX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nR+cuQaw4Q82cT8TaAsApWN0fg64kQnNrmQwJy2DPuPQ3zseIecWNPVLu+4okFkD2
         nHXMMC3kQTNnXmC/QAgirdLSfyjLFZ5uXNMpKmkTb2crKAuY6EmOtwBbOkQXLg3l04
         5r2y4E1RFI5g1NuR8ZlpmwqJp9A4nBbJhMCTsjQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Samuel Cabrero <scabrero@suse.de>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 557/775] cifs: Fix inconsistent IS_ERR and PTR_ERR
Date:   Mon,  1 Mar 2021 17:12:05 +0100
Message-Id: <20210301161229.007955600@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit af982da9a612295a91f367469f8945c916a20dfd ]

Fix inconsistent IS_ERR and PTR_ERR in cifs_find_swn_reg(). The proper
pointer to be passed as argument to PTR_ERR() is share_name.

This bug was detected with the help of Coccinelle.

Fixes: bf80e5d4259a ("cifs: Send witness register and unregister commands to userspace daemon")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Samuel Cabrero <scabrero@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_swn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index d35f599aa00e6..f2d730fffccb3 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -272,7 +272,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 	if (IS_ERR(share_name)) {
 		int ret;
 
-		ret = PTR_ERR(net_name);
+		ret = PTR_ERR(share_name);
 		cifs_dbg(VFS, "%s: failed to extract share name from target '%s': %d\n",
 				__func__, tcon->treeName, ret);
 		kfree(net_name);
-- 
2.27.0



