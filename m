Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB844F3B42
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346699AbiDELwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356795AbiDEKYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8000BBF534;
        Tue,  5 Apr 2022 03:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25646B81C8A;
        Tue,  5 Apr 2022 10:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6E3C385A0;
        Tue,  5 Apr 2022 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153340;
        bh=N2f6m20kE+loFXcxNeBy/z1fvxrsZDIACl7WBcDq760=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIh8CS+cW6uW/ZAAKMOkvrA9jOBBWMSiRnL3mxZMkas0n3szxKajV9QGNGE1VX4Dm
         PjUN8hXP9fMNUC/7qBAm83ZVJpSj9cD9lE8PDCRDqWzHaoiWteC2lXgRXw3Plcxrg+
         lgrOTaIU7boGaoeF6SGm8NqW2PINKnMIRx6puCdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/599] ACPI: APEI: fix return value of __setup handlers
Date:   Tue,  5 Apr 2022 09:27:35 +0200
Message-Id: <20220405070303.632247894@linuxfoundation.org>
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

[ Upstream commit f3303ff649dbf7dcdc6a6e1a922235b12b3028f4 ]

__setup() handlers should return 1 to indicate that the boot option
has been handled. Returning 0 causes a boot option to be listed in
the Unknown kernel command line parameters and also added to init's
arg list (if no '=' sign) or environment list (if of the form 'a=b').

Unknown kernel command line parameters "erst_disable
  bert_disable hest_disable BOOT_IMAGE=/boot/bzImage-517rc6", will be
  passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
     erst_disable
     bert_disable
     hest_disable
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6

Fixes: a3e2acc5e37b ("ACPI / APEI: Add Boot Error Record Table (BERT) support")
Fixes: a08f82d08053 ("ACPI, APEI, Error Record Serialization Table (ERST) support")
Fixes: 9dc966641677 ("ACPI, APEI, HEST table parsing")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/bert.c | 2 +-
 drivers/acpi/apei/erst.c | 2 +-
 drivers/acpi/apei/hest.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/bert.c b/drivers/acpi/apei/bert.c
index 19e50fcbf4d6..86211422f4ee 100644
--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -77,7 +77,7 @@ static int __init setup_bert_disable(char *str)
 {
 	bert_disable = 1;
 
-	return 0;
+	return 1;
 }
 __setup("bert_disable", setup_bert_disable);
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 2e0b0fcad960..83efb52a3f31 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -891,7 +891,7 @@ EXPORT_SYMBOL_GPL(erst_clear);
 static int __init setup_erst_disable(char *str)
 {
 	erst_disable = 1;
-	return 0;
+	return 1;
 }
 
 __setup("erst_disable", setup_erst_disable);
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 6e980fe16772..7bf48c2776fb 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -219,7 +219,7 @@ static int __init hest_ghes_dev_register(unsigned int ghes_count)
 static int __init setup_hest_disable(char *str)
 {
 	hest_disable = HEST_DISABLED;
-	return 0;
+	return 1;
 }
 
 __setup("hest_disable", setup_hest_disable);
-- 
2.34.1



