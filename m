Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DAE4CF74D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbiCGJpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiCGJim (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C54EA2E;
        Mon,  7 Mar 2022 01:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5884DB810BD;
        Mon,  7 Mar 2022 09:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD981C340F3;
        Mon,  7 Mar 2022 09:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645591;
        bh=J2IJqSVavxlY4rZ2bGBmDCSa/4rvdwBbNFQjq4mtJSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lv0OaVKHVfIlA36qOfonnVquY0AHXY8RaJaKMhybJQSONoIopEBjpGqPn0qmMCPHM
         EHbGnk/+LxKQLjkXhdqbLfnaZ1SuiS02EKAD+hCH+4a5+p/8aKe5bPdDWbnQPlVPpr
         Fan/RBpswdVp8LJDTHMIhIhb7NxxhMfuFh8zom2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 081/105] s390/extable: fix exception table sorting
Date:   Mon,  7 Mar 2022 10:19:24 +0100
Message-Id: <20220307091646.456727351@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit c194dad21025dfd043210912653baab823bdff67 upstream.

s390 has a swap_ex_entry_fixup function, however it is not being used
since common code expects a swap_ex_entry_fixup define. If it is not
defined the default implementation will be used. So fix this by adding
a proper define.
However also the implementation of the function must be fixed, since a
NULL value for handler has a special meaning and must not be adjusted.

Luckily all of this doesn't fix a real bug currently: the main extable
is correctly sorted during build time, and for runtime sorting there
is currently no case where the handler field is not NULL.

Fixes: 05a68e892e89 ("s390/kernel: expand exception table logic to allow new handling options")
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/extable.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/extable.h
+++ b/arch/s390/include/asm/extable.h
@@ -69,8 +69,13 @@ static inline void swap_ex_entry_fixup(s
 {
 	a->fixup = b->fixup + delta;
 	b->fixup = tmp.fixup - delta;
-	a->handler = b->handler + delta;
-	b->handler = tmp.handler - delta;
+	a->handler = b->handler;
+	if (a->handler)
+		a->handler += delta;
+	b->handler = tmp.handler;
+	if (b->handler)
+		b->handler -= delta;
 }
+#define swap_ex_entry_fixup swap_ex_entry_fixup
 
 #endif


