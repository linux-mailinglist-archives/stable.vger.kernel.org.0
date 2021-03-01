Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4807328B7D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhCASgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240018AbhCAS2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF5A64F83;
        Mon,  1 Mar 2021 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618519;
        bh=L7p/SJuqMOLpDTpk//F1Ir2PUrbX1sMFbr0oiolO5BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYdpNufHwS1AStWqeP7Z13JsLD6f3i+WdNMTT1hjq2+39r5EzArccsylB8k4dawso
         HO+dMDzt9cr/oXrpRG3iEKqupX0LgZ6mwJz1kPUDNx5OfXM2y87r9Kf+zFcmkVFAcL
         Kz/P/WCOZc7E3HyByA9bSV1USqZlAt84GdnAgvyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/663] bpf: Fix an unitialized value in bpf_iter
Date:   Mon,  1 Mar 2021 17:06:04 +0100
Message-Id: <20210301161147.482445215@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 17d8beda277a36203585943e70c7909b60775fd5 ]

Commit 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
cached btf_id in struct bpf_iter_target_info so later on
if it can be checked cheaply compared to checking registered names.

syzbot found a bug that uninitialized value may occur to
bpf_iter_target_info->btf_id. This is because we allocated
bpf_iter_target_info structure with kmalloc and never initialized
field btf_id afterwards. This uninitialized btf_id is typically
compared to a u32 bpf program func proto btf_id, and the chance
of being equal is extremely slim.

This patch fixed the issue by using kzalloc which will also
prevent future likely instances due to adding new fields.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Reported-by: syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210212005926.2875002-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 8f10e30ea0b08..e8957e911de31 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -273,7 +273,7 @@ int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
 
-	tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
+	tinfo = kzalloc(sizeof(*tinfo), GFP_KERNEL);
 	if (!tinfo)
 		return -ENOMEM;
 
-- 
2.27.0



