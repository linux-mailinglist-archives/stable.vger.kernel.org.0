Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97746689506
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjBCKP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjBCKPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:15:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456E591193
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D10B561E4C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6CDC433EF;
        Fri,  3 Feb 2023 10:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419351;
        bh=ci2wQ74Ka6aZRuRC4wL+H/8zkWkpnEHNMXxW19TnQWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrLs+4BuLNw2iywtnE9XxHABwlyRPOpqUYrgDkzLU3PJ15zj8Nz8205AutIOF1nJm
         O91iNmrRUu/BVCpSdRwsRTQcdEhULL6jx+GhZ63Zt05TNSrIfigawJGlYmoRapp/LB
         4R/Nqn+1Ma9rKmZHMtIqcrU3eiAkqmBF7ywgX3as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev
Subject: [PATCH 4.14 40/62] xen: Fix up build warning with xen_init_time_ops() reference
Date:   Fri,  3 Feb 2023 11:12:36 +0100
Message-Id: <20230203101014.695568832@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Somehow the xen_init_time_ops() reference got out of sync in the 4.14.y
tree (or it never was in sync), and now there's a build warning.  Fix
that up by making xen_init_time_ops() be __init, not __ref.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 03706331f567..8ecc38110bcc 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -516,7 +516,7 @@ static void __init xen_time_init(void)
 		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
 }
 
-void __ref xen_init_time_ops(void)
+void __init xen_init_time_ops(void)
 {
 	xen_sched_clock_offset = xen_clocksource_read();
 	pv_time_ops = xen_time_ops;
-- 
2.39.1



