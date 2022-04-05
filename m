Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C734F31AE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbiDEKhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbiDEJd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0C24FC62;
        Tue,  5 Apr 2022 02:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0778261645;
        Tue,  5 Apr 2022 09:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D1EC385A0;
        Tue,  5 Apr 2022 09:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150542;
        bh=XB2ZAnqs10KWvSqh5mAX4FfDP5UtSANZ3tDNnXYKoYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDkSF+oAl5Xc7MWGNZyS/Adgz/ieoiP5Xo00a9yFbeB8v/b6ls9EfsitYVNKstwYK
         fgvFSsqUHSkraLjHo+9SHkKTQ4CqEQZNifGul8/T/9Og8aSAQ1BvSkMejYzXFWWe61
         7i39e60NMq0lv1AqJLDjt1vWQUrhVacc+2VOL0BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Shubin <n.shubin@yadro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 094/913] riscv: Fix fill_callchain return value
Date:   Tue,  5 Apr 2022 09:19:16 +0200
Message-Id: <20220405070342.646868015@linuxfoundation.org>
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

From: Nikita Shubin <n.shubin@yadro.com>

commit 2b2b574ac587ec5bd7716a356492a85ab8b0ce9f upstream.

perf_callchain_store return 0 on success, -1 otherwise,
fix fill_callchain to return correct bool value.

Fixes: dbeb90b0c1eb ("riscv: Add perf callchain support")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/perf_callchain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -73,7 +73,7 @@ void perf_callchain_user(struct perf_cal
 
 static bool fill_callchain(void *entry, unsigned long pc)
 {
-	return perf_callchain_store(entry, pc);
+	return perf_callchain_store(entry, pc) == 0;
 }
 
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,


