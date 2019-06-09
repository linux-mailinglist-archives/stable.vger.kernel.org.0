Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEED3A9DA
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfFIRNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732638AbfFIQ5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687E0207E0;
        Sun,  9 Jun 2019 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099472;
        bh=CbjfGcSTb7NkyZd1qDS9ovVLkPuKqkmBl/+eoo2wiew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nys2f8102j19UOThq+Zy0Wj+CuDa72wKXs+xs0T6saQ0Bt1JtEwdG1b472mmykrfb
         IcUGS+yFSZ3X9+1Ko63E4dG/svzdIaby7Q/GA3xvq2ZKWCuEK8UN333Z03L+KFUbmb
         ClZ27jo3WpInJd2t7Sqofs1x+4OJksk1qMZw5JGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.4 053/241] perf intel-pt: Fix sample timestamp wrt non-taken branches
Date:   Sun,  9 Jun 2019 18:39:55 +0200
Message-Id: <20190609164149.303387063@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1b6599a9d8e6c9f7e9b0476012383b1777f7fc93 upstream.

The sample timestamp is updated to ensure that the timestamp represents
the time of the sample and not a branch that the decoder is still
walking towards. The sample timestamp is updated when the decoder
returns, but the decoder does not return for non-taken branches. Update
the sample timestamp then also.

Note that commit 3f04d98e972b5 ("perf intel-pt: Improve sample
timestamp") was also a stable fix and appears, for example, in v4.4
stable tree as commit a4ebb58fd124 ("perf intel-pt: Improve sample
timestamp").

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v4.4+
Fixes: 3f04d98e972b ("perf intel-pt: Improve sample timestamp")
Link: http://lkml.kernel.org/r/20190510124143.27054-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1205,8 +1205,11 @@ static int intel_pt_walk_tnt(struct inte
 				return 0;
 			}
 			decoder->ip += intel_pt_insn.length;
-			if (!decoder->tnt.count)
+			if (!decoder->tnt.count) {
+				decoder->sample_timestamp = decoder->timestamp;
+				decoder->sample_insn_cnt = decoder->timestamp_insn_cnt;
 				return -EAGAIN;
+			}
 			decoder->tnt.payload <<= 1;
 			continue;
 		}


