Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5457E5A3F87
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 21:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiH1Twq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 15:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiH1Twp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 15:52:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D180BB496;
        Sun, 28 Aug 2022 12:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=dPawHL8qAnBSGi4I39fEFzREdQv818UwwXOztMhoVdQ=; b=X+UvY2W12TyQc6OsZRi3aiZvaW
        f8cuW5EYrweGPsGM+HwTgl0CEDlrB3qI6Mdmlqa2IhY64vk+b/JNTcEAEiQli2xh3QlyqQbvFuyT/
        D9Vo7mNxiX6Kz+yVvhcOLlib0Cywczq2kwHQ5G/cT+xN/9cCYH2P5GhXnj3w8jqnBULBqAa5pz972
        /h82yWUKAorMmsyf2+UkWrIOhF3qfNJhScxJxAl5NVbrwdU28dJmGrVE3WbtleUNpGHxVCynrws8W
        pYP2ZzD6llox/7zmGdNAXaGpqwQuk8MDs0J3tEFefJqxj5AuwZGV6H/5D6whIKM0kKbhwGEardAFg
        UP8Z/3Zg==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oSOKn-002TCH-16; Sun, 28 Aug 2022 19:52:41 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paul Gazzillo <paul@pgazz.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] virt: sev-guest: fix kconfig warnings
Date:   Sun, 28 Aug 2022 12:52:34 -0700
Message-Id: <20220828195234.6604-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the SEV_GUEST Kconfig block to eliminate kconfig unmet
dependency warnings:

WARNING: unmet direct dependencies detected for CRYPTO_GCM
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]

WARNING: unmet direct dependencies detected for CRYPTO_AEAD2
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - SEV_GUEST [=y] && VIRT_DRIVERS [=y] && AMD_MEM_ENCRYPT [=y]

Fixes: fce96cf04430 ("virt: Add SEV-SNP guest driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Paul Gazzillo <paul@pgazz.com>
Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
---
 drivers/virt/coco/sev-guest/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,6 +2,7 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
+	select CRYPTO
 	select CRYPTO_AEAD2
 	select CRYPTO_GCM
 	help
