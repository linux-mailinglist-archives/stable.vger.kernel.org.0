Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0828C4F38B3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377095AbiDEL1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349554AbiDEJuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA389B;
        Tue,  5 Apr 2022 02:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C220B818F3;
        Tue,  5 Apr 2022 09:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05763C385A2;
        Tue,  5 Apr 2022 09:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152095;
        bh=xc5tT771KBxay9UwO9nhcapUuxOWzNj8GgPN+OHumyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwx3qXTWwKb04BYfesn1bHmSSwkxxs/KYdGmuC0r94HDY87Of9VY9ucpsXJKslpf1
         EmHwOh8mepmkWiVRQrBbPdkZ1oLZasmmlV5UhrxSpTovCA7KS0vr7bwc8msQ5Sfl5q
         2FFlcSA3ezPC6WfFqFI/1RXFSc4NscUnyxpDOBe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 652/913] kdb: Fix the putarea helper function
Date:   Tue,  5 Apr 2022 09:28:34 +0200
Message-Id: <20220405070359.382969619@linuxfoundation.org>
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



