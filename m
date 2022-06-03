Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2653CEE0
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbiFCRsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345251AbiFCRsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A701357179;
        Fri,  3 Jun 2022 10:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F2FB82436;
        Fri,  3 Jun 2022 17:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5D4C385A9;
        Fri,  3 Jun 2022 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278268;
        bh=JwRn3piZByy6d3OEljMZ0zRxdm1NyDdxdF436yhUpcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j78zxaWy9mhr8NO8wkaIcl2FwAK1qpJVde/w7ZPgbgLYxHQxnxdUdGkl9wn8/KPtf
         iGnIHixFVYpDVfCk6KEPZWo0QpuOIZGW8rAtkCgCqAkVXiZVOW7NM8qOoJlJveU37t
         FB24kf3tWaB/BoRAhvOGpQGww1PRKVc6wjVOp/E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Denis Efremov (Oracle)" <efremov@linux.com>
Subject: [PATCH 5.4 03/34] staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()
Date:   Fri,  3 Jun 2022 19:42:59 +0200
Message-Id: <20220603173816.091930554@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Denis Efremov (Oracle)" <efremov@linux.com>

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->Ssid[] array.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -1351,9 +1351,11 @@ static int rtw_wx_set_scan(struct net_de
 
 					sec_len = *(pos++); len-= 1;
 
-					if (sec_len>0 && sec_len<=len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].SsidLength = sec_len;
-						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
+						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
 						/* DBG_871X("%s COMBO_SCAN with specific ssid:%s, %d\n", __func__ */
 						/* 	, ssid[ssid_index].Ssid, ssid[ssid_index].SsidLength); */
 						ssid_index++;


