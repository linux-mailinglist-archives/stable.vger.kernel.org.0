Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD04C4F4121
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383297AbiDEMZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348617AbiDEKrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF28F58385;
        Tue,  5 Apr 2022 03:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63BA2617AF;
        Tue,  5 Apr 2022 10:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F382C385A1;
        Tue,  5 Apr 2022 10:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154434;
        bh=DYk/1tgFYAREGxESYGyO/u0W/NU7F91T01lwHxf8//o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7Q3mO6/6cko8MFWfUYk3fPOU/hsnYW6pCkpEzP31+vzFYVukEPFipwzE90l2zHe3
         z60sdpQZAHgPkGHDnIcRuuaQ69sGGDdCk+2bE05xYhA1g9CEiaRcgSiPHdX40ZxIJ5
         K7n60JbW6kHCZn3CJvb03oCCJ7L7lzggLTgeRqtc=
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
Subject: [PATCH 5.10 578/599] mm/memcontrol: return 1 from cgroup.memory __setup() handler
Date:   Tue,  5 Apr 2022 09:34:32 +0200
Message-Id: <20220405070316.043091679@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -7124,7 +7124,7 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
-	return 0;
+	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
 


