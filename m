Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D0240A64
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgHJPlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgHJPXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0CF2207FF;
        Mon, 10 Aug 2020 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072999;
        bh=3RsfUAp7aGDaL2Wks05J/+SuJ3XwH3Ysi/8Wj7A4IOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4J2aNCFwnkhgiNEEDAJbJ7i1OWXIyqMpPyHCjpELRBj76oj561IONCFuvAypoteN
         DzsTV1doUt2/JNRL4PZUmSjXp7l+XpmyxqFNCRf/mg1jrPuSF2n3gZY17RQInLg6dm
         lZMDLefVzRZcZN7VNOuGW+1PlOWZMxVA8Nd4KZns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 31/79] bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()
Date:   Mon, 10 Aug 2020 17:20:50 +0200
Message-Id: <20200810151813.824095381@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit 5b801dfb7feb2738975d80223efc2fc193e55573 ]

Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
as NULL. This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=f823224ada908fa5c207902a5a62065e53ca0fcc

Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200714180904.277512-1-yepeilin.cs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index d1f5d428c9fe2..6cafc596631c3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4011,6 +4011,11 @@ static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
 	const char *tname, *sym;
 	u32 btf_id, i;
 
+	if (!btf_vmlinux) {
+		bpf_log(log, "btf_vmlinux doesn't exist\n");
+		return -EINVAL;
+	}
+
 	if (IS_ERR(btf_vmlinux)) {
 		bpf_log(log, "btf_vmlinux is malformed\n");
 		return -EINVAL;
-- 
2.25.1



