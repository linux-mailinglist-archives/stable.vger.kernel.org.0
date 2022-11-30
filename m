Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D418763DFB5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiK3Stp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiK3Stk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD73326D3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1104561D5E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255E6C433D6;
        Wed, 30 Nov 2022 18:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834177;
        bh=JCH72JDUDQ2nGutUOZoiUTytcoqaFhAg6An4Lrj36QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1ikuBhc3bqfNn3UB8tVWH1SoQjrCUeoTVhQpRYQ/EMiaFvIa/helOrEE/GVmh/ci
         2OslCV7cw991ptBpqOBcM7ZK4KzftuP4U3M6+3TBjfif6TEUxUgJddSDmHK3srS0DW
         Fpst7HqT1kuFWLL9EnKYLomykbjGkcJN7rZ91lvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 157/289] s390/crashdump: fix TOD programmable field size
Date:   Wed, 30 Nov 2022 19:22:22 +0100
Message-Id: <20221130180547.693659388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f44e07a8afdd713ddc1a8832c39372fe5dd86895 ]

The size of the TOD programmable field was incorrectly increased from
four to eight bytes with commit 1a2c5840acf9 ("s390/dump: cleanup CPU
save area handling").
This leads to an elf notes section NT_S390_TODPREG which has a size of
eight instead of four bytes in case of kdump, however even worse is
that the contents is incorrect: it is supposed to contain only the
contents of the TOD programmable field, but in fact contains a mix of
the TOD programmable field (32 bit upper bits) and parts of the CPU
timer register (lower 32 bits).

Fix this by simply changing the size of the todpreg field within the
save area structure. This will implicitly also fix the size of the
corresponding elf notes sections.

This also gets rid of this compile time warning:

in function ‘fortify_memcpy_chk’,
    inlined from ‘save_area_add_regs’ at arch/s390/kernel/crash_dump.c:99:2:
./include/linux/fortify-string.h:413:25: error: call to ‘__read_overflow2_field’
   declared with attribute warning: detected read beyond size of field
   (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 1a2c5840acf9 ("s390/dump: cleanup CPU save area handling")
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/crash_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index bad8f47fc5d6..c1b2b0d4af77 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -45,7 +45,7 @@ struct save_area {
 	u64 fprs[16];
 	u32 fpc;
 	u32 prefix;
-	u64 todpreg;
+	u32 todpreg;
 	u64 timer;
 	u64 todcmp;
 	u64 vxrs_low[16];
-- 
2.35.1



