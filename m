Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451505A6966
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiH3RSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiH3RSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:18:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B36AD345B;
        Tue, 30 Aug 2022 10:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E2661781;
        Tue, 30 Aug 2022 17:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7A9C433D6;
        Tue, 30 Aug 2022 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879908;
        bh=rqld0LvDVhzWFpEjDb8wjNHR//5uTqyyn0tKTLTW/0g=;
        h=From:To:Cc:Subject:Date:From;
        b=i0JPenE1ZQyR9Mwfjv7hlkLd4nQ0zRj+eBeB7ciPRg/JbAI6unRsxd2p90c50vA8t
         YP1Yvu/0HVuGvUVkIQVVEaw78gd638vo/K5F62Bq04GP1BVQmWSkqJs+mMqXPj7cWa
         VoFwDJc3+me+KnnYzEp2Xq3A2e9XFtlHaRv3DQfUZZdorjfoww6v0xVJsPvsroUpmB
         9+t+uKRjIaTHxKugwKk607RPZEIn3G8RK1td9EC90e4jNSfrCVnF5fsDN6wCRmUX9i
         7nd9KAuUJ93892HrglFcO99Pobo2DiwBxTA1bSFjYgq6eIK/EjOmBQ//oI1xe2GWRL
         BDyhKoHZOhYvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com
Subject: [PATCH AUTOSEL 5.19 01/33] firmware: dmi: Use the proper accessor for the version field
Date:   Tue, 30 Aug 2022 13:17:52 -0400
Message-Id: <20220830171825.580603-1-sashal@kernel.org>
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
index f191a1f901ac7..0eb6b617f709a 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -630,7 +630,7 @@ static int __init dmi_smbios3_present(const u8 *buf)
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

