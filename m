Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2349498F87
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352657AbiAXTxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44854 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356961AbiAXTrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:47:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F916131E;
        Mon, 24 Jan 2022 19:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28F9C340E5;
        Mon, 24 Jan 2022 19:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053663;
        bh=CK6VH06TPdfkCC62W0JQK2cm9ehLj5Fn/1ycjcQy56A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYT7yEsaYx1I/rEOAu6v3yqkqdooAt9xf3LR2cKnbH2M5DkXjITWEXijryNpuWZnI
         XJCZgBPG5kFVThPz/ksZcrW/4OBHA4zPsjWQrjt7GsJooZbDHKaIDeUoSGku/zvW67
         0nrLhtvuiUZWVDT/d98y0Vkh/iDZ8/2EEI5WyoXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/563] bpf: Adjust BTF log size limit.
Date:   Mon, 24 Jan 2022 19:38:21 +0100
Message-Id: <20220124184029.099971589@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index aaf2fbaa0cc76..72534a6f4b96e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4135,7 +4135,7 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
+		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
 		    !log->level || !log->ubuf) {
 			err = -EINVAL;
 			goto errout;
-- 
2.34.1



