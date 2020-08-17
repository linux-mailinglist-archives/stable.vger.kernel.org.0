Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69E247038
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390265AbgHQSFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388490AbgHQQJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:09:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A2E222B47;
        Mon, 17 Aug 2020 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680543;
        bh=rjF2FCv8YBcLcgHOazBalU9zhULGooI14SzRWQnIjP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQT/oBKqfJUwkHacSDZ5HAZmKeMHG+Ohhq6JUBTERKjZidh4wJrL0LmwRb+ZQjAiA
         laOnRENJmLRzsmixGfzei+WACe/mhxgYzVhg6y9M5sgP1n0FI/is/yG1kFUcBvsIAH
         jKzbGhrkE8HtH0BtOPrFTX/khRFyzmLrS2feXdnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tobias Klauser <tklauser@distanz.ch>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/270] tools, bpftool: Fix wrong return value in do_dump()
Date:   Mon, 17 Aug 2020 17:16:39 +0200
Message-Id: <20200817143805.650741245@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 041549b7b2c7811ec40e705c439211f00ade2dda ]

In case of btf_id does not exist, a negative error code -ENOENT
should be returned.

Fixes: c93cc69004df3 ("bpftool: add ability to dump BTF types")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200802111540.5384-1-tianjia.zhang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 9a9376d1d3df2..66765f970bc51 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -510,7 +510,7 @@ static int do_dump(int argc, char **argv)
 			goto done;
 		}
 		if (!btf) {
-			err = ENOENT;
+			err = -ENOENT;
 			p_err("can't find btf with ID (%u)", btf_id);
 			goto done;
 		}
-- 
2.25.1



