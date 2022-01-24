Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C55249A93C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322349AbiAYDVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57132 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381224AbiAXUTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:19:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA09FB8122A;
        Mon, 24 Jan 2022 20:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DBDC340E5;
        Mon, 24 Jan 2022 20:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055592;
        bh=Ipaf2xrialY117D8ei2KWYiw/gJ+vYaZHb44lVq9cJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwc6pk7A2mMTeJLgr54Ca4tQhRrs4PRsDjNDMa2EjnCPEN92NjiN3SB+TNa1MIfWV
         zV34FHaIY3qEwRYjM959NTzT+Mt2SJWZVWwldapMtGfxG4Gww2viT5y8zzNiA16I7K
         Qf6OH00NAxpLhsRYvQeE+vsH8HAUA+ENJOETQ3kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/846] bpf: Adjust BTF log size limit.
Date:   Mon, 24 Jan 2022 19:35:18 +0100
Message-Id: <20220124184107.868752221@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit c5a2d43e998a821701029f23e25b62f9188e93ff ]

Make BTF log size limit to be the same as the verifier log size limit.
Otherwise tools that progressively increase log size and use the same log
for BTF loading and program loading will be hitting hard to debug EINVAL.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211201181040.23337-7-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dfe61df4f974d..79c0bcdcab842 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4332,7 +4332,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
+		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
 		    !log->level || !log->ubuf) {
 			err = -EINVAL;
 			goto errout;
-- 
2.34.1



