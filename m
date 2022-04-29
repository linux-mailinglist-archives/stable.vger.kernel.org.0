Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F005154AA
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 21:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbiD2Tjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiD2Tjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 15:39:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710A985657
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 12:36:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E59CF21877;
        Fri, 29 Apr 2022 19:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651260971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+MHcmlbTzW7qY0e33oOVzNRyRuY7TsASYQCjv0B0FMY=;
        b=blmIj0ivEZ63+Ov+lCYEOQsOwHtDM5XbQz2+77gEoGiv6R9DxRv8QJOKcq4icp3aifW+6D
        24Grq4nLKUZN4Ddvb9ijz3CygL/xOCS1ySA2jL0zpJya+51p+L81LuVeyqYOSk2or+9h8Z
        aDlgjgcOafOWY/GkpWiIclSUYSmdujU=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id DD1062C149;
        Fri, 29 Apr 2022 19:36:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 168FADA7DE; Fri, 29 Apr 2022 21:32:03 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: sysfs: export the balance paused state of exclusive operation
Date:   Fri, 29 Apr 2022 21:31:58 +0200
Message-Id: <20220429193158.527-1-dsterba@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The new state allowing device addition with paused balance is not
exported to user space so it can't recognize it and actually start the
operation.

Fixes: efc0e69c2fea ("btrfs: introduce exclusive operation BALANCE_PAUSED state")
CC: stable@vger.kernel.org # 5.17
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 366424222b4f..92a1fa8e3da6 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -957,6 +957,9 @@ static ssize_t btrfs_exclusive_operation_show(struct kobject *kobj,
 		case BTRFS_EXCLOP_BALANCE:
 			str = "balance\n";
 			break;
+		case BTRFS_EXCLOP_BALANCE_PAUSED:
+			str = "balance paused\n";
+			break;
 		case BTRFS_EXCLOP_DEV_ADD:
 			str = "device add\n";
 			break;
-- 
2.34.1

