Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0D910BA33
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbfK0VAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbfK0VAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09802086A;
        Wed, 27 Nov 2019 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888446;
        bh=SqMAJqA3YHvVV9J5WhrstskH1pJ06XfwMtA3zAsaE7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rK7pIuDsIJ8t/hvpo5Bf+obV5TwvMmIQKx2nawwi7Zrx+dSes29Utv9IfhSOkAVKK
         2aj+K8qYCLbuTI0mNfzOxhqxVJq00mRNvY+Cz/fO01edWOVlb8IJOBnPhBAIgiseOo
         7B8b+HyZsddSg9T5ohNsv20nw7HqQ58wT7EbkMR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/306] selftests/bpf: fix file resource leak in load_kallsyms
Date:   Wed, 27 Nov 2019 21:29:10 +0100
Message-Id: <20191127203122.192440697@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Hao <peng.hao2@zte.com.cn>

[ Upstream commit 1bd70d2eba9d90eb787634361f0f6fa2c86b3f6d ]

FILE pointer variable f is opened but never closed.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index cf156b3536798..82922f13dcd3a 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -41,6 +41,7 @@ int load_kallsyms(void)
 		syms[i].name = strdup(func);
 		i++;
 	}
+	fclose(f);
 	sym_cnt = i;
 	qsort(syms, sym_cnt, sizeof(struct ksym), ksym_cmp);
 	return 0;
-- 
2.20.1



