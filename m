Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A8755D67B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbiF0LuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238327AbiF0LsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B3BF5AE;
        Mon, 27 Jun 2022 04:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 853A2B81135;
        Mon, 27 Jun 2022 11:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF33EC3411D;
        Mon, 27 Jun 2022 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330040;
        bh=fLv9Z5zYBa6k80avfKlFPpGIGGwWWoBNa9hCd1onJXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBbESK9oXgHwUWtVTk4gV4lx2p+6k4TP0vuoCmcTWFRSqUaa/zYKZ2MsaV/20tuVf
         2bz9S3SiCBp5ZEeTe2HcE9lpxx3cc9OoG3BJoFszzOFPzFZcurM6iOdrEVYUN0I112
         ERUFOmKOTAEbT3OMquV5nPcpFE/9f70pZayvMXoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 064/181] ethtool: Fix get module eeprom fallback
Date:   Mon, 27 Jun 2022 13:20:37 +0200
Message-Id: <20220627111946.422009251@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit a3bb7b63813f674fb62bac321cdd897cc62de094 ]

Function fallback_set_params() checks if the module type returned
by a driver is ETH_MODULE_SFF_8079 and in this case it assumes
that buffer returns a concatenated content of page  A0h and A2h.
The check is wrong because the correct type is ETH_MODULE_SFF_8472.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220616160856.3623273-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 7e6b37a54add..1c94bb8ea03f 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -36,7 +36,7 @@ static int fallback_set_params(struct eeprom_req_info *request,
 	if (request->page)
 		offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
 
-	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	if (modinfo->type == ETH_MODULE_SFF_8472 &&
 	    request->i2c_address == 0x51)
 		offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;
 
-- 
2.35.1



