Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A559DFB4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbiHWLVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351841AbiHWLUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C849E75CC7;
        Tue, 23 Aug 2022 02:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456BAB8105C;
        Tue, 23 Aug 2022 09:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF42C433D7;
        Tue, 23 Aug 2022 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246550;
        bh=GuioARgipAjckdAdajthvc005UG73r+y/SYqcn3+24w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ovp5lokzLzu/9Y5SuB0tMMP+ZmCTSWWkwiu+4rvp3MiTI4y5+4zhzy9oikUSvqmGS
         Zj9BI35IqjXfX2ZGzMTQmCmZDzP4SUQFxb46xZegmgHzhdjKoi+RMkW0ovmTQROvGh
         nzazswe+lw4EsXgAA7kmtKatvBQeIsQxm1Go3xMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/389] wifi: libertas: Fix possible refcount leak in if_usb_probe()
Date:   Tue, 23 Aug 2022 10:23:44 +0200
Message-Id: <20220823080121.696144044@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 6fd57e1d120bf13d4dc6c200a7cf914e6347a316 ]

usb_get_dev will be called before lbs_get_firmware_async which means that
usb_put_dev need to be called when lbs_get_firmware_async fails.

Fixes: ce84bb69f50e ("libertas USB: convert to asynchronous firmware loading")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220620092350.39960-1-hbh25y@gmail.com
Link: https://lore.kernel.org/r/20220622113402.16969-1-colin.i.king@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 5d6dc1dd050d..32fdc4150b60 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -287,6 +287,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	return 0;
 
 err_get_fw:
+	usb_put_dev(udev);
 	lbs_remove_card(priv);
 err_add_card:
 	if_usb_reset_device(cardp);
-- 
2.35.1



