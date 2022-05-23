Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8779F531B80
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239258AbiEWREg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239186AbiEWREa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECB2606C5;
        Mon, 23 May 2022 10:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B638614CA;
        Mon, 23 May 2022 17:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C77BC385AA;
        Mon, 23 May 2022 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325467;
        bh=HSgZXCYSvJ2DAUSCVxoxr58HGGP+tTK7i18NqmCvYZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/BwFFYO3dWIhZmOhD9pz+/iGh/rZuCQ8Db2RLyDADqgRVy1/noa6dmx+yL7UDWQO
         hiAK8o3qwzZOguSo6dHxhqMYvREwuzoJ30eJnmnaAuU2PA8LQR1dYvNBj2VI0ezHld
         jeQNDRnNmmK9U8zH79Glajlt5c+c+NCql8IphZQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/25] perf bench numa: Address compiler error on s390
Date:   Mon, 23 May 2022 19:03:39 +0200
Message-Id: <20220523165749.082966913@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
References: <20220523165743.398280407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit f8ac1c478424a9a14669b8cef7389b1e14e5229d ]

The compilation on s390 results in this error:

  # make DEBUG=y bench/numa.o
  ...
  bench/numa.c: In function ‘__bench_numa’:
  bench/numa.c:1749:81: error: ‘%d’ directive output may be truncated
              writing between 1 and 11 bytes into a region of size between
              10 and 20 [-Werror=format-truncation=]
  1749 |        snprintf(tname, sizeof(tname), "process%d:thread%d", p, t);
                                                               ^~
  ...
  bench/numa.c:1749:64: note: directive argument in the range
                 [-2147483647, 2147483646]
  ...
  #

The maximum length of the %d replacement is 11 characters because of the
negative sign.  Therefore extend the array by two more characters.

Output after:

  # make  DEBUG=y bench/numa.o > /dev/null 2>&1; ll bench/numa.o
  -rw-r--r-- 1 root root 418320 May 19 09:11 bench/numa.o
  #

Fixes: 3aff8ba0a4c9c919 ("perf bench numa: Avoid possible truncation when using snprintf()")
Suggested-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20220520081158.2990006-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 7b364f2926d4..901e9d6efcec 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1626,7 +1626,7 @@ static int __bench_numa(const char *name)
 		"GB/sec,", "total-speed",	"GB/sec total speed");
 
 	if (g->p.show_details >= 2) {
-		char tname[14 + 2 * 10 + 1];
+		char tname[14 + 2 * 11 + 1];
 		struct thread_data *td;
 		for (p = 0; p < g->p.nr_proc; p++) {
 			for (t = 0; t < g->p.nr_threads; t++) {
-- 
2.35.1



