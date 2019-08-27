Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56ECB9E1D0
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbfH0H4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbfH0H4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27DEB206BA;
        Tue, 27 Aug 2019 07:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892578;
        bh=Nk/rjZVOpy6/x/zI+r3iu7QrtVVzTdoyk3cX/tQ90/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2LVgwEM0qwNpFgaazHuAIy9gPfugDEdIVl1H7jP6MsmlPwWXlhHI/iee97Z0Miy1
         +6UEG5AtuQW0I3+wm/GKXBR5iuMfjYYj0hF91Sqc74HTH3XHn5zbv9jR/k4DB3zdkG
         /e1KiSliXNNNULWjA6cO57nGTgHmY72HyjhNiHvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastien Tisserant <stisserant@wallix.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/98] SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL
Date:   Tue, 27 Aug 2019 09:50:19 +0200
Message-Id: <20190827072720.303622823@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
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
index 97fdbec54db97..cc9e846a38658 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2545,7 +2545,15 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
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



