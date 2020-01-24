Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8800E147B0A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgAXJj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbgAXJj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:58 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1E620709;
        Fri, 24 Jan 2020 09:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858797;
        bh=g01oey4yaSdr4gHsShStOXO47xlC6uMGH7eH5eylq98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wce1qRt5piE1g86EWTrqql738Zd8DAoi44lKi+iA3s3mKkRAytF7bbmIpAevJQx5r
         p2BwFtfGLrmHHikt3asxUgNGPMYGfrlsw/YkWyhJ6OxK76sw0lOGfpxH1dFi12DwHq
         zcbVcD1eoKmpOfpkNn2K5Im9ANnixgu8RIp9o/mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 050/102] rtw88: fix error handling when setup efuse info
Date:   Fri, 24 Jan 2020 10:30:51 +0100
Message-Id: <20200124092813.864213226@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

commit f4268729eb1eefe23f6746849c1b5626d9030532 upstream.

Disable efuse if the efuse is enabled when we failed to setup the efuse
information, otherwise the hardware will not turn off.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtw88/main.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1048,19 +1048,19 @@ static int rtw_chip_efuse_info_setup(str
 	/* power on mac to read efuse */
 	ret = rtw_chip_efuse_enable(rtwdev);
 	if (ret)
-		goto out;
+		goto out_unlock;
 
 	ret = rtw_parse_efuse_map(rtwdev);
 	if (ret)
-		goto out;
+		goto out_disable;
 
 	ret = rtw_dump_hw_feature(rtwdev);
 	if (ret)
-		goto out;
+		goto out_disable;
 
 	ret = rtw_check_supported_rfe(rtwdev);
 	if (ret)
-		goto out;
+		goto out_disable;
 
 	if (efuse->crystal_cap == 0xff)
 		efuse->crystal_cap = 0;
@@ -1087,9 +1087,10 @@ static int rtw_chip_efuse_info_setup(str
 	efuse->ext_pa_5g = efuse->pa_type_5g & BIT(0) ? 1 : 0;
 	efuse->ext_lna_2g = efuse->lna_type_5g & BIT(3) ? 1 : 0;
 
+out_disable:
 	rtw_chip_efuse_disable(rtwdev);
 
-out:
+out_unlock:
 	mutex_unlock(&rtwdev->mutex);
 	return ret;
 }


