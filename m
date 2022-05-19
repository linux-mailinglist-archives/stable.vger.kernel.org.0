Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408F052DB6E
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbiESRhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242688AbiESRhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE8DA206B
        for <stable@vger.kernel.org>; Thu, 19 May 2022 10:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8877061839
        for <stable@vger.kernel.org>; Thu, 19 May 2022 17:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944C5C385AA;
        Thu, 19 May 2022 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652981820;
        bh=gzlPC6K/UVihZQ+2ihAjEvSh05MiLKR0N+lthYbK5hY=;
        h=Subject:To:From:Date:From;
        b=lP8IvVYxIi6rR+VqJgrTsvz4SjZ17zKX1Npdrvoh4E7EucYvDIDh1vOXTmzSqin6+
         PAq4twDj4II+D6r4TeKU+/Xzna2ixc2YXHFEkOhggtwfhs1XuikXwjK+UFGafQY/Oz
         Et5Df5jBJTfk33uZxfAtlozV6GeXSC40JKhozyEU=
Subject: patch "staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()" added to staging-next
To:     denis.e.efremov@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 May 2022 19:36:57 +0200
Message-ID: <165298181714250@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


