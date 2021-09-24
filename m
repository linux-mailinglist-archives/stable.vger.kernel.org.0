Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E424173AD
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344307AbhIXM72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345248AbhIXM5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EBD8613A0;
        Fri, 24 Sep 2021 12:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487920;
        bh=mjzF0v+bhLdYsK4KQD4U+52KYPFNveAWRj8sNvDjCrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwsRXZ15bm1teG7fluii/6nZjaE+F9nD8XowiodCncg4rQWj51YEWm7hnX8vBKDqJ
         QKyAAfsrOKyveVD8U0LByJXwGj4eBX1fNPCCvmuh6HV2m7ftTKDBBo+bm5ZodWS9jG
         C2zRpSAmTOql8TWuBTTOG/GF98W7PlsyfkyBjWns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.14 013/100] perf tools: Allow build-id with trailing zeros
Date:   Fri, 24 Sep 2021 14:43:22 +0200
Message-Id: <20210924124341.894010326@linuxfoundation.org>
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
@@ -1349,6 +1349,16 @@ void dso__set_build_id(struct dso *dso,
 
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


