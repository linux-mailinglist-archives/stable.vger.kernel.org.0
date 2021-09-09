Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B527F404A17
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhIILop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237876AbhIILnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA306611F2;
        Thu,  9 Sep 2021 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187723;
        bh=R/FP0+oAVo2AeNFA7qf0OxWozrEBzLnjnBDryWXRD4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GATFNgfIaD2J6gbcv2RtQnThVSI1oTPb0mjNhR/27rYOJD70pm3A2ZqAJa430+z66
         vdnIuFgJjN//SodcHW7mNbJGk7mdFC6WZNbLd3tbCW8fvI/u+7F/YAMOajOcXLTxU0
         VOhGMVQLi8m7tcuPDl9uimpSOsXTspn7MjQ6/eyfnxRwAextl4HOqRyW7XqYGgbnIx
         tu03P9WFz5n62z28EBhD1ea7+/Ul1UehjMyzgIOa/aQ90Bw2S4WMXvfM/nkcXr2DpH
         s/826/JhnmR7jINyy3D0Byzd6F9D0OPeGRT4ZhfjGPYAeiBb9Kj2OTsMzYpc7WByyM
         8bg93h4SosmQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 044/252] staging: rtl8188eu: remove rtw_wx_set_rate handler function
Date:   Thu,  9 Sep 2021 07:37:38 -0400
Message-Id: <20210909114106.141462-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit ac5951a6e3d50cfa861ea83baa2ec15d994389cb ]

Remove rtw_wx_set_rate handler function, which currently handles the
SIOCSIWRATE wext ioctl. This function (although containing a lot of
code) set nothing outside its own local variables, and did nothing other
than call a now removed debugging statement repeatedly. Removing it and
leaving its associated entry in rtw_handlers as NULL is therefore the
better option. Removing this function also fixes a kernel test robot
warning.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210625191658.1299-1-phil@philpotter.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/rtl8188eu/os_dep/ioctl_linux.c    | 75 -------------------
 1 file changed, 75 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index b958a8d882b0..d4dce8ef0322 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1262,80 +1262,6 @@ static int rtw_wx_get_essid(struct net_device *dev,
 	return 0;
 }
 
-static int rtw_wx_set_rate(struct net_device *dev,
-			   struct iw_request_info *a,
-			   union iwreq_data *wrqu, char *extra)
-{
-	int i;
-	u8 datarates[NumRates];
-	u32	target_rate = wrqu->bitrate.value;
-	u32	fixed = wrqu->bitrate.fixed;
-	u32	ratevalue = 0;
-	u8 mpdatarate[NumRates] = {11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0xff};
-
-	if (target_rate == -1) {
-		ratevalue = 11;
-		goto set_rate;
-	}
-	target_rate /= 100000;
-
-	switch (target_rate) {
-	case 10:
-		ratevalue = 0;
-		break;
-	case 20:
-		ratevalue = 1;
-		break;
-	case 55:
-		ratevalue = 2;
-		break;
-	case 60:
-		ratevalue = 3;
-		break;
-	case 90:
-		ratevalue = 4;
-		break;
-	case 110:
-		ratevalue = 5;
-		break;
-	case 120:
-		ratevalue = 6;
-		break;
-	case 180:
-		ratevalue = 7;
-		break;
-	case 240:
-		ratevalue = 8;
-		break;
-	case 360:
-		ratevalue = 9;
-		break;
-	case 480:
-		ratevalue = 10;
-		break;
-	case 540:
-		ratevalue = 11;
-		break;
-	default:
-		ratevalue = 11;
-		break;
-	}
-
-set_rate:
-
-	for (i = 0; i < NumRates; i++) {
-		if (ratevalue == mpdatarate[i]) {
-			datarates[i] = mpdatarate[i];
-			if (fixed == 0)
-				break;
-		} else {
-			datarates[i] = 0xff;
-		}
-	}
-
-	return 0;
-}
-
 static int rtw_wx_get_rate(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
@@ -2715,7 +2641,6 @@ static iw_handler rtw_handlers[] = {
 	IW_HANDLER(SIOCSIWESSID, rtw_wx_set_essid),
 	IW_HANDLER(SIOCGIWESSID, rtw_wx_get_essid),
 	IW_HANDLER(SIOCGIWNICKN, rtw_wx_get_nick),
-	IW_HANDLER(SIOCSIWRATE, rtw_wx_set_rate),
 	IW_HANDLER(SIOCGIWRATE, rtw_wx_get_rate),
 	IW_HANDLER(SIOCSIWRTS, rtw_wx_set_rts),
 	IW_HANDLER(SIOCGIWRTS, rtw_wx_get_rts),
-- 
2.30.2

