Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364BF3E7F73
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhHJRkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhHJRjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFEA6113D;
        Tue, 10 Aug 2021 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617007;
        bh=uPJHPIMaAQHhqYTIRhSwl3OZrLSgpFsc9imL+CpRXl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2a/SKFtFZFmCaio0j2dHZ/p4ldPwerb/Rq4BTjYjwaGTe4FbzOqWrl8o5aoogzIhW
         LQpPnttSUy1HXVvkpe5Llrs31BNH5l5DQufHQZpbGtC2+OoERBDH9hM6jKIwU4m6tM
         SnjMmtH9LQq5Ai/kdmhKzCCNftGIABhQjceDgc90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Xiangyang Zhang <xyz.sun.ok@gmail.com>
Subject: [PATCH 5.4 56/85] staging: rtl8723bs: Fix a resource leak in sd_int_dpc
Date:   Tue, 10 Aug 2021 19:30:29 +0200
Message-Id: <20210810172950.132127247@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiangyang Zhang <xyz.sun.ok@gmail.com>

commit 990e4ad3ddcb72216caeddd6e62c5f45a21e8121 upstream.

The "c2h_evt" variable is not freed when function call
"c2h_evt_read_88xx" failed

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210628152239.5475-1-xyz.sun.ok@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/hal/sdio_ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -1033,6 +1033,8 @@ void sd_int_dpc(struct adapter *adapter)
 				} else {
 					rtw_c2h_wk_cmd(adapter, (u8 *)c2h_evt);
 				}
+			} else {
+				kfree(c2h_evt);
 			}
 		} else {
 			/* Error handling for malloc fail */


