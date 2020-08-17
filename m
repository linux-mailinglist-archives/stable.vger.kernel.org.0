Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C92246A69
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgHQPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbgHQPfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A9220888;
        Mon, 17 Aug 2020 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678508;
        bh=eoABycVGgakd2UB65I4YsZT48SYnDW0C9o18dUli/CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCBLfLzywzp2Ti9Q2oUXm5erlGDUdCN1LRdCTqn5PIOpSmiHuhOC5ghZR8mcrKPjb
         QV/diEC+noXe812cZDermn3Hvof3gjy6gl5HfIfV/jG6PAcFbOAvNs1mIOyC4invvV
         T1YC3IkRffpIBg/ibUXY5kcAiJ4tgqZg4ejxL2hM=
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
Subject: [PATCH 5.8 351/464] tools, bpftool: Fix wrong return value in do_dump()
Date:   Mon, 17 Aug 2020 17:15:04 +0200
Message-Id: <20200817143850.582403114@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index faac8189b2853..c2f1fd414820a 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -596,7 +596,7 @@ static int do_dump(int argc, char **argv)
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



