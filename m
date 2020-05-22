Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11711DEA9D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbgEVOzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgEVOvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4D122259;
        Fri, 22 May 2020 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159076;
        bh=l+56c4VIyg+Wlb4RtIt7WDh2QN2wMhTtXg7rIZ4wxf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryNal1ZpQ8jOn8dxrdcDy36r2HWLGmwVQq7rjE/+ekh7LvVLcnc5FMT9QJxO5fL0Q
         1etxkofTIoUpFTwh2HfSdq6tJM8gv90HVrZmbJH5wDw+HDUEOnwqhaETZRypJTVK5x
         7YS/UOvX2pi4MwUNo+abj0secXl+7RfXx+QGlhNs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Coverity <scan-admin@coverity.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 29/32] cifs: Fix null pointer check in cifs_read
Date:   Fri, 22 May 2020 10:50:41 -0400
Message-Id: <20200522145044.434677-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
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
index b095094c0842..4959dbe740f7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3997,7 +3997,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
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

