Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1784F3636
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343735AbiDEK7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347254AbiDEJqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0714265B4;
        Tue,  5 Apr 2022 02:32:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96F6BB81B75;
        Tue,  5 Apr 2022 09:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ECBC385A0;
        Tue,  5 Apr 2022 09:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151159;
        bh=qpTGx4gDrgTo3X7NXcmSJU5PQ3KXhSa0WjJz1pCzu00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIBepy08WW5C8adJgPqi4TBgJ3hdW3nCDpTrE6w9eUkD+4/3BjuwKdoxwSo1QQ+P1
         qpBBtYEM76wkuLyn9KzQH5+AZfUI/WFA83jvUiTz6mAIgxD6sMx2fMSkCZr/SCnVUM
         Dp5wh+nJNguAjl64uydaxhmM/RxY1d+QAtXEPyZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/913] media: cedrus: H265: Fix neighbour info buffer size
Date:   Tue,  5 Apr 2022 09:22:57 +0200
Message-Id: <20220405070349.295036113@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit ee8b887329c78971967506f3ac79b9302c9f83c1 ]

Neighbour info buffer size needs to be 794 kiB in H6. This is actually
already indirectly mentioned in the comment, but smaller size is used
nevertheless.

Increase buffer size to cover H6 needs. Since increase is not that big
in absolute numbers, it doesn't make sense to complicate logic for older
generations.

Bug was discovered using iommu, which reported access error when trying
to play H265 video.

Fixes: 86caab29da78 ("media: cedrus: Add HEVC/H.265 decoding support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index ef0311a16d01..754942ecf064 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -23,7 +23,7 @@
  * Subsequent BSP implementations seem to double the neighbor info buffer size
  * for the H6 SoC, which may be related to 10 bit H265 support.
  */
-#define CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE	(397 * SZ_1K)
+#define CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE	(794 * SZ_1K)
 #define CEDRUS_H265_ENTRY_POINTS_BUF_SIZE	(4 * SZ_1K)
 #define CEDRUS_H265_MV_COL_BUF_UNIT_CTB_SIZE	160
 
-- 
2.34.1



