Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AD25AECCD
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241034AbiIFOUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241679AbiIFOSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:18:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DCB192BA;
        Tue,  6 Sep 2022 06:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04C160F89;
        Tue,  6 Sep 2022 13:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56F4C433D6;
        Tue,  6 Sep 2022 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472130;
        bh=bOH//3r1sn7VoNf/+feYB6lm64dlFs6/NrJkt6m8cEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTquXGC9A7IIyXWlinWLEiFburh+3ankMPuKGV999maRfVXTIbHty5hwCpeE4oIsX
         tDb7adnWRtC2slJgxzCoN7qVf5Bbcuc9/rrrnBzpMDouYACn4Gr1aEiJ+tqqK2nfdr
         ZAVs+BRohGxi8TYtRFTQHFAAONJG8rQC7NIlsfgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Levi Yun <ppbuk5246@gmail.com>,
        Baoquan He <bhe@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 137/155] arm64/kexec: Fix missing extra range for crashkres_low.
Date:   Tue,  6 Sep 2022 15:31:25 +0200
Message-Id: <20220906132835.261723901@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Levi Yun <ppbuk5246@gmail.com>

commit 4831be702b95047c89b3fa5728d07091e9e9f7c9 upstream.

Like crashk_res, Calling crash_exclude_mem_range function with
crashk_low_res area would need extra crash_mem range too.

Add one more extra cmem slot in case of crashk_low_res is used.

Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Fixes: 944a45abfabc ("arm64: kdump: Reimplement crashkernel=X")
Cc: <stable@vger.kernel.org> # 5.19.x
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220831103913.12661-1-ppbuk5246@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/machine_kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -47,7 +47,7 @@ static int prepare_elf_headers(void **ad
 	u64 i;
 	phys_addr_t start, end;
 
-	nr_ranges = 1; /* for exclusion of crashkernel region */
+	nr_ranges = 2; /* for exclusion of crashkernel region */
 	for_each_mem_range(i, &start, &end)
 		nr_ranges++;
 


