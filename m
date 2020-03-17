Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2701F1881AB
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgCQLSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgCQLGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:06:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132D520658;
        Tue, 17 Mar 2020 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443205;
        bh=xU/j/wGwogZjo5LYbbtyz+qMZblb7nSHObMck9dJxPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7JYHekqa+nSjxQ4R0XMI7Ih320JqQOpImLL7nKXJv1GhNBEcr7mFXPgEzu4p5BbI
         aV1J7/wlAqnpk8LlvV0Sh04sRX06ut86/AnKphDH3d5w7BZRHSduN0FHaqznU2T5cw
         N5ogsIlxxbOFkll+M73PzCp/Lx/MVOeEWRz2nXyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 001/151] virtio_balloon: Adjust label in virtballoon_probe
Date:   Tue, 17 Mar 2020 11:53:31 +0100
Message-Id: <20200317103326.679618576@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 6ae4edab2fbf86ec92fbf0a8f0c60b857d90d50f ]

Clang warns when CONFIG_BALLOON_COMPACTION is unset:

../drivers/virtio/virtio_balloon.c:963:1: warning: unused label
'out_del_vqs' [-Wunused-label]
out_del_vqs:
^~~~~~~~~~~~
1 warning generated.

Move the label within the preprocessor block since it is only used when
CONFIG_BALLOON_COMPACTION is set.

Fixes: 1ad6f58ea936 ("virtio_balloon: Fix memory leaks on errors in virtballoon_probe()")
Link: https://github.com/ClangBuiltLinux/linux/issues/886
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20200216004039.23464-1-natechancellor@gmail.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 7bfe365d93720..341458fd95ca4 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -959,8 +959,8 @@ out_iput:
 	iput(vb->vb_dev_info.inode);
 out_kern_unmount:
 	kern_unmount(balloon_mnt);
-#endif
 out_del_vqs:
+#endif
 	vdev->config->del_vqs(vdev);
 out_free_vb:
 	kfree(vb);
-- 
2.20.1



