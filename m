Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6F9540F19
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352268AbiFGTBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354269AbiFGTBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:01:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02696150B74;
        Tue,  7 Jun 2022 11:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40EB2B82182;
        Tue,  7 Jun 2022 18:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973C5C385A5;
        Tue,  7 Jun 2022 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625078;
        bh=vZmvHM2DfQ7VRp/VGBoT9ovMvxCa/klpEUTu4j7ejho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hH8PLNVSDeJf6FB/NyjwNUG/6wSOh0jl13W9eHqig4fT0PHylgEd8r/k+DU9HyydT
         on1Wr+/ojqkt7GrlzPjxsXaj9tqxK1UwrtdTZaPxAzQxzHUnvAIpypqpS20NwNseTv
         rliYPm0wgrNU/EeqCr6OFDELMhY/SJNQ0ByL2yLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <denis.e.efremov@oracle.com>
Subject: [PATCH 5.15 557/667] staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()
Date:   Tue,  7 Jun 2022 19:03:42 +0200
Message-Id: <20220607164951.405242820@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <denis.e.efremov@oracle.com>

commit bc10916e890948d8927a5c8c40fb5dc44be5e1b8 upstream.

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->Ssid[] array.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
Link: https://lore.kernel.org/r/20220518070052.108287-1-denis.e.efremov@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1249,9 +1249,11 @@ static int rtw_wx_set_scan(struct net_de
 						break;
 					}
 					sec_len = *(pos++); len -= 1;
-					if (sec_len > 0 && sec_len <= len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].SsidLength = sec_len;
-						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
+						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
 						ssid_index++;
 					}
 					pos += sec_len;


