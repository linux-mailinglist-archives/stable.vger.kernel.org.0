Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A163A61EF
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhFNKxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhFNKvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:51:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFEF6146D;
        Mon, 14 Jun 2021 10:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667140;
        bh=tvLoqzVpz+hfoaoCueHS9NT91deAefQFmGhD2DrbmEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLHNJStP5Z/bEuuhTJaj4PH4o0cm0w4X6JvHsdQotWYZQehvBjrbSmkYxNpqAR9uH
         yCzWGM3vPjK8Ei3Mn0rtNFurDXqhWnp8Hj2WLBOr0Abyzx/CzzOhxNkJeg1xmJXD3Z
         7iNIDbzi7LJKaeAca4Kux8Nc2LLrxDVQZhyaP1/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenli Looi <wlooi@ucalgary.ca>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.4 42/84] staging: rtl8723bs: Fix uninitialized variables
Date:   Mon, 14 Jun 2021 12:27:20 +0200
Message-Id: <20210614102647.797213998@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenli Looi <wlooi@ucalgary.ca>

commit 43c85d770db80cb135f576f8fde6ff1a08e707a4 upstream.

The sinfo.pertid and sinfo.generation variables are not initialized and
it causes a crash when we use this as a wireless access point.

[  456.873025] ------------[ cut here ]------------
[  456.878198] kernel BUG at mm/slub.c:3968!
[  456.882680] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM

  [ snip ]

[  457.271004] Backtrace:
[  457.273733] [<c02b7ee4>] (kfree) from [<c0e2a470>] (nl80211_send_station+0x954/0xfc4)
[  457.282481]  r9:eccca0c0 r8:e8edfec0 r7:00000000 r6:00000011 r5:e80a9480 r4:e8edfe00
[  457.291132] [<c0e29b1c>] (nl80211_send_station) from [<c0e2b18c>] (cfg80211_new_sta+0x90/0x1cc)
[  457.300850]  r10:e80a9480 r9:e8edfe00 r8:ea678cca r7:00000a20 r6:00000000 r5:ec46d000
[  457.309586]  r4:ec46d9e0
[  457.312433] [<c0e2b0fc>] (cfg80211_new_sta) from [<bf086684>] (rtw_cfg80211_indicate_sta_assoc+0x80/0x9c [r8723bs])
[  457.324095]  r10:00009930 r9:e85b9d80 r8:bf091050 r7:00000000 r6:00000000 r5:0000001c
[  457.332831]  r4:c1606788
[  457.335692] [<bf086604>] (rtw_cfg80211_indicate_sta_assoc [r8723bs]) from [<bf03df38>] (rtw_stassoc_event_callback+0x1c8/0x1d4 [r8723bs])
[  457.349489]  r7:ea678cc0 r6:000000a1 r5:f1225f84 r4:f086b000
[  457.355845] [<bf03dd70>] (rtw_stassoc_event_callback [r8723bs]) from [<bf048e4c>] (mlme_evt_hdl+0x8c/0xb4 [r8723bs])
[  457.367601]  r7:c1604900 r6:f086c4b8 r5:00000000 r4:f086c000
[  457.373959] [<bf048dc0>] (mlme_evt_hdl [r8723bs]) from [<bf03693c>] (rtw_cmd_thread+0x198/0x3d8 [r8723bs])
[  457.384744]  r5:f086e000 r4:f086c000
[  457.388754] [<bf0367a4>] (rtw_cmd_thread [r8723bs]) from [<c014a214>] (kthread+0x170/0x174)
[  457.398083]  r10:ed7a57e8 r9:bf0367a4 r8:f086b000 r7:e8ede000 r6:00000000 r5:e9975200
[  457.406828]  r4:e8369900
[  457.409653] [<c014a0a4>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
[  457.417718] Exception stack(0xe8edffb0 to 0xe8edfff8)
[  457.423356] ffa0:                                     00000000 00000000 00000000 00000000
[  457.432492] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  457.441618] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  457.449006]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c014a0a4
[  457.457750]  r4:e9975200
[  457.460574] Code: 1a000003 e5953004 e3130001 1a000000 (e7f001f2)
[  457.467381] ---[ end trace 4acbc8c15e9e6aa7 ]---

Link: https://forum.armbian.com/topic/14727-wifi-ap-kernel-bug-in-kernel-5444/
Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
Fixes: f5ea9120be2e ("nl80211: add generation number to all dumps")
Signed-off-by: Wenli Looi <wlooi@ucalgary.ca>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210608064620.74059-1-wlooi@ucalgary.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -2406,7 +2406,7 @@ void rtw_cfg80211_indicate_sta_assoc(str
 	DBG_871X(FUNC_ADPT_FMT"\n", FUNC_ADPT_ARG(padapter));
 
 	{
-		struct station_info sinfo;
+		struct station_info sinfo = {};
 		u8 ie_offset;
 		if (GetFrameSubType(pmgmt_frame) == WIFI_ASSOCREQ)
 			ie_offset = _ASOCREQ_IE_OFFSET_;


