Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8CA628060
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbiKNNFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbiKNNFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728842A41C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23337B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AE0C433C1;
        Mon, 14 Nov 2022 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431119;
        bh=4xrpFBJ+KpPDB0YyiQdA9W3Mk8zJM9A+B8r3Wdmu9SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZuNaLHWW79yE59mVZ/kzwc3KNdjtR9vtVqpHLwI4PHNcbkhzCgeNPcSeSRQL50zh
         6Zz4rFf4aJhzrzenFSI4UCLHgrlXLAtX+J6dewKLykZwMl3hbPiszbnuRpi8XT8mC5
         QDT+j9Tv9xpuUTxqCy4MoByP3yQf9O5ypN9NSKMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Donglin Peng <dolinux.peng@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 078/190] perf tools: Add the include/perf/ directory to .gitignore
Date:   Mon, 14 Nov 2022 13:45:02 +0100
Message-Id: <20221114124502.093193469@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Donglin Peng <dolinux.peng@gmail.com>

[ Upstream commit 94d957ae513fc420d0a5a9bac815eb49ffebb56f ]

Commit 3af1dfdd51e06697 ("perf build: Move perf_dlfilters.h in the
source tree") moved perf_dlfilters.h to the include/perf/ directory
while include/perf is ignored because it has 'perf' in the name.  Newly
created files in the include/perf/ directory will be ignored.

Testing:

Before:

  $ touch tools/perf/include/perf/junk
  $ git status | grep junk
  $ git check-ignore -v tools/perf/include/perf/junk
  tools/perf/.gitignore:6:perf    tools/perf/include/perf/junk

After:

  $ git status | grep junk
  tools/perf/include/perf/junk
  $ git check-ignore -v tools/perf/include/perf/junk

Add !include/perf/ to perf's .gitignore file.

Fixes: 3af1dfdd51e06697 ("perf build: Move perf_dlfilters.h in the source tree")
Signed-off-by: Donglin Peng <dolinux.peng@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221103092704.173391-1-dolinux.peng@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 4b9c71faa01a..f136309044da 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -4,6 +4,7 @@ PERF-GUI-VARS
 PERF-VERSION-FILE
 FEATURE-DUMP
 perf
+!include/perf/
 perf-read-vdso32
 perf-read-vdsox32
 perf-help
-- 
2.35.1



