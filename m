Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D164023A4D1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgHCMah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729077AbgHCMag (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68C802054F;
        Mon,  3 Aug 2020 12:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457834;
        bh=25NRMhky5p8NZeSWlXQ16BfjITFXelalLZidKBhsFJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SDmvSxkpQ8HrGGQs76MLnX6wT3B4BVOzPrqO0eG+ZQhyR1gcJkWj4FLQ/XPrqJns
         0/V0uXMIMHKG98punpWNdJmkzErRmizyGd9Ri2Ig0fJKkHz1f1vLZyyRs2WYwwQW2N
         EigOes3qUumqeOBY3uAd7Lhz49cuTL+Bp9lRuM58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.4 89/90] perf env: Do not return pointers to local variables
Date:   Mon,  3 Aug 2020 14:19:51 +0200
Message-Id: <20200803121901.890561589@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit ebcb9464a2ae3a547e97de476575c82ece0e93e2 upstream.

It is possible to return a pointer to a local variable when looking up
the architecture name for the running system and no normalization is
done on that value, i.e. we may end up returning the uts.machine local
variable.

While this doesn't happen on most arches, as normalization takes place,
lets fix this by making that a static variable and optimize it a bit by
not always running uname(), only the first time.

Noticed in fedora rawhide running with:

  [perfbuilder@a5ff49d6e6e4 ~]$ gcc --version
  gcc (GCC) 10.0.1 20200216 (Red Hat 10.0.1-0.8)

Reported-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/env.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -326,11 +326,11 @@ static const char *normalize_arch(char *
 
 const char *perf_env__arch(struct perf_env *env)
 {
-	struct utsname uts;
 	char *arch_name;
 
 	if (!env || !env->arch) { /* Assume local operation */
-		if (uname(&uts) < 0)
+		static struct utsname uts = { .machine[0] = '\0', };
+		if (uts.machine[0] == '\0' && uname(&uts) < 0)
 			return NULL;
 		arch_name = uts.machine;
 	} else


