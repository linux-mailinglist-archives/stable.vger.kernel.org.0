Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F4A1EAE1A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbgFASvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729201AbgFASFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D51207D0;
        Mon,  1 Jun 2020 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034711;
        bh=rh/iTIyXUgQYbWqo2GeJdWBSVP/4pOsnGFMjLcnxaoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9ZuBt/LtMubeOixWUwfYSzCfCW/BFudQEQLTFMn4VhN2NCzYlHvqu3b2iS/ZGLLS
         9GYd8+ZqHY+AfbqvGS3dJRIN+JTzgPmQFqILxIAPnWg3VJ2LAYDtDi2jY4v5ou49W4
         NLP42eB7yWAHL4huCgK1uxtDZOz4GtTbNehNDj40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coverity <scan-admin@coverity.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/95] cifs: Fix null pointer check in cifs_read
Date:   Mon,  1 Jun 2020 19:53:35 +0200
Message-Id: <20200601174026.412759141@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cfb0d91289ec..128cbd69911b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3532,7 +3532,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
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



