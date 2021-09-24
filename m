Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51454174A0
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345941AbhIXNIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345477AbhIXNGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CFC36136F;
        Fri, 24 Sep 2021 12:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488187;
        bh=i50Q+2odLvoFw3UCo6bLvVHGv28CMrkLdVV9jE1sgjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnzA4vKfPvCr0wH2L92RCHdSG50qGFsI2/6RSpIBXnl1qqdV9QkuksyLaCeGssZWu
         Hd5iC2IGSi2/I85IknuY44ZORp/V0JYKpXPHBEVUR1+ICB4D2M22+BEQqvSpARpe9a
         MTU+548laqa9AXHCqHJJjIcpNNB2VSLKd9yE+CIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 18/63] perf tools: Allow build-id with trailing zeros
Date:   Fri, 24 Sep 2021 14:44:18 +0200
Message-Id: <20210924124334.879177912@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

commit 4a86d41404005a3c7e7b6065e8169ac6202887a9 upstream.

Currently perf saves a build-id with size but old versions assumes the
size of 20.  In case the build-id is less than 20 (like for MD5), it'd
fill the rest with 0s.

I saw a problem when old version of perf record saved a binary in the
build-id cache and new version of perf reads the data.  The symbols
should be read from the build-id cache (as the path no longer has the
same binary) but it failed due to mismatch in the build-id.

  symsrc__init: build id mismatch for /home/namhyung/.debug/.build-id/53/e4c2f42a4c61a2d632d92a72afa08f00000000/elf.

The build-id event in the data has 20 byte build-ids, but it saw a
different size (16) when it reads the build-id of the elf file in the
build-id cache.

  $ readelf -n ~/.debug/.build-id/53/e4c2f42a4c61a2d632d92a72afa08f00000000/elf

  Displaying notes found in: .note.gnu.build-id
    Owner                Data size 	Description
    GNU                  0x00000010	NT_GNU_BUILD_ID (unique build ID bitstring)
      Build ID: 53e4c2f42a4c61a2d632d92a72afa08f

Let's fix this by allowing trailing zeros if the size is different.

Fixes: 39be8d0115b321ed ("perf tools: Pass build_id object to dso__build_id_equal()")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210910224630.1084877-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/dso.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1336,6 +1336,16 @@ void dso__set_build_id(struct dso *dso,
 
 bool dso__build_id_equal(const struct dso *dso, struct build_id *bid)
 {
+	if (dso->bid.size > bid->size && dso->bid.size == BUILD_ID_SIZE) {
+		/*
+		 * For the backward compatibility, it allows a build-id has
+		 * trailing zeros.
+		 */
+		return !memcmp(dso->bid.data, bid->data, bid->size) &&
+			!memchr_inv(&dso->bid.data[bid->size], 0,
+				    dso->bid.size - bid->size);
+	}
+
 	return dso->bid.size == bid->size &&
 	       memcmp(dso->bid.data, bid->data, dso->bid.size) == 0;
 }


