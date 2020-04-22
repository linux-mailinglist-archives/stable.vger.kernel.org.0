Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837B91B4057
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgDVKSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729584AbgDVKSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:18:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F56F2075A;
        Wed, 22 Apr 2020 10:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550685;
        bh=gESVvPTfx2xSpiVG8TxKGdtaWIy+comoS9exNaI75lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBoBKJa5D3s/93pmEwVb5SJo41be55o/aBNA/ybgwdCpiw9gjiE82klFYyH5Rz/ws
         yTay5CrsF4lou1ukZZFrlFgzZkzM0M+Wdf+Z/zRrGvJrzL11KM122nAtY9WZqOOWAq
         KoU90F9EdxuvGnVZQCSloCJsUQX6zTCiZB1E2mNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/118] NFSv4.2: error out when relink swapfile
Date:   Wed, 22 Apr 2020 11:56:53 +0200
Message-Id: <20200422095040.570318881@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

[ Upstream commit f5fdf1243fb750598b46305dd03c553949cfa14f ]

This fixes xfstests generic/356 failure on NFSv4.2.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 54f1c1f626fc5..fb55c04cdc6bd 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -210,6 +210,9 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 	if (remap_flags & ~REMAP_FILE_ADVISORY)
 		return -EINVAL;
 
+	if (IS_SWAPFILE(dst_inode) || IS_SWAPFILE(src_inode))
+		return -ETXTBSY;
+
 	/* check alignment w.r.t. clone_blksize */
 	ret = -EINVAL;
 	if (bs) {
-- 
2.20.1



