Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C8395BDB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhEaNZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231784AbhEaNXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 812AC613EA;
        Mon, 31 May 2021 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467190;
        bh=MMnFp0T8Q5Qa7GEVvTicWKpu6W2R1PK1VHfWtYeSJy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiorAll7X6fe9tDBoVHoXUEoHCabg/EMnlIwnsSN28cnOJJoh9lSANLjntYzTGd/a
         32onf9jsISU3+7ip0Y4BkcJQsON1+B+D/ufI4+WoXMGmPXEvVpaFEc8kgDXwDCiqBV
         BZ/JNfxl/bpDJdc83LmTbEwiFONrVrCNwGj1Ew64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 37/66] perf jevents: Fix getting maximum number of fds
Date:   Mon, 31 May 2021 15:14:10 +0200
Message-Id: <20210531130637.433041731@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 75ea44e356b5de8c817f821c9dd68ae329e82add upstream.

On some hosts, rlim.rlim_max can be returned as RLIM_INFINITY.
By casting it to int, it is interpreted as -1, which will cause get_maxfds
to return 0, causing "Invalid argument" errors in nftw() calls.
Fix this by casting the second argument of min() to rlim_t instead.

Fixes: 80eeb67fe577 ("perf jevents: Program to convert JSON file")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lore.kernel.org/lkml/20210525160758.97829-1-nbd@nbd.name
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/pmu-events/jevents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -603,7 +603,7 @@ static int get_maxfds(void)
 	struct rlimit rlim;
 
 	if (getrlimit(RLIMIT_NOFILE, &rlim) == 0)
-		return min((int)rlim.rlim_max / 2, 512);
+		return min(rlim.rlim_max / 2, (rlim_t)512);
 
 	return 512;
 }


