Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB9729B997
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802622AbgJ0Pue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801408AbgJ0PlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6A32231B;
        Tue, 27 Oct 2020 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813270;
        bh=NSVsy1EO6niZi1vmCGr1HIWgFPlrK2jIIgNuW2XxwCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfZGykdjLCW1bzkXVsptr9914fKvL751mDNA0aASAkKzD00wWPJls8Ae7ZsoVAZXZ
         6zZ4lO7oQ3Qzry3j0V1PWBvbIHE4ZIyV2/MLLcECjtuIw9nzPEE13jgEAwsyyIC8mG
         GAWMxWecNsf21EGhg5l9ilOs6FZ16zT8XGX4Bcd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 495/757] um: vector: Use GFP_ATOMIC under spin lock
Date:   Tue, 27 Oct 2020 14:52:25 +0100
Message-Id: <20201027135513.677026217@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit e4e721fe4ccb504a29d1e8d4047667557281d932 ]

Use GFP_ATOMIC instead of GFP_KERNEL under spin lock to fix possible
sleep-in-atomic-context bugs.

Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 8735c468230a5..555203e3e7b45 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1403,7 +1403,7 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 		kfree(vp->bpf->filter);
 		vp->bpf->filter = NULL;
 	} else {
-		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_KERNEL);
+		vp->bpf = kmalloc(sizeof(struct sock_fprog), GFP_ATOMIC);
 		if (vp->bpf == NULL) {
 			netdev_err(dev, "failed to allocate memory for firmware\n");
 			goto flash_fail;
@@ -1415,7 +1415,7 @@ static int vector_net_load_bpf_flash(struct net_device *dev,
 	if (request_firmware(&fw, efl->data, &vdevice->pdev.dev))
 		goto flash_fail;
 
-	vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	vp->bpf->filter = kmemdup(fw->data, fw->size, GFP_ATOMIC);
 	if (!vp->bpf->filter)
 		goto free_buffer;
 
-- 
2.25.1



