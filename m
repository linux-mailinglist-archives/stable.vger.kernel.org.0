Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ABB4173A8
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345309AbhIXM7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344729AbhIXM5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD3116138F;
        Fri, 24 Sep 2021 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487915;
        bh=gKyQwIfcBEykJTvybmsiFwZVZG61o6G6NwZ7kgp/kZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNQNsni9abqjonaSfFew2zwNUD6V/mTjayI0vKtZFmC1SM4O+W4zmoi6fzpz/yLgE
         3huLi2Vzwp94EIMc2Jpp13vd6pJ719V6T+L71U41tuLfE3Q/iG3nqEXgsNQthWQSsZ
         O08dgRkNjfSjEsvaMU76aeJCWcX1kgE5XACfcbLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.14 011/100] perf test: Fix bpf test sample mismatch reporting
Date:   Fri, 24 Sep 2021 14:43:20 +0200
Message-Id: <20210924124341.833091887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Petlan <mpetlan@redhat.com>

commit 3e11300cdfd5f1bc13a05dfc6dccf69aca5dd1dc upstream.

When the expected sample count in the condition changed, the message
needs to be changed too, otherwise we'll get:

  0x1001f2091d8: mmap mask[0]:
  BPF filter result incorrect, expected 56, got 56 samples

Fixes: 4b04e0decd2518e5 ("perf test: Fix basic bpf filtering test")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Link: https //lore.kernel.org/r/20210805160611.5542-1-mpetlan@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -192,7 +192,7 @@ static int do_test(struct bpf_object *ob
 	}
 
 	if (count != expect * evlist->core.nr_entries) {
-		pr_debug("BPF filter result incorrect, expected %d, got %d samples\n", expect, count);
+		pr_debug("BPF filter result incorrect, expected %d, got %d samples\n", expect * evlist->core.nr_entries, count);
 		goto out_delete_evlist;
 	}
 


