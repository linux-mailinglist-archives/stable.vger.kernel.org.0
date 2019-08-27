Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057F19E124
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbfH0IDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732160AbfH0IDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A291C206BA;
        Tue, 27 Aug 2019 08:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892980;
        bh=SZ7LXaA9SMy5Zlfp47yQEpZ46W5F86EzMhFJ3rNeoKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUW4AJmCe3TYhYMjwdqyiVjtd2np3j3YKobJfGGnzq18KfEqLOow1H7HkgVIvIiQw
         bBKPcr7smXaeyKH0fQOxFcIhHYz5fXHdAI0PnG0A/0uH5IYnzpYQnqyymHA39qrHXe
         /o3xMFNVbsl1Wvw/ZAbgtFN71TPR547f5TEkA7VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastien Tisserant <stisserant@wallix.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 081/162] SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL
Date:   Tue, 27 Aug 2019 09:50:09 +0200
Message-Id: <20190827072740.934485846@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ee9d66182392695535cc9fccfcb40c16f72de2a9 ]

Fix kernel oops when mounting a encryptData CIFS share with
CONFIG_DEBUG_VIRTUAL

Signed-off-by: Sebastien Tisserant <stisserant@wallix.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ae10d6e297c3a..42de31d206169 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3439,7 +3439,15 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
 				   unsigned int buflen)
 {
-	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
+	void *addr;
+	/*
+	 * VMAP_STACK (at least) puts stack into the vmalloc address space
+	 */
+	if (is_vmalloc_addr(buf))
+		addr = vmalloc_to_page(buf);
+	else
+		addr = virt_to_page(buf);
+	sg_set_page(sg, addr, buflen, offset_in_page(buf));
 }
 
 /* Assumes the first rqst has a transform header as the first iov.
-- 
2.20.1



