Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80B4F35AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiDEKxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345755AbiDEJoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:44:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C95C55A2;
        Tue,  5 Apr 2022 02:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DC9FB80DA1;
        Tue,  5 Apr 2022 09:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC2BC385A0;
        Tue,  5 Apr 2022 09:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150971;
        bh=L/pyenQmUdfAnp5wcjo1xjpMHrfCLmOU2nZBPABT8/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgcxhhQ6LXtMKE5LsAkjc7Yj0tak7S1myrnVVsEbvxZPc9GYE8NUP6Nfe5f6f96sV
         d4x9HIjqevIAnZSCJEW4GDt3BZfi0vm4gpkQ2WTZKiw2i5QRgGaRSMbGqePPS2Xuyx
         +YXOXW/cBY1VlAxsx/dujIpgvHF0uoBBtnnWTLUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/913] EVM: fix the evm= __setup handler return value
Date:   Tue,  5 Apr 2022 09:21:12 +0200
Message-Id: <20220405070346.153339496@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit f2544f5e6c691679d56bb38637d2f347075b36fa ]

__setup() handlers should return 1 if the parameter is handled.
Returning 0 causes the entire string to be added to init's
environment strings (limited to 32 strings), unnecessarily polluting it.

Using the documented string "evm=fix" causes an Unknown parameter message:
  Unknown kernel command line parameters
  "BOOT_IMAGE=/boot/bzImage-517rc5 evm=fix", will be passed to user space.

and that string is added to init's environment string space:
  Run /sbin/init as init process
    with arguments:
     /sbin/init
    with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     evm=fix

With this change, using "evm=fix" acts as expected and an invalid
option ("evm=evm") causes a warning to be printed:
  evm: invalid "evm" mode
but init's environment is not polluted with this string, as expected.

Fixes: 7102ebcd65c1 ("evm: permit only valid security.evm xattrs to be updated")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 08f907382c61..7d87772f0ce6 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -86,7 +86,7 @@ static int __init evm_set_fixmode(char *str)
 	else
 		pr_err("invalid \"%s\" mode", str);
 
-	return 0;
+	return 1;
 }
 __setup("evm=", evm_set_fixmode);
 
-- 
2.34.1



