Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1C410BFB4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfK0Ufq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbfK0Ufq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6367F21569;
        Wed, 27 Nov 2019 20:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886945;
        bh=sgFMomuJpgJia9iF3oPr/+Riich2tDYbIAx20glD344=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/FViRwxe9HBepXBhd2hrgIWhYTySpMZx+a/NjW8xA0b9aLDtvRRGjiuK8MRsBPpi
         4W17RXaKTMIk8mVVvt+3+3zCPCdNXLhBtc8qkiRED3AVYKzE13HnCPkAAP5VDn4mmn
         A4N0xhiEpTyvxeMAwnyeXDKxI9UlTpKTS2g8gY2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 052/132] ceph: fix dentry leak in ceph_readdir_prepopulate
Date:   Wed, 27 Nov 2019 21:30:43 +0100
Message-Id: <20191127202950.126491988@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan, Zheng <zyan@redhat.com>

[ Upstream commit c58f450bd61511d897efc2ea472c69630635b557 ]

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2ad3f4ab4dcfa..0be931cf3c44c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1515,7 +1515,6 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			if (IS_ERR(realdn)) {
 				err = PTR_ERR(realdn);
 				d_drop(dn);
-				dn = NULL;
 				goto next_item;
 			}
 			dn = realdn;
-- 
2.20.1



