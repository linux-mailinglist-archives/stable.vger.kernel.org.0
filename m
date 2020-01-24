Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06CE4147B1F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732700AbgAXJlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbgAXJlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:00 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A672070A;
        Fri, 24 Jan 2020 09:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858860;
        bh=BXctlGOcfWv4MWr3GFpCvdltF7/9dfdT7dPsRIp0+TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GIlKOafw9E6LqUr/ASudcTj3NzK9fl2kIEYsEG7LKC2PdAljTyq66tcLyrMOi4jY
         fsI76cD4Zi+hb0qdPEEeyjYu+Dq7gt6OXDXZ4taLucG/qODd8Bku3ebcl96oDXda5m
         F2+EFjA8vH7S+IL5CzhrRAeUqktIUw2lDKM4Ck5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/102] libbpf: Dont use kernel-side u32 type in xsk.c
Date:   Fri, 24 Jan 2020 10:31:08 +0100
Message-Id: <20200124092816.569936132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit a566e35f1e8b4b3be1e96a804d1cca38b578167c ]

u32 is a kernel-side typedef. User-space library is supposed to use __u32.
This breaks Github's projection of libbpf. Do u32 -> __u32 fix.

Fixes: 94ff9ebb49a5 ("libbpf: Fix compatibility for kernels without need_wakeup")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20191029055953.2461336-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index b29d37fba2b0e..0c7386b0e42e4 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -161,22 +161,22 @@ static void xsk_mmap_offsets_v1(struct xdp_mmap_offsets *off)
 	off->rx.producer = off_v1.rx.producer;
 	off->rx.consumer = off_v1.rx.consumer;
 	off->rx.desc = off_v1.rx.desc;
-	off->rx.flags = off_v1.rx.consumer + sizeof(u32);
+	off->rx.flags = off_v1.rx.consumer + sizeof(__u32);
 
 	off->tx.producer = off_v1.tx.producer;
 	off->tx.consumer = off_v1.tx.consumer;
 	off->tx.desc = off_v1.tx.desc;
-	off->tx.flags = off_v1.tx.consumer + sizeof(u32);
+	off->tx.flags = off_v1.tx.consumer + sizeof(__u32);
 
 	off->fr.producer = off_v1.fr.producer;
 	off->fr.consumer = off_v1.fr.consumer;
 	off->fr.desc = off_v1.fr.desc;
-	off->fr.flags = off_v1.fr.consumer + sizeof(u32);
+	off->fr.flags = off_v1.fr.consumer + sizeof(__u32);
 
 	off->cr.producer = off_v1.cr.producer;
 	off->cr.consumer = off_v1.cr.consumer;
 	off->cr.desc = off_v1.cr.desc;
-	off->cr.flags = off_v1.cr.consumer + sizeof(u32);
+	off->cr.flags = off_v1.cr.consumer + sizeof(__u32);
 }
 
 static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
-- 
2.20.1



