Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B6E593A69
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbiHOTgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbiHOTfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:35:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E2F13E23;
        Mon, 15 Aug 2022 11:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE279611C1;
        Mon, 15 Aug 2022 18:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3837C433D7;
        Mon, 15 Aug 2022 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589126;
        bh=ezq9bND8emS5xMQV7ZmKm2wM1mVM8Yl7j5xThVo+uFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coKxv9tMgHJnYTEqTre5wosSKgvRBq3iwNXpOPeqhojCT2bZ+usUvDCTVAwyJhT31
         MW3DxMT/ObjKuUWV1wdbfaqRXdFReJvBzpKSj9pdaT01xMiteBJzyIQzZdOn4CDZvx
         RcOp7rycApHcz5BLEsFFdqAHmMvOWyIOwpCUyMeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 621/779] s390/crash: fix incorrect number of bytes to copy to user space
Date:   Mon, 15 Aug 2022 20:04:25 +0200
Message-Id: <20220815180403.929995313@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit f6749da17a34eb08c9665f072ce7c812ff68aad2 ]

The number of bytes in a chunk is correctly calculated, but instead
the total number of bytes is passed to copy_to_user_real() function.

Reported-by: Matthew Wilcox <willy@infradead.org>
Fixes: df9694c7975f ("s390/dump: streamline oldmem copy functions")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/crash_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 199f136d1644..f17ad2daab07 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -198,7 +198,7 @@ static int copy_oldmem_user(void __user *dst, unsigned long src, size_t count)
 			} else {
 				len = count;
 			}
-			rc = copy_to_user_real(dst, src, count);
+			rc = copy_to_user_real(dst, src, len);
 			if (rc)
 				return rc;
 		}
-- 
2.35.1



