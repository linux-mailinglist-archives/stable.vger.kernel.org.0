Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F645011C8
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbiDNNrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245720AbiDNNiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F154FA775F;
        Thu, 14 Apr 2022 06:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B1A3B8296A;
        Thu, 14 Apr 2022 13:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F199C385A9;
        Thu, 14 Apr 2022 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943236;
        bh=THp10zfbheMGkdsFb2ypKQPDgiD3uLbVdWmdaU/PPOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zltmYsw4QQpikjHfHQXE8LghbYvGUSjPiD6bBUtJAH+P2pfDMnoQIAh7d1xxZkWsJ
         buLnmOgvJKb59/hieVdbdXKAQhcoO5B7agHhNblJczUDyYviW4BK7CcvYnd8MajGtj
         O+X9Zu1iqNN3F7SIfSObpcv3osZPwcnslIE7osKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.4 082/475] xtensa: fix xtensa_wsr always writing 0
Date:   Thu, 14 Apr 2022 15:07:47 +0200
Message-Id: <20220414110857.449295004@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Max Filippov <jcmvbkbc@gmail.com>

commit a3d0245c58f962ee99d4440ea0eaf45fb7f5a5cc upstream.

The commit cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
replaced 'WSR' macro in the function xtensa_wsr with 'xtensa_set_sr',
but variable 'v' in the xtensa_set_sr body shadowed the argument 'v'
passed to it, resulting in wrong value written to debug registers.

Fix that by removing intermediate variable from the xtensa_set_sr
macro body.

Cc: stable@vger.kernel.org
Fixes: cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/processor.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -225,8 +225,8 @@ extern unsigned long get_wchan(struct ta
 
 #define xtensa_set_sr(x, sr) \
 	({ \
-	 unsigned int v = (unsigned int)(x); \
-	 __asm__ __volatile__ ("wsr %0, "__stringify(sr) :: "a"(v)); \
+	 __asm__ __volatile__ ("wsr %0, "__stringify(sr) :: \
+			       "a"((unsigned int)(x))); \
 	 })
 
 #define xtensa_get_sr(sr) \


