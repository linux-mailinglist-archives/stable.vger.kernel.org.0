Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13249A9F4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323862AbiAYD3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59310 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348762AbiAXVGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCED7612E9;
        Mon, 24 Jan 2022 21:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D5CC340E5;
        Mon, 24 Jan 2022 21:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058405;
        bh=+VyVfYj83dZxsimPLx22dq/9IYfnUuhTlUu61BPlxBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qoz0/kz2WP2TBwb6zYSLX1IkgLR3RlvNyAllMOM+eu5VwZgTbCczTzE2BJHpTcwl5
         shaUwoK5K2uqk76LaxoJWTyUOhf9U1CZ44ZILFmI0o1wc4RQY7wMQPnDAaIbvrGSap
         PetKoplorpSN4ScYn2AC5H2ir9Oj2P+iVwTyB5z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0279/1039] libbpf: Fix gen_loader assumption on number of programs.
Date:   Mon, 24 Jan 2022 19:34:28 +0100
Message-Id: <20220124184134.661928656@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 259172bb6514758ce3be1610c500b51a9f44212a ]

libbpf's obj->nr_programs includes static and global functions. That number
could be higher than the actual number of bpf programs going be loaded by
gen_loader. Passing larger nr_programs to bpf_gen__init() doesn't hurt. Those
exra stack slots will stay as zero. bpf_gen__finish() needs to check that
actual number of progs that gen_loader saw is less than or equal to
obj->nr_programs.

Fixes: ba05fd36b851 ("libbpf: Perform map fd cleanup for gen_loader in case of error")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 4ac65afc99e50..737e7cbe3e547 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -371,8 +371,9 @@ int bpf_gen__finish(struct bpf_gen *gen, int nr_progs, int nr_maps)
 {
 	int i;
 
-	if (nr_progs != gen->nr_progs || nr_maps != gen->nr_maps) {
-		pr_warn("progs/maps mismatch\n");
+	if (nr_progs < gen->nr_progs || nr_maps != gen->nr_maps) {
+		pr_warn("nr_progs %d/%d nr_maps %d/%d mismatch\n",
+			nr_progs, gen->nr_progs, nr_maps, gen->nr_maps);
 		gen->error = -EFAULT;
 		return gen->error;
 	}
-- 
2.34.1



