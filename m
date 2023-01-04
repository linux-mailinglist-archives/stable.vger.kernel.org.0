Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB60A65D8F5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbjADQUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbjADQUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ECD8FFA
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99CEC6177C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EDAC433D2;
        Wed,  4 Jan 2023 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849202;
        bh=o+z/HO3mYJ6hbuTxBezOeImd34Tgq1zLH5BVukxMeLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdMhmmkv8XB2YYyLhWFNShdVLgUzAKg3MMmKETUC8oVhl0n5dIhrmAuI6BL1dlv+a
         LHMEJlDGZ12OnoU4WhN1cRNCDEmkqOT1Km1LH9wZjkg3f/ykusIJHH9Lh7l+KDaAMp
         58mFsbYyno7bBdvmfhseNX/gbtCwJLdMRu4e5hco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 150/207] parisc: Drop duplicate kgdb_pdc console
Date:   Wed,  4 Jan 2023 17:06:48 +0100
Message-Id: <20230104160516.657308276@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 7e6652c79ecd74e1112500668d956367dc3772a5 upstream.

The kgdb console is already implemented and registered in pdc_cons.c,
so the duplicate code can be dropped.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/kgdb.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/parisc/kernel/kgdb.c b/arch/parisc/kernel/kgdb.c
index ab7620f695be..b16fa9bac5f4 100644
--- a/arch/parisc/kernel/kgdb.c
+++ b/arch/parisc/kernel/kgdb.c
@@ -208,23 +208,3 @@ int kgdb_arch_handle_exception(int trap, int signo,
 	}
 	return -1;
 }
-
-/* KGDB console driver which uses PDC to read chars from keyboard */
-
-static void kgdb_pdc_write_char(u8 chr)
-{
-	/* no need to print char. kgdb will do it. */
-}
-
-static struct kgdb_io kgdb_pdc_io_ops = {
-	.name		= "kgdb_pdc",
-	.read_char	= pdc_iodc_getc,
-	.write_char	= kgdb_pdc_write_char,
-};
-
-static int __init kgdb_pdc_init(void)
-{
-	kgdb_register_io_module(&kgdb_pdc_io_ops);
-	return 0;
-}
-early_initcall(kgdb_pdc_init);
-- 
2.39.0



