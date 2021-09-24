Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF3D41749F
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345765AbhIXNIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345090AbhIXNG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8ACF61279;
        Fri, 24 Sep 2021 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488184;
        bh=DqXmrRMaoIYcaJ2Nbf388CElWueiJ7eJx1jmUDgUVK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+YnMHEjBWE4kPaGVHrOdqU4lSgOae+7UT0b1Y7qXrBdV5l1sl+uKe7kZQ5ERiR93
         w/v60Bj7SgJAQnifLIvN338QB//dZA+6OmXV77sx0hAayBdBIV4Qr0rxYJwYjHcwLZ
         5PODhp2seOTUFrl1wzdYdPQZmZua9OX4zvs1CZUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 17/63] perf test: Fix bpf test sample mismatch reporting
Date:   Fri, 24 Sep 2021 14:44:17 +0200
Message-Id: <20210924124334.843247311@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
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
@@ -199,7 +199,7 @@ static int do_test(struct bpf_object *ob
 	}
 
 	if (count != expect * evlist->core.nr_entries) {
-		pr_debug("BPF filter result incorrect, expected %d, got %d samples\n", expect, count);
+		pr_debug("BPF filter result incorrect, expected %d, got %d samples\n", expect * evlist->core.nr_entries, count);
 		goto out_delete_evlist;
 	}
 


