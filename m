Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6B65823C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiL1QeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiL1Qdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC4F1C107
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:31:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BC6CB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20C1C433D2;
        Wed, 28 Dec 2022 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245064;
        bh=8MEO/rRVwQM+oexh/uO6JzcQQF64co5aEekCsfe3xP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8V8d/xIbGSjFlen9t9MKG1X+p8oCwixQi20n1EFnVGgeyTbm2SSvlwQ9t6xc2jg0
         wRrko4ro+4wzscfepCncF++h/OoeU4Rp8kbXqLteSbbc50x1Of040HAEH4sczYh2c0
         HSRHvbuHsjbBMd49polI4TIkmlITq1ppbFKjMQ3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Author: Randy Dunlap" <rdunlap@infradead.org>,
        syzbot+35b87c668935bb55e666@syzkaller.appspotmail.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0790/1146] fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()
Date:   Wed, 28 Dec 2022 15:38:49 +0100
Message-Id: <20221228144351.606454504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit caad9dd8792a2622737b7273cb34835fd9536cd2 ]

syzbot reported UBSAN error as below:

[   76.901829][ T6677] ================================================================================
[   76.903908][ T6677] UBSAN: shift-out-of-bounds in fs/ntfs3/super.c:675:13
[   76.905363][ T6677] shift exponent -247 is negative

This patch avoid this error.

Link: https://syzkaller.appspot.com/bug?id=b0299c09a14aababf0f1c862dd4ebc8ab9eb0179
Fixes: a3b774342fa7 (fs/ntfs3: validate BOOT sectors_per_clusters)
Cc: Author: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+35b87c668935bb55e666@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 47012c9bf505..adc4f73722b7 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -672,7 +672,7 @@ static u32 true_sectors_per_clst(const struct NTFS_BOOT *boot)
 	if (boot->sectors_per_clusters <= 0x80)
 		return boot->sectors_per_clusters;
 	if (boot->sectors_per_clusters >= 0xf4) /* limit shift to 2MB max */
-		return 1U << (0 - boot->sectors_per_clusters);
+		return 1U << -(s8)boot->sectors_per_clusters;
 	return -EINVAL;
 }
 
-- 
2.35.1



