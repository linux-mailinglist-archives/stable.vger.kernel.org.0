Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1901A32B0D6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbhCCAjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376862AbhCBOYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:24:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D45864F0B;
        Tue,  2 Mar 2021 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614694973;
        bh=X8jFVF0hzRMcoDP2QWFN5mkLLPVu/gm451lrK0nTThk=;
        h=Subject:To:From:Date:From;
        b=nNAY9FvcZDjqqePTZJUPoPiVEV2dA6aF6g3OF3Z2OfNyc//IRJm/953/FedykToer
         5gWKuk+Ni/GVWr0G7QrLpqY0V4YinZ3WPo6rAwips8bbdul/gEQACkNLj809186DOo
         HjfZd49GKM6eWvPi+albgUeFEZ0v3eqiwiEsp2NI=
Subject: patch "staging: rtl8712: Fix possible buffer overflow in" added to staging-linus
To:     leegib@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:22:43 +0100
Message-ID: <1614694963231197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8712: Fix possible buffer overflow in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From def9c897e73e89780c7f13a81aef60db2bdeaddc Mon Sep 17 00:00:00 2001
From: Lee Gibson <leegib@gmail.com>
Date: Mon, 1 Mar 2021 13:26:48 +0000
Subject: staging: rtl8712: Fix possible buffer overflow in
 r8712_sitesurvey_cmd

Function r8712_sitesurvey_cmd calls memcpy without checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
Link: https://lore.kernel.org/r/20210301132648.420296-1-leegib@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/rtl871x_cmd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 18116469bd31..75716f59044d 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -192,8 +192,10 @@ u8 r8712_sitesurvey_cmd(struct _adapter *padapter,
 	psurveyPara->ss_ssidlen = 0;
 	memset(psurveyPara->ss_ssid, 0, IW_ESSID_MAX_SIZE + 1);
 	if (pssid && pssid->SsidLength) {
-		memcpy(psurveyPara->ss_ssid, pssid->Ssid, pssid->SsidLength);
-		psurveyPara->ss_ssidlen = cpu_to_le32(pssid->SsidLength);
+		int len = min_t(int, pssid->SsidLength, IW_ESSID_MAX_SIZE);
+
+		memcpy(psurveyPara->ss_ssid, pssid->Ssid, len);
+		psurveyPara->ss_ssidlen = cpu_to_le32(len);
 	}
 	set_fwstate(pmlmepriv, _FW_UNDER_SURVEY);
 	r8712_enqueue_cmd(pcmdpriv, ph2c);
-- 
2.30.1


