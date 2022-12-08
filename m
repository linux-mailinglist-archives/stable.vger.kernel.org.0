Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227F4646691
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 02:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiLHBlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 20:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHBlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 20:41:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D09E4E432;
        Wed,  7 Dec 2022 17:41:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27D5D61D25;
        Thu,  8 Dec 2022 01:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D55BC433D7;
        Thu,  8 Dec 2022 01:41:04 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1p35uJ-000FST-1e;
        Wed, 07 Dec 2022 20:41:03 -0500
Message-ID: <20221208014103.379785784@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 07 Dec 2022 20:40:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     "John Warthog9 Hawley" <warthog9@kernel.org>,
        stable@vger.kernel.org,
        "John Warthog9 Hawley (VMware)" <warthog9@eaglescrag.net>
Subject: [for-next][PATCH 1/2] ktest.pl minconfig: Unset configs instead of just removing them
References: <20221208014041.842742311@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

After a full run of a make_min_config test, I noticed there were a lot of
CONFIGs still enabled that really should not be. Looking at them, I
noticed they were all defined as "default y". The issue is that the test
simple removes the config and re-runs make oldconfig, which enables it
again because it is set to default 'y'. Instead, explicitly disable the
config with writing "# CONFIG_FOO is not set" to the file to keep it from
being set again.

With this change, one of my box's minconfigs went from 768 configs set,
down to 521 configs set.

Link: https://lkml.kernel.org/r/20221202115936.016fce23@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 0a05c769a9de5 ("ktest: Added config_bisect test type")
Reviewed-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 09d1578f9d66..d391bf7abeee 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3768,9 +3768,10 @@ sub test_this_config {
     # .config to make sure it is missing the config that
     # we had before
     my %configs = %min_configs;
-    delete $configs{$config};
+    $configs{$config} = "# $config is not set";
     make_new_config ((values %configs), (values %keep_configs));
     make_oldconfig;
+    delete $configs{$config};
     undef %configs;
     assign_configs \%configs, $output_config;
 
-- 
2.35.1


