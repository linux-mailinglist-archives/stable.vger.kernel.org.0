Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E806E5B716B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiIMOgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiIMOfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6837B5FAFD;
        Tue, 13 Sep 2022 07:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 664F3614D0;
        Tue, 13 Sep 2022 14:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD27C433D6;
        Tue, 13 Sep 2022 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078715;
        bh=adIkxnPNNsY0WAl+jf8NAEX/g5zbCxTcqa0hLkWCnso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxWIxstyhsieYvYv/Owviu+8uFjwc93rILjd+l0/0LlqxV9EJsBiBXanyo4pKDROP
         olxnRBkyFDx7Yw2n3vBf7AoTxlFWhKq1npexcoEBIz7jDgacEMWeWgiGVfM/zwqRdB
         mr6GzqJE7y6q2+5B+VdM4hYhek2nedx1mejW0wjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        kernel test robot <lkp@intel.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/121] tee: fix compiler warning in tee_shm_register()
Date:   Tue, 13 Sep 2022 16:04:06 +0200
Message-Id: <20220913140359.720184906@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jens Wiklander <jens.wiklander@linaro.org>

[ Upstream commit eccd7439709810127563e7e3e49b8b44c7b2791d ]

Include <linux/uaccess.h> to avoid the warning:
   drivers/tee/tee_shm.c: In function 'tee_shm_register':
>> drivers/tee/tee_shm.c:242:14: error: implicit declaration of function 'access_ok' [-Werror=implicit-function-declaration]
     242 |         if (!access_ok((void __user *)addr, length))
         |              ^~~~~~~~~
   cc1: some warnings being treated as errors

Fixes: 573ae4f13f63 ("tee: add overflow check in register_shm_helper()")
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_shm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 6e662fb131d55..bd96ebb82c8ec 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/tee_drv.h>
+#include <linux/uaccess.h>
 #include <linux/uio.h>
 #include "tee_private.h"
 
-- 
2.35.1



