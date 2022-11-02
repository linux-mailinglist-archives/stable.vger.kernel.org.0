Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410AA615AFF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKBDpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiKBDps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:45:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDCD2714B
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C384DB80DA8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D25C433D6;
        Wed,  2 Nov 2022 03:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360745;
        bh=lf39bR4mJGC2kjMZuRSH1LXupCmvn9Jl0fFmdPkDtp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCuL2Z/6IYUOMSofbk18n0R6RK81kIGVAVL2LZLfPzgOCZH0VvD/JPz9agcjG+bYm
         3Xy2TyJg6Ll1OFaKnXcYpHo+v4eu2OSudOsLe+7Nul4O2ehBcmfg4366lPomz2iCwy
         Zq8zn/t6yxAgZ/nPvjjIXRPAdr+iVwtLPjI6kEnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nulo <git@nulo.in>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/44] HID: magicmouse: Do not set BTN_MOUSE on double report
Date:   Wed,  2 Nov 2022 03:34:52 +0100
Message-Id: <20221102022049.244314161@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit bb5f0c855dcfc893ae5ed90e4c646bde9e4498bf ]

Under certain conditions the Magic Trackpad can group 2 reports in a
single packet. The packet is split and the raw event function is
invoked recursively for each part.

However, after processing each part, the BTN_MOUSE status is updated,
sending multiple click events. [1]

Return after processing double reports to avoid this issue.

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/811  # [1]
Fixes: a462230e16ac ("HID: magicmouse: enable Magic Trackpad support")
Reported-by: Nulo <git@nulo.in>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221009182747.90730-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 8c993f95e3ba..396a3c720b51 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -342,7 +342,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-		break;
+		return 0;
 	default:
 		return 0;
 	}
-- 
2.35.1



