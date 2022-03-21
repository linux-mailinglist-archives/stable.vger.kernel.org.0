Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908904E2875
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346206AbiCUN4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348315AbiCUN4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:56:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5945366A9;
        Mon, 21 Mar 2022 06:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30339B81598;
        Mon, 21 Mar 2022 13:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E191C340E8;
        Mon, 21 Mar 2022 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870870;
        bh=gSfgLPapIDKi4AvNo7RkyNdwPynnYRvGBh1tgWpe270=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGl/uUWl9UtZEKA4Vdl/twX7E4/SvTId2qX3NvIz97/Yp1rQ+qfo9iB1YOaslq2kn
         INJGQzm4hEz3+yhIg4yocTdoyXsUTvO4PNzXrbVwZ/zHDDkURtYSJ0CnNGgXYPHmf1
         Yyq03wQIxXCqqdCY+7KR7NM3bfME6VXbJk/oAsg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>, Kajol Jain <kjain@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 22/22] perf symbols: Fix symbol size calculation condition
Date:   Mon, 21 Mar 2022 14:51:53 +0100
Message-Id: <20220321133218.258881747@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.602054917@linuxfoundation.org>
References: <20220321133217.602054917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Petlan <mpetlan@redhat.com>

commit 3cf6a32f3f2a45944dd5be5c6ac4deb46bcd3bee upstream.

Before this patch, the symbol end address fixup to be called, needed two
conditions being met:

  if (prev->end == prev->start && prev->end != curr->start)

Where
  "prev->end == prev->start" means that prev is zero-long
                             (and thus needs a fixup)
and
  "prev->end != curr->start" means that fixup hasn't been applied yet

However, this logic is incorrect in the following situation:

*curr  = {rb_node = {__rb_parent_color = 278218928,
  rb_right = 0x0, rb_left = 0x0},
  start = 0xc000000000062354,
  end = 0xc000000000062354, namelen = 40, type = 2 '\002',
  binding = 0 '\000', idle = 0 '\000', ignore = 0 '\000',
  inlined = 0 '\000', arch_sym = 0 '\000', annotate2 = false,
  name = 0x1159739e "kprobe_optinsn_page\t[__builtin__kprobes]"}

*prev = {rb_node = {__rb_parent_color = 278219041,
  rb_right = 0x109548b0, rb_left = 0x109547c0},
  start = 0xc000000000062354,
  end = 0xc000000000062354, namelen = 12, type = 2 '\002',
  binding = 1 '\001', idle = 0 '\000', ignore = 0 '\000',
  inlined = 0 '\000', arch_sym = 0 '\000', annotate2 = false,
  name = 0x1095486e "optinsn_slot"}

In this case, prev->start == prev->end == curr->start == curr->end,
thus the condition above thinks that "we need a fixup due to zero
length of prev symbol, but it has been probably done, since the
prev->end == curr->start", which is wrong.

After the patch, the execution path proceeds to arch__symbols__fixup_end
function which fixes up the size of prev symbol by adding page_size to
its end offset.

Fixes: 3b01a413c196c910 ("perf symbols: Improve kallsyms symbol end addr calculation")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20220317135536.805-1-mpetlan@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/symbol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -224,7 +224,7 @@ void symbols__fixup_end(struct rb_root *
 		prev = curr;
 		curr = rb_entry(nd, struct symbol, rb_node);
 
-		if (prev->end == prev->start && prev->end != curr->start)
+		if (prev->end == prev->start || prev->end != curr->start)
 			arch__symbols__fixup_end(prev, curr);
 	}
 


