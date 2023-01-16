Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11F866CB7C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbjAPROu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbjAPRNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A83252A9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CB861042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67575C433EF;
        Mon, 16 Jan 2023 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888042;
        bh=7ljI8XXa+5WY5aATGjgL3h+133pgo1lhOuDbPirtP1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSjhQ1LsKJbTnBOrWyyJx4hrliZrDT0P3lls7YszxFjxVnVNDqumans4egVfkGf4C
         pvl6Sgmdqn8ezpnZ7sJd1KaB5+Vda1SmSScTmhipCGcWoMYzhH4zyob/N7CiQmJs9f
         ygP4LsR1zFXWknpG6qkClT/lai+BXWvPaTorSE7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "John Warthog9 Hawley (VMware)" <warthog9@eaglescrag.net>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 378/521] ktest.pl minconfig: Unset configs instead of just removing them
Date:   Mon, 16 Jan 2023 16:50:40 +0100
Message-Id: <20230116154904.015086872@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit ef784eebb56425eed6e9b16e7d47e5c00dcf9c38 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3706,9 +3706,10 @@ sub test_this_config {
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
 


