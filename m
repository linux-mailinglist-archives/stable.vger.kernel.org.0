Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8685058B7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiDROKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbiDROIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3AD36B5B;
        Mon, 18 Apr 2022 06:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33876B80EE4;
        Mon, 18 Apr 2022 13:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EE8C385A1;
        Mon, 18 Apr 2022 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287423;
        bh=101V+6oKB4yshqJK7l/T8aqNH7Hs8kisFnI1Dy/+a1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtGbHkCDYKtJNA/LTWQV2t7zTPP7FlmrliNpLjeh4xPxyxnhJDvdDcB5EqumEXAGN
         Q4qamlKfGp0S85P/njOy6kBCZAdqlvLYX7bf7qO9Vn27SgqhR6Wo2QoChvQ5z6beAy
         F2OlHfdBEdUWZnsPl3+ZrS2U+2AVC4JZXCmusBfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 156/218] mm/memcontrol: return 1 from cgroup.memory __setup() handler
Date:   Mon, 18 Apr 2022 14:13:42 +0200
Message-Id: <20220418121204.442483803@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 460a79e18842caca6fa0c415de4a3ac1e671ac50 upstream.

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment).

The only reason that this particular __setup handler does not pollute
init's environment is that the setup string contains a '.', as in
"cgroup.memory".  This causes init/main.c::unknown_boottoption() to
consider it to be an "Unused module parameter" and ignore it.  (This is
for parsing of loadable module parameters any time after kernel init.)
Otherwise the string "cgroup.memory=whatever" would be added to init's
environment strings.

Instead of relying on this '.' quirk, just return 1 to indicate that the
boot option has been handled.

Note that there is no warning message if someone enters:
	cgroup.memory=anything_invalid

Link: https://lkml.kernel.org/r/20220222005811.10672-1-rdunlap@infradead.org
Fixes: f7e1cb6ec51b0 ("mm: memcontrol: account socket memory in unified hierarchy memory controller")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5840,7 +5840,7 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
-	return 0;
+	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
 


