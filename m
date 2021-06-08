Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BD33A006B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhFHSnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235043AbhFHSlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C072B61438;
        Tue,  8 Jun 2021 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177309;
        bh=D3uiFNGSp8hXAmUSZZcMPtlbeCo4G5JIXuUd4UoHDBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfwcagGpO3KLu+eBYAUDZ3C09TU724wQDkMZm2hQTX2u0IFUpzhy6DvhVFrKX0rbA
         UCtXgM4Jh46mUUJzepuoGoFPFt7RfWzVtEZrR64cDEIxj55GiU4s9qkLbtc5Ok89ry
         dBHOsRD81hsk5rJzeexyGUhxwrztS1am9yd2hvd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 47/58] selftests/bpf: add "any alignment" annotation for some tests
Date:   Tue,  8 Jun 2021 20:27:28 +0200
Message-Id: <20210608175933.826274506@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@gmail.com>

commit e2c6f50e48849298bed694de03cceb537d95cdc4 upstream

RISC-V does, in-general, not have "efficient unaligned access". When
testing the RISC-V BPF JIT, some selftests failed in the verification
due to misaligned access. Annotate these tests with the
F_NEEDS_EFFICIENT_UNALIGNED_ACCESS flag.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -963,6 +963,7 @@ static struct bpf_test tests[] = {
 		.errstr_unpriv = "attempt to corrupt spilled",
 		.errstr = "corrupted spill",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"invalid src register in STX",
@@ -1777,6 +1778,7 @@ static struct bpf_test tests[] = {
 		.errstr = "invalid bpf_context access",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SK_MSG,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"invalid read past end of SK_MSG",
@@ -2176,6 +2178,7 @@ static struct bpf_test tests[] = {
 		},
 		.errstr = "invalid bpf_context access",
 		.result = REJECT,
+		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
 	{
 		"check skb->hash half load not permitted, unaligned 3",


