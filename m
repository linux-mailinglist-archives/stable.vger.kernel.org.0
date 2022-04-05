Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B674F30DC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347643AbiDEJ16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244730AbiDEIwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECC1B7BE;
        Tue,  5 Apr 2022 01:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D0060FFC;
        Tue,  5 Apr 2022 08:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1E1C385A1;
        Tue,  5 Apr 2022 08:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148176;
        bh=L/pyenQmUdfAnp5wcjo1xjpMHrfCLmOU2nZBPABT8/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jc2xLUUQ8kNg12dAKVr8rAjpmu0cKf1l4Q1Ut937ew943hDBCGSnoGah0+9ru3pSx
         Y69STawd3D5Ody4D32ebL12iqf3C/HWQX3Nbw2WST0HiPwjzrVLfvmh/HbDZAiEIsN
         lnJnC4jjrJy3UMnkWAqyKkqXI6oiJPLQi4JlEEEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0223/1017] EVM: fix the evm= __setup handler return value
Date:   Tue,  5 Apr 2022 09:18:56 +0200
Message-Id: <20220405070400.870695370@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



