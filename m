Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7FC4F30A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiDEI1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbiDEIUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727E8B62;
        Tue,  5 Apr 2022 01:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11762609D0;
        Tue,  5 Apr 2022 08:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC28C385A0;
        Tue,  5 Apr 2022 08:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146480;
        bh=gf6hFb0IBIczvzNtHPPSa+xIRoepqNHHLtYzglD/wDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDmAVmJ50imVhHiMQj+Rqyz2SpSRqzAfbgf6lJtPKw4oEpbqRVhle+cyJEQtjEZa9
         lEGRAYA1Fuob0Sk9EAmNylpozc0ewt3NKUhU+IZFe66pE8Efw99RTqbyrIvXQN3pT2
         DGLB37ADQh6Fmx7cpHI7grymdy+x76YPmGhP6mH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0779/1126] tty: hvc: fix return value of __setup handler
Date:   Tue,  5 Apr 2022 09:25:26 +0200
Message-Id: <20220405070430.442762174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 53819a0d97aace1425bb042829e3446952a9e8a9 ]

__setup() handlers should return 1 to indicate that the boot option
has been handled or 0 to indicate that it was not handled.
Add a pr_warn() message if the option value is invalid and then
always return 1.

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: 86b40567b917 ("tty: replace strict_strtoul() with kstrtoul()")
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220308024228.20477-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_iucv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index 82a76cac94de..32366caca662 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1417,7 +1417,9 @@ static int __init hvc_iucv_init(void)
  */
 static	int __init hvc_iucv_config(char *val)
 {
-	 return kstrtoul(val, 10, &hvc_iucv_devices);
+	if (kstrtoul(val, 10, &hvc_iucv_devices))
+		pr_warn("hvc_iucv= invalid parameter value '%s'\n", val);
+	return 1;
 }
 
 
-- 
2.34.1



