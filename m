Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F4E33B963
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhCOOCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232938AbhCOOAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CFC264EF3;
        Mon, 15 Mar 2021 13:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816799;
        bh=UX9f+NV9wDx9Q7CmnQqT1xrjNeuvz9LnWyiBmFrWdwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x54ZW6GHZGaQJ9kQ2LaOJzWj3lOdrDBHPD+qslokmMG10prhW2Bfij3O5EbFpTW0f
         K+lM3i5OzQRa6dnCBcLW5XKW/nfoQeb4W0cjx/Ervd8D/1ZOerhvjayn58Te9811+0
         w0kiLeaypMhaXIOPCVbHCHlmqxCzAfoi9d10DNWo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Gibson <leegib@gmail.com>
Subject: [PATCH 4.14 70/95] staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd
Date:   Mon, 15 Mar 2021 14:57:40 +0100
Message-Id: <20210315135742.569582656@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Lee Gibson <leegib@gmail.com>

commit b93c1e3981af19527beee1c10a2bef67a228c48c upstream.

Function r8712_sitesurvey_cmd calls memcpy without checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
Link: https://lore.kernel.org/r/20210301132648.420296-1-leegib@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/rtl871x_cmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -242,8 +242,10 @@ u8 r8712_sitesurvey_cmd(struct _adapter
 	psurveyPara->ss_ssidlen = 0;
 	memset(psurveyPara->ss_ssid, 0, IW_ESSID_MAX_SIZE + 1);
 	if ((pssid != NULL) && (pssid->SsidLength)) {
-		memcpy(psurveyPara->ss_ssid, pssid->Ssid, pssid->SsidLength);
-		psurveyPara->ss_ssidlen = cpu_to_le32(pssid->SsidLength);
+		int len = min_t(int, pssid->SsidLength, IW_ESSID_MAX_SIZE);
+
+		memcpy(psurveyPara->ss_ssid, pssid->Ssid, len);
+		psurveyPara->ss_ssidlen = cpu_to_le32(len);
 	}
 	set_fwstate(pmlmepriv, _FW_UNDER_SURVEY);
 	r8712_enqueue_cmd(pcmdpriv, ph2c);


