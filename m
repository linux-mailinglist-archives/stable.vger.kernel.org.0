Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD1F148358
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404631AbgAXLfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:35:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404580AbgAXLfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:35:22 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E98222D9;
        Fri, 24 Jan 2020 11:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865722;
        bh=GAGFq6L4ACu09icvD+WmqG9Paps4qEGo+Ta0x9IQa4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmBAQRnzHKgIsJ6V3SZ12LJapl0wjOG4X5Z6hqRYAxAbjqpoTR5ifCoyhF4Oq9la2
         GwIXAht5GssCatk+fC/JJVEf4Um3buMnVc37gKwqKjw5F4QX1f1QGa/sMGF75jT83i
         ZKKCFZbmMC9OMzvT8sMOajWBeMunozCKwfBTPzFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 612/639] bpf, offload: Unlock on error in bpf_offload_dev_create()
Date:   Fri, 24 Jan 2020 10:33:02 +0100
Message-Id: <20200124093206.126283044@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d0fbb51dfaa612f960519b798387be436e8f83c5 ]

We need to drop the bpf_devs_lock on error before returning.

Fixes: 9fd7c5559165 ("bpf: offload: aggregate offloads per-device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Link: https://lore.kernel.org/bpf/20191104091536.GB31509@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 177a524363942..86477f3894e52 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -645,8 +645,10 @@ struct bpf_offload_dev *bpf_offload_dev_create(void)
 	down_write(&bpf_devs_lock);
 	if (!offdevs_inited) {
 		err = rhashtable_init(&offdevs, &offdevs_params);
-		if (err)
+		if (err) {
+			up_write(&bpf_devs_lock);
 			return ERR_PTR(err);
+		}
 		offdevs_inited = true;
 	}
 	up_write(&bpf_devs_lock);
-- 
2.20.1



