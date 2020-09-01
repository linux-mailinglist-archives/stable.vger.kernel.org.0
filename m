Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F320D25967C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgIAQDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731624AbgIAPm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:42:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B22206EB;
        Tue,  1 Sep 2020 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974978;
        bh=2OnOolsDMu+0U4MnMCH9bUDxEatXuuId2hTaXWtFacM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6DDidUVp5iZqdpSyTqiiLyyCAOiZV3SFN51oql/OJe3x+mHqTSLvDOUSmRm/d3uP
         F5w3IWZDkUlNHjyDBKuO+Cv4iCrsqHj8U8XikRLscdrPCYivl0nsQ7YzkXjGODJquf
         n9P9x8jeJsYQtJDyqfKPBH01Eslt+/mFxfbomRsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 163/255] libbpf: Fix map index used in error message
Date:   Tue,  1 Sep 2020 17:10:19 +0200
Message-Id: <20200901151008.502236603@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 1e891e513e16c145cc9b45b1fdb8bf4a4f2f9557 ]

The error message emitted by bpf_object__init_user_btf_maps() was using the
wrong section ID.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200819110534.9058-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0b88f0013b74..3ac0094706b81 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2237,7 +2237,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 		data = elf_getdata(scn, NULL);
 	if (!scn || !data) {
 		pr_warn("failed to get Elf_Data from map section %d (%s)\n",
-			obj->efile.maps_shndx, MAPS_ELF_SEC);
+			obj->efile.btf_maps_shndx, MAPS_ELF_SEC);
 		return -EINVAL;
 	}
 
-- 
2.25.1



