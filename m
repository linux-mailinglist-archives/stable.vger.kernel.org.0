Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603B8615797
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKBCe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKBCe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:34:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D99F6260
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFB21CE1F13
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51536C433D7;
        Wed,  2 Nov 2022 02:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356491;
        bh=SCx5JyHt9WJlokpNbpKbbgwoqxNCj7ZAqFB3m/to5Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfMi/3vjh2MJp2yednyELpgJ1iFlY4aiUxZfWc+8+1ROMSPzAGDlv4gmbWjvoVF3H
         1O3aHbfJ+yILWpxGoMUA2cUJeWKXH3tqXp6h3oM6NfNxJerlqrchcuRD29Y9KXZ7hh
         hnX3VQUuf8qPnFGWsqML3zdB61FCbGawSaPpdmWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jaak Ristioja <jaak@ristioja.ee>
Subject: [PATCH 6.0 001/240] platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks
Date:   Wed,  2 Nov 2022 03:29:36 +0100
Message-Id: <20221102022111.441049514@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit b37fe34c83099ba5105115f8287c5546af1f0a05 upstream.

Since linux/debugfs.h already has the stubs for the used debugfs
functions when debugfs is not enabled, remove the #ifdef CONFIG_DEBUG_FS
checks.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20220922175608.630046-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: Jaak Ristioja <jaak@ristioja.ee>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -151,9 +151,7 @@ struct amd_pmc_dev {
 	struct device *dev;
 	struct pci_dev *rdev;
 	struct mutex lock; /* generic mutex lock */
-#if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
-#endif /* CONFIG_DEBUG_FS */
 };
 
 static bool enable_stb;
@@ -369,7 +367,6 @@ static void amd_pmc_validate_deepest(str
 }
 #endif
 
-#ifdef CONFIG_DEBUG_FS
 static int smu_fw_info_show(struct seq_file *s, void *unused)
 {
 	struct amd_pmc_dev *dev = s->private;
@@ -504,15 +501,6 @@ static void amd_pmc_dbgfs_register(struc
 					    &amd_pmc_stb_debugfs_fops);
 	}
 }
-#else
-static inline void amd_pmc_dbgfs_register(struct amd_pmc_dev *dev)
-{
-}
-
-static inline void amd_pmc_dbgfs_unregister(struct amd_pmc_dev *dev)
-{
-}
-#endif /* CONFIG_DEBUG_FS */
 
 static void amd_pmc_dump_registers(struct amd_pmc_dev *dev)
 {


