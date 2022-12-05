Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1943A643432
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiLETnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiLETmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:42:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DE224951
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2619EB8118F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834F7C433D6;
        Mon,  5 Dec 2022 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269209;
        bh=eR3n7Y6xj5f6wioXeWh3ayqUV96CPgz87VmATwMdy2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLZ37Z39r0CCaOi9UcEysLQR5A1S0oav0CO2K4EOqN/dtNKuF/JB0eQlJKlNW1yoH
         7xx7TzUUy75X9f4eLGUgfcL8FupXOuhgVRq/38XSKdJtaZwB0g9tEcJQMDNSAvQL8n
         S1NwBfAue/tJNdrsQ9hzAk1u3lCHx65DYANW9V7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/153] s390/crashdump: fix TOD programmable field size
Date:   Mon,  5 Dec 2022 20:09:27 +0100
Message-Id: <20221205190809.956833051@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
index f96a5857bbfd..01d7c281087f 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -44,7 +44,7 @@ struct save_area {
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



