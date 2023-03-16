Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B7D6BCE1E
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCPL2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCPL2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:28:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCDE22791;
        Thu, 16 Mar 2023 04:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E47FAB8210B;
        Thu, 16 Mar 2023 11:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783B6C433D2;
        Thu, 16 Mar 2023 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678966093;
        bh=+DlbZ+J6+uqEoB6dZjD8hILUolgR4JsTAyoNWYDDgZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHS+iJ5B36o6Z8a2zhI1NQsx0diRRkE+S0LNlepnJ+k26xyoi0W/5QQj7a/sF+bmP
         nfwWDWoaPaHYrQC7jQoCPbvou+OronRu9jpYnF2kWtgpJhrN3liXN8eO1TgLxEFsFB
         jAkdaL4Z+7S+Ju/5fhzzugqPrY/Rys4JoLqXJR/TjHW0flV+ENFAKHp5JizybxDWmu
         6l2NicZEi6JqTdR3aQPrupa6h8Ld/GCqVVP2iKR/zMasdSc+SWkA2p8wh1HQGFBxvk
         MzcaYZ1JiFDmDnXO59Ef9hk44DRVAP+hcPvyyQnTVfC6YY1VhxHLNcLfEmZT/lN6Sl
         oKRCYDC9M9njA==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     gor@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH] s390: reintroduce expoline dependence to scripts
Date:   Thu, 16 Mar 2023 12:28:09 +0100
Message-Id: <20230316112809.7903-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <705ce64c-5f73-2ec8-e4bc-dd48c85f0498@kernel.org>
References: <705ce64c-5f73-2ec8-e4bc-dd48c85f0498@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Expolines depend on scripts/basic/fixdep. And build of expolines can now
race with the fixdep build:

 make[1]: *** Deleting file 'arch/s390/lib/expoline/expoline.o'
 /bin/sh: line 1: scripts/basic/fixdep: Permission denied
 make[1]: *** [../scripts/Makefile.build:385: arch/s390/lib/expoline/expoline.o] Error 126
 make: *** [../arch/s390/Makefile:166: expoline_prepare] Error 2

The dependence was removed in the below Fixes: commit. So reintroduce
the dependence on scripts.

Fixes: a0b0987a7811 ("s390/nospec: remove unneeded header includes")
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
 arch/s390/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index b3235ab0ace8..ed646c583e4f 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -162,7 +162,7 @@ vdso_prepare: prepare0
 
 ifdef CONFIG_EXPOLINE_EXTERN
 modules_prepare: expoline_prepare
-expoline_prepare:
+expoline_prepare: scripts
 	$(Q)$(MAKE) $(build)=arch/s390/lib/expoline arch/s390/lib/expoline/expoline.o
 endif
 endif
-- 
2.40.0

