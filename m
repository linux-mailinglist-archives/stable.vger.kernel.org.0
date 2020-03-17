Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A961881D3
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgCQLAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgCQLAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:00:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD5720719;
        Tue, 17 Mar 2020 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442836;
        bh=i+SqTv+Vux7BWPpeVVY3vjeBGqTlQiO2wZRdtvc2LrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjQzRvIE/3DKgEkxN8mvBCz58zjunSUjoHVXHqk67LcZLt2K7ZMZX9FdpNywXjoj8
         kYLZxVPNp5NqAYGFZRVb1RuZBp9jjWL8B971ABciQcTFiLcjfem6HzMWAhCXlAqGnf
         uVVpBZUwsomLrwroa3kkZwgdtEKB9SyCuoqxU148=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.4 001/123] virtio_balloon: Adjust label in virtballoon_probe
Date:   Tue, 17 Mar 2020 11:53:48 +0100
Message-Id: <20200317103307.543917075@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
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

commit 6ae4edab2fbf86ec92fbf0a8f0c60b857d90d50f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -958,8 +958,8 @@ out_iput:
 	iput(vb->vb_dev_info.inode);
 out_kern_unmount:
 	kern_unmount(balloon_mnt);
-#endif
 out_del_vqs:
+#endif
 	vdev->config->del_vqs(vdev);
 out_free_vb:
 	kfree(vb);


