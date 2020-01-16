Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F42413F5A0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389053AbgAPRG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgAPRG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F3D205F4;
        Thu, 16 Jan 2020 17:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194418;
        bh=COOgvLUEYjIY+BaRuxdYDVUyhbOxDqzVx1UrB8R+Wk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3XaHFYZu0fal9hzRFnPMJ4kqRGzR+JmFYlMwlK9524i6QjbZUxBw282iwy7IodzQ
         q9ScW4FcInXXxsc1crYLwcV2efLO6TIFza0X2bOIJNjsFzJem4vC9f5ex+zi1C8xbf
         3xosOhmstNixTjZIshPGi9UctxSIJh7i3UtR1evc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 339/671] afs: Fix the afs.cell and afs.volume xattr handlers
Date:   Thu, 16 Jan 2020 11:59:37 -0500
Message-Id: <20200116170509.12787-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c73aa4102f5b9f261a907c3b3df94cd2c478504d ]

Fix the ->get handlers for the afs.cell and afs.volume xattrs to pass the
source data size to memcpy() rather than target buffer size.

Overcopying the source data occasionally causes the kernel to oops.

Fixes: d3e3b7eac886 ("afs: Add metadata xattrs")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
index cfcc674e64a5..411f67c79f09 100644
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -50,7 +50,7 @@ static int afs_xattr_get_cell(const struct xattr_handler *handler,
 		return namelen;
 	if (namelen > size)
 		return -ERANGE;
-	memcpy(buffer, cell->name, size);
+	memcpy(buffer, cell->name, namelen);
 	return namelen;
 }
 
@@ -104,7 +104,7 @@ static int afs_xattr_get_volume(const struct xattr_handler *handler,
 		return namelen;
 	if (namelen > size)
 		return -ERANGE;
-	memcpy(buffer, volname, size);
+	memcpy(buffer, volname, namelen);
 	return namelen;
 }
 
-- 
2.20.1

