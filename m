Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEBB52DB69
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241770AbiESRgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243044AbiESRg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:36:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582DC5D5C0
        for <stable@vger.kernel.org>; Thu, 19 May 2022 10:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9667CE26F6
        for <stable@vger.kernel.org>; Thu, 19 May 2022 17:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A063DC385AA;
        Thu, 19 May 2022 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652981783;
        bh=cTi3SNu2m62dKpiJ9Q19p89lyv+DFNP875lZC+r7AbE=;
        h=Subject:To:From:Date:From;
        b=OdT9D7ApeN3ZzDjyQ6Gz/UKZC2pe0jUaxXEh6YxkB9/yVmBtDG0FxEPUDyKQ2qP+r
         1aSHdyDnXRktwCl8p7H4Fi0jQpw3nfNYUpX5mvTZsseCwums2rr+brjesysyuJ7tDa
         zn3Ruppo+D+ddzH1hc3zGNNUupgJIQsG4jKeAAVQ=
Subject: patch "staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()" added to staging-testing
To:     denis.e.efremov@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 May 2022 19:36:20 +0200
Message-ID: <1652981780235138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bc10916e890948d8927a5c8c40fb5dc44be5e1b8 Mon Sep 17 00:00:00 2001
From: Denis Efremov <denis.e.efremov@oracle.com>
Date: Wed, 18 May 2022 11:00:52 +0400
Subject: staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->Ssid[] array.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
Link: https://lore.kernel.org/r/20220518070052.108287-1-denis.e.efremov@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index a802c1e7b456..9c1f576e067a 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1131,9 +1131,11 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
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
-- 
2.36.1


