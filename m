Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE0F29B833
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799880AbgJ0Pdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799876AbgJ0Pdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A96D22263;
        Tue, 27 Oct 2020 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812832;
        bh=X0JhAcdX0GJjijwZDUlnwnbHgDOOhxJpSUNZtm3TzUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBVVFYyYYdR/ka3MJLl3gK9smTxxW4sTKuThiNFl5mvFhe0ESWe7kh5dOkIvCuvFr
         j/ZDCxQcFpVeXtz5jnfuvnIuBQVd0YaQerZRluaKw4Tz0ovw0iMksII4BD7TXPrnLj
         w0mHPyQDux4alJNLUzxcStNtY2roYG6mAKU0Vcno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chin-Yen Lee <timlee@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 314/757] rtw88: Fix potential probe error handling race with wow firmware loading
Date:   Tue, 27 Oct 2020 14:49:24 +0100
Message-Id: <20201027135505.265834977@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Färber <afaerber@suse.de>

[ Upstream commit ac4bac99161e8f7a7a9faef70d8ca8f69d5493a9 ]

If rtw_core_init() fails to load the wow firmware, rtw_core_deinit()
will not get called to clean up the regular firmware.

Ensure that an error loading the wow firmware does not produce an oops
for the regular firmware by waiting on its completion to be signalled
before returning. Also release the loaded firmware.

Fixes: c8e5695eae99 ("rtw88: load wowlan firmware if wowlan is supported")
Cc: Chin-Yen Lee <timlee@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200920132621.26468-3-afaerber@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 58c760dfd6b80..d69e4c6fc680a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1473,6 +1473,9 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 		ret = rtw_load_firmware(rtwdev, RTW_WOWLAN_FW);
 		if (ret) {
 			rtw_warn(rtwdev, "no wow firmware loaded\n");
+			wait_for_completion(&rtwdev->fw.completion);
+			if (rtwdev->fw.firmware)
+				release_firmware(rtwdev->fw.firmware);
 			return ret;
 		}
 	}
-- 
2.25.1



