Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A738F6AF2C1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjCGS4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbjCGSzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:55:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D41895BF9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909B561538
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD2DC433D2;
        Tue,  7 Mar 2023 18:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214571;
        bh=14hISBGJvZF3R4QDjMNXkLUzDv16EKeXHo8tygM2v8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBhl4uUrWgre2S8o8Q8f+RBTShozR7/p/gvlKoUbSvFtbm4DFapCHMPcOh2YZLCiS
         h8QfqlTPr2N/Nj+eeYBjsGX6u4EwXCMa12UwQpuRSjlJfuNe9Lgonso2D2s00cp7kT
         MDsRLSdINtAyMDS8RAOEjLFJzPPRApJm6JVgFE/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 835/885] ktest.pl: Fix missing "end_monitor" when machine check fails
Date:   Tue,  7 Mar 2023 18:02:49 +0100
Message-Id: <20230307170038.113060215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

commit e8bf9b98d40dbdf4e39362e3b85a70c61da68cb7 upstream.

In the "reboot" command, it does a check of the machine to see if it is
still alive with a simple "ssh echo" command. If it fails, it will assume
that a normal "ssh reboot" is not possible and force a power cycle.

In this case, the "start_monitor" is executed, but the "end_monitor" is
not, and this causes the screen will not be given back to the console. That
is, after the test, a "reset" command needs to be performed, as "echo" is
turned off.

Cc: stable@vger.kernel.org
Fixes: 6474ace999edd ("ktest.pl: Powercycle the box on reboot if no connection can be made")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1488,7 +1488,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }


