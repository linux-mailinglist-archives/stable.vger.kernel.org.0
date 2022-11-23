Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92E635347
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiKWIxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiKWIxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:53:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA1027FD0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8551ACE20E5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E20C433C1;
        Wed, 23 Nov 2022 08:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193586;
        bh=ltgVwSfiV2GEztLdYLVwBU7SjhKV4d4MID3pEIDOxlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dp2syjRWxYAAykiNwrLfDWOWUV95AYh/3NS6m0M4qdKkTVOa4WR/qB/4diR5JfAwT
         +AAqjBAajspPTvMghZkZJFcMqAegaJMcL6fs1IGX033QwiiZNXZf0FACBWpE8raaFv
         SzmDhtUdJl/pPamOw4dHfkbGZQa9aIx/CSIWK+t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/76] HID: hyperv: fix possible memory leak in mousevsc_probe()
Date:   Wed, 23 Nov 2022 09:50:00 +0100
Message-Id: <20221123084546.792182149@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b5bcb94b0954a026bbd671741fdb00e7141f9c91 ]

If hid_add_device() returns error, it should call hid_destroy_device()
to free hid_dev which is allocated in hid_allocate_device().

Fixes: 74c4fb058083 ("HID: hv_mouse: Properly add the hid device")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 6039f071fab1..15e20d5e76dd 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -536,7 +536,7 @@ static int mousevsc_probe(struct hv_device *device,
 
 	ret = hid_add_device(hid_dev);
 	if (ret)
-		goto probe_err1;
+		goto probe_err2;
 
 
 	ret = hid_parse(hid_dev);
-- 
2.35.1



