Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09B85A6AB2
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiH3RcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiH3Rbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E598215A22F;
        Tue, 30 Aug 2022 10:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A33926172E;
        Tue, 30 Aug 2022 17:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C702C433D6;
        Tue, 30 Aug 2022 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880394;
        bh=Cx3NCVGl9rL1VmquS8ug9Pt3v1Kb/1dTU9gwmJuCk8U=;
        h=From:To:Cc:Subject:Date:From;
        b=SoMlJHN9IOvsVY/YPsZETuoLqjV5Gfg4aVQMlz9+KdwzQ/5fD307zcd2F2005dpIy
         L7DUjE7kwYHAQWLrHYcz+rw19r+HYretvC+gt/jGWUMGpXfzv3AEGia56FKwP6jdGY
         vnCEGQM9pLHwlwJrJnDYpF279RgmTS4khCCzFerivfS8WAGyTEdfNa5PmgXKGWoktp
         4gdTVIZ5GfjNuh3mpnNW4H3ScRYX004Hc6sXXOuITUBI/G/p3XbXGDIcXreMeuIuOk
         fYWcfbuJzEcX/FNcbpcbCwj8VhKe8NNG0GdryMdujjt0pCqamuMczEs7bFdZ8ooxmH
         Rix0E/LyY00Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com
Subject: [PATCH AUTOSEL 4.14 1/8] firmware: dmi: Use the proper accessor for the version field
Date:   Tue, 30 Aug 2022 13:26:24 -0400
Message-Id: <20220830172631.581969-1-sashal@kernel.org>
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
index fe0d30340e963..d07a15462e252 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -582,7 +582,7 @@ static int __init dmi_smbios3_present(const u8 *buf)
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

