Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E92E5A6A5A
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiH3R2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiH3R1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF3B57241;
        Tue, 30 Aug 2022 10:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2CE161781;
        Tue, 30 Aug 2022 17:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88439C433D6;
        Tue, 30 Aug 2022 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880200;
        bh=m1DDQlsNe7QKH3283oKTTjnnuHKHMLzl4IEH2Y8jjjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=KsrwGLpHbm7iIwj49UZUOhDZknCReJEd/5Jz7zFCViuXG6L2JugnaTfCXK0UGVNWf
         IqlNPaeHt+4zm+io8dqU+6iB0c0hXxIN50v8WIwSrxxDaWBRip/TOvxVdW9PO2ijTD
         Pi1skq1kHpx1JNdLYKYd8s1t7oGc/mMh8wj2S8lj5iKc7IK/hvwKKUj88EXn1xDFgq
         V4Zf1Gu224gvSUStbrs4j2IXBx2hEkPjGnK/Ag+xWZLii54K0XAlGRTiiIQUqUw1yP
         LRyOPGV6HIUOk9uPOtSzh476q/Ct0kLgOjtLDhOuzY0RRGun8cVZN5dmCEbHBJ7DpR
         riaVIfHGlQNgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com
Subject: [PATCH AUTOSEL 5.10 01/16] firmware: dmi: Use the proper accessor for the version field
Date:   Tue, 30 Aug 2022 13:23:02 -0400
Message-Id: <20220830172317.581397-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d2139dfca361a1f5bfc4d4a23455b1a409a69cd4 ]

The byte at offset 6 represents length. Don't take it and drop it
immediately by using proper accessor, i.e. get_unaligned_be24().

[JD: Change the subject to something less frightening]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index d51ca0428bb82..bd43277dbb878 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -629,7 +629,7 @@ static int __init dmi_smbios3_present(const u8 *buf)
 {
 	if (memcmp(buf, "_SM3_", 5) == 0 &&
 	    buf[6] < 32 && dmi_checksum(buf, buf[6])) {
-		dmi_ver = get_unaligned_be32(buf + 6) & 0xFFFFFF;
+		dmi_ver = get_unaligned_be24(buf + 7);
 		dmi_num = 0;			/* No longer specified */
 		dmi_len = get_unaligned_le32(buf + 12);
 		dmi_base = get_unaligned_le64(buf + 16);
-- 
2.35.1

