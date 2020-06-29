Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3120DA34
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbgF2Tyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387665AbgF2TkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FA4B24877;
        Mon, 29 Jun 2020 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444374;
        bh=3cOiptvMgCO/QJO7RSsbOX4c0Fd17ZHS8ude4fJCyoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wygQyurDZYibW+ZBC1W8BC/JiIWgAmu9WfQCLmppIZxxBjvkx3fgjObIyldtF9a1M
         0qIdJQmbsB3skkVx0xTtXdZ15xTf3KZVQDl0slaw9I/acHZHWH23iFytGLv3OZhjXz
         HaBPlvIkWPb+YFhmRDoDfkpto0IRap8TTbu/zROs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 051/178] cifs: Fix cached_fid refcnt leak in open_shroot
Date:   Mon, 29 Jun 2020 11:23:16 -0400
Message-Id: <20200629152523.2494198-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 77577de64167aa0643d47ffbaacf3642632b321b upstream.

open_shroot() invokes kref_get(), which increases the refcount of the
"tcon->crfid" object. When open_shroot() returns not zero, it means the
open operation failed and close_shroot() will not be called to decrement
the refcount of the "tcon->crfid".

The reference counting issue happens in one normal path of
open_shroot(). When the cached root have been opened successfully in a
concurrent process, the function increases the refcount and jump to
"oshr_free" to return. However the current return value "rc" may not
equal to 0, thus the increased refcount will not be balanced outside the
function, causing a refcnt leak.

Fix this issue by setting the value of "rc" to 0 before jumping to
"oshr_free" label.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 58915d882285c..f5e893ed48aaa 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -736,6 +736,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 			/* close extra handle outside of crit sec */
 			SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 		}
+		rc = 0;
 		goto oshr_free;
 	}
 
-- 
2.25.1

