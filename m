Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B324513C9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbhKOT4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344054AbhKOTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0808633BC;
        Mon, 15 Nov 2021 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002264;
        bh=1srJoXs98ztI5OSn27Zssx/V/2oItZpf/I5+Vr7ygU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+wy6b/YzzysHEVVfwMMzXqA81Y5LY2ilnNsgsCRpdbzg6/LKayZ2BXbPJitrzN5A
         7/pD801G3IrD4JjcrHFcHHvjD1AanxDLIottubpA6oTD8J8i2em5QFxMOrWKgv8ZyR
         mje5t9M4i7oSgo85O4Uj3h5uGehY2wtYfk/Jh/jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 501/917] libbpf: Fix memory leak in btf__dedup()
Date:   Mon, 15 Nov 2021 17:59:56 +0100
Message-Id: <20211115165445.759234614@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauricio Vásquez <mauricio@kinvolk.io>

[ Upstream commit 1000298c76830bc291358e98e8fa5baa3baa9b3a ]

Free btf_dedup if btf_ensure_modifiable() returns error.

Fixes: 919d2b1dbb07 ("libbpf: Allow modification of BTF and add btf__add_str API")
Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211022202035.48868-1-mauricio@kinvolk.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 77dc24d58302d..bf8c8676d68e5 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2914,8 +2914,10 @@ int btf__dedup(struct btf *btf, struct btf_ext *btf_ext,
 		return libbpf_err(-EINVAL);
 	}
 
-	if (btf_ensure_modifiable(btf))
-		return libbpf_err(-ENOMEM);
+	if (btf_ensure_modifiable(btf)) {
+		err = -ENOMEM;
+		goto done;
+	}
 
 	err = btf_dedup_prep(d);
 	if (err) {
-- 
2.33.0



