Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A799859409D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbiHOVTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244827AbiHOVQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DB8DEA49;
        Mon, 15 Aug 2022 12:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E1F46009B;
        Mon, 15 Aug 2022 19:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99808C433D7;
        Mon, 15 Aug 2022 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591208;
        bh=GuioARgipAjckdAdajthvc005UG73r+y/SYqcn3+24w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=063c/KeTiRqIUf8a46zzf9I8U6XesB6/F/HomPsMACkqrd2KvRdrRHUxzsnfsXEoT
         /R+1Xj71bUpIMMWoRrcvOY8FZ8yFvszAZxnSnA5BJuINoS83VjVvnsCcV+YY155iTr
         TjPLQ0pW6GT8V1jNkY40hux5qHQaVOmg3IHG1Kas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0507/1095] wifi: libertas: Fix possible refcount leak in if_usb_probe()
Date:   Mon, 15 Aug 2022 19:58:26 +0200
Message-Id: <20220815180450.503605787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



