Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149A14F312A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242076AbiDEIgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CB963EC;
        Tue,  5 Apr 2022 01:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64CA609D0;
        Tue,  5 Apr 2022 08:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB15BC385A0;
        Tue,  5 Apr 2022 08:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146605;
        bh=xc5tT771KBxay9UwO9nhcapUuxOWzNj8GgPN+OHumyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDM6NEXSVoHOrSBdJXOVp/WgZRvK38HxXDiDVZomqszqJpHnrysBQqmR3D5rY3fIi
         l2ge+TKL6kmCpQmMhKRc82KprC3QguNWR8i/cppMVkHGojlwO5+C33G+iH2xVY55Y9
         jVfielsX1eWyaucPeH3lK3ImqfDCnFd13B2mxcPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0797/1126] kdb: Fix the putarea helper function
Date:   Tue,  5 Apr 2022 09:25:44 +0200
Message-Id: <20220405070430.965951446@linuxfoundation.org>
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

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit c1cb81429df462eca1b6ba615cddd21dd3103c46 ]

Currently kdb_putarea_size() uses copy_from_kernel_nofault() to write *to*
arbitrary kernel memory. This is obviously wrong and means the memory
modify ('mm') command is a serious risk to debugger stability: if we poke
to a bad address we'll double-fault and lose our debug session.

Fix this the (very) obvious way.

Note that there are two Fixes: tags because the API was renamed and this
patch will only trivially backport as far as the rename (and this is
probably enough). Nevertheless Christoph's rename did not introduce this
problem so I wanted to record that!

Fixes: fe557319aa06 ("maccess: rename probe_kernel_{read,write} to copy_{from,to}_kernel_nofault")
Fixes: 5d5314d6795f ("kdb: core for kgdb back end (1 of 2)")
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220128144055.207267-1-daniel.thompson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_support.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index df2bface866e..85cb51c4a17e 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -291,7 +291,7 @@ int kdb_getarea_size(void *res, unsigned long addr, size_t size)
  */
 int kdb_putarea_size(unsigned long addr, void *res, size_t size)
 {
-	int ret = copy_from_kernel_nofault((char *)addr, (char *)res, size);
+	int ret = copy_to_kernel_nofault((char *)addr, (char *)res, size);
 	if (ret) {
 		if (!KDB_STATE(SUPPRESS)) {
 			kdb_func_printf("Bad address 0x%lx\n", addr);
-- 
2.34.1



