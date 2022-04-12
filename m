Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932694FD71E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbiDLHam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353222AbiDLHZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37FA4E393;
        Tue, 12 Apr 2022 00:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 394D8B81A8F;
        Tue, 12 Apr 2022 07:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A540CC385A6;
        Tue, 12 Apr 2022 07:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746816;
        bh=mNb1SKCYTL4DnFguMQR5NjP+fQNQ2HDagZRvTBOyfRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUN1shseJ3o+2a5IEWHumv8W/n5p2501uKS47megrN3zD9KCo0m9RQ+VB32JkfCGp
         yT88kuOKhrdZkWCtOim1RJuBYpfmMz2bp4zOnC0UHYOHVNuLgxzkTjA/zisrieMqOm
         GT1kFSalRxFbBx8DSDfba49YpwV2+MEBa61Fh3Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Amit Shah <amit@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 140/285] virtio_console: eliminate anonymous module_init & module_exit
Date:   Tue, 12 Apr 2022 08:29:57 +0200
Message-Id: <20220412062947.709721342@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

[ Upstream commit fefb8a2a941338d871e2d83fbd65fbfa068857bd ]

Eliminate anonymous module_init() and module_exit(), which can lead to
confusion or ambiguity when reading System.map, crashes/oops/bugs,
or an initcall_debug log.

Give each of these init and exit functions unique driver-specific
names to eliminate the anonymous names.

Example 1: (System.map)
 ffffffff832fc78c t init
 ffffffff832fc79e t init
 ffffffff832fc8f8 t init

Example 2: (initcall_debug log)
 calling  init+0x0/0x12 @ 1
 initcall init+0x0/0x12 returned 0 after 15 usecs
 calling  init+0x0/0x60 @ 1
 initcall init+0x0/0x60 returned 0 after 2 usecs
 calling  init+0x0/0x9a @ 1
 initcall init+0x0/0x9a returned 0 after 74 usecs

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Amit Shah <amit@kernel.org>
Cc: virtualization@lists.linux-foundation.org
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20220316192010.19001-3-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index f864b17be7e3..35025f283bf6 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2245,7 +2245,7 @@ static struct virtio_driver virtio_rproc_serial = {
 	.remove =	virtcons_remove,
 };
 
-static int __init init(void)
+static int __init virtio_console_init(void)
 {
 	int err;
 
@@ -2280,7 +2280,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit fini(void)
+static void __exit virtio_console_fini(void)
 {
 	reclaim_dma_bufs();
 
@@ -2290,8 +2290,8 @@ static void __exit fini(void)
 	class_destroy(pdrvdata.class);
 	debugfs_remove_recursive(pdrvdata.debugfs_dir);
 }
-module_init(init);
-module_exit(fini);
+module_init(virtio_console_init);
+module_exit(virtio_console_fini);
 
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");
-- 
2.35.1



