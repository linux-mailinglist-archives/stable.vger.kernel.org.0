Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62F528AD4
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbfEWTru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387829AbfEWTMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:12:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AC420863;
        Thu, 23 May 2019 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638764;
        bh=oe3Ks5A33FJZZy8e0C9HZahremKFJ9LlOQk49bdyEpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McRj1gHku0Um55+cVkUA/T3sMSHeQPogMXs0QPEKLfnNbE+AFj0I41vArDZw1ZFSl
         0lAXBK9er29HeNpRs0yZC/ET2C8QuSfo+N/XtjX0WY3LTbBWOF/yAqqeRxFR7BxtuX
         htixZkWHrhCn1XMZkOvqGe+d3q9W4MUkIkbJppR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 39/77] perf intel-pt: Fix sample timestamp wrt non-taken branches
Date:   Thu, 23 May 2019 21:05:57 +0200
Message-Id: <20190523181725.594545999@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
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
@@ -1313,8 +1313,11 @@ static int intel_pt_walk_tnt(struct inte
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


