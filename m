Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3480F3EB867
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242068AbhHMPN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242065AbhHMPMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:12:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1702610FD;
        Fri, 13 Aug 2021 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867524;
        bh=3pGuDehnOm3XJKIgmjQwi8OStqgpGiZhe0UQFjHlV2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JR5LcBalFMDNie3Jp7Gn/pFkSog3wc2wsI3IaLc3Jx/gipS4V5g3IRHE+BQKAhcGs
         X/s+3cDtp/0YnjeM9n/CQEg5y8pdVYgIERcKu2pesjrogP68TcoI2Hm5+SAd8osqg7
         Uipup4FCghCYyqDmgb3/65cpgXk4ilsggozWvMdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Xiangyang Zhang <xyz.sun.ok@gmail.com>
Subject: [PATCH 4.14 24/42] staging: rtl8723bs: Fix a resource leak in sd_int_dpc
Date:   Fri, 13 Aug 2021 17:06:50 +0200
Message-Id: <20210813150525.915159062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
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
@@ -1118,6 +1118,8 @@ void sd_int_dpc(struct adapter *padapter
 				} else {
 					rtw_c2h_wk_cmd(padapter, (u8 *)c2h_evt);
 				}
+			} else {
+				kfree(c2h_evt);
 			}
 		} else {
 			/* Error handling for malloc fail */


