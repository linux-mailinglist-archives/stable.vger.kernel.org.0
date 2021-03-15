Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8358133BA45
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhCOOIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234173AbhCOODB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4978D64E83;
        Mon, 15 Mar 2021 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816981;
        bh=t5BnTS850+jKKLw5mVittI7sbVkHlpa1WiKqMPxCEdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AApodd06/DHAKcKfnYH/mll32/s4Aj+63p86b4OC+1iF5UGKHParXh4jAW67ljPYB
         HQqAZeb2XS91f7HMdKLMc2ObpyxM4A7UKgSfC6e8utkrgT30ZRM/YhfK5Y1e8jIO4l
         4MS2PINLhK/oHbZ55HuN+9HmEARS7dmEt/wszAlc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 226/290] staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()
Date:   Mon, 15 Mar 2021 14:55:19 +0100
Message-Id: <20210315135549.618983186@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 74b6b20df8cfe90ada777d621b54c32e69e27cd7 upstream.

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->ssid[] array.

Fixes: a2c60d42d97c ("staging: r8188eu: Add files for new driver - part 16")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YEHymwsnHewzoam7@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1144,9 +1144,11 @@ static int rtw_wx_set_scan(struct net_de
 						break;
 					}
 					sec_len = *(pos++); len -= 1;
-					if (sec_len > 0 && sec_len <= len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].ssid_length = sec_len;
-						memcpy(ssid[ssid_index].ssid, pos, ssid[ssid_index].ssid_length);
+						memcpy(ssid[ssid_index].ssid, pos, sec_len);
 						ssid_index++;
 					}
 					pos += sec_len;


