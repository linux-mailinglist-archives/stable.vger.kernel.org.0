Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94531DEA3D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbgEVOwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbgEVOwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:52:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D6122255;
        Fri, 22 May 2020 14:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159126;
        bh=SsLiBfPUfwRMO5zOAfXQpcBzfExWYne2KkXaGffZrCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1vBpQKCv8RZsdRTqiCZaK5bR2cxYGH0LteYSZa7Ls2feSlyVO4dtkTmP5dmxItoI
         Oo8XOcWyCWuhRa41EfnhgVqBCa0/VGrblZnHTRMFY1Yh2g6k82tBmYi6ANr2SXRu6a
         EW6Sk5wYD14XiNcv2FaoJmU/lejqULUp0AakaDdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Coverity <scan-admin@coverity.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.9 8/8] cifs: Fix null pointer check in cifs_read
Date:   Fri, 22 May 2020 10:51:57 -0400
Message-Id: <20200522145157.435215-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145157.435215-1-sashal@kernel.org>
References: <20200522145157.435215-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 9bd21d4b1a767c3abebec203342f3820dcb84662 ]

Coverity scan noted a redundant null check

Coverity-id: 728517
Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Shyam Prasad N <nspmangalore@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 09d83275c20b..b2919166855f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3293,7 +3293,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 			 * than it negotiated since it will refuse the read
 			 * then.
 			 */
-			if ((tcon->ses) && !(tcon->ses->capabilities &
+			if (!(tcon->ses->capabilities &
 				tcon->ses->server->vals->cap_large_files)) {
 				current_read_size = min_t(uint,
 					current_read_size, CIFSMaxBufSize);
-- 
2.25.1

