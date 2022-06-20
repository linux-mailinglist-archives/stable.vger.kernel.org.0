Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA41551A22
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbiFTM5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243272AbiFTM51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:57:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB1A1AD80;
        Mon, 20 Jun 2022 05:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15756B811A3;
        Mon, 20 Jun 2022 12:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A853C3411B;
        Mon, 20 Jun 2022 12:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729719;
        bh=ZNITDWnOHqy+yw+B4Q7xomhpdap+YNYWvyjpMY0ed+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcKgwUDt8DQ3wiX7lUOVfmeLXfx511V60ELivP5Kitb/UAjmgIuOpFNvT4gDjApna
         /DlcxMLv/vtiAy3t6c4paRXzSvil6lA7IRIFHas00KZnVIocEqLHgYIymR8QnD+k1t
         BAf8qjwnaRbagvq+2cGQEL2U1Ba7160vg+ctqs/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 053/141] staging: r8188eu: Fix warning of array overflow in ioctl_linux.c
Date:   Mon, 20 Jun 2022 14:49:51 +0200
Message-Id: <20220620124731.104290428@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 96f0a54e8e65a765b3a4ad4b53751581f23279f3 ]

Building with -Warray-bounds results in the following warning plus others
related to the same problem:

CC [M]  drivers/staging/r8188eu/os_dep/ioctl_linux.o
In function ‘wpa_set_encryption’,
    inlined from ‘rtw_wx_set_enc_ext’ at drivers/staging/r8188eu/os_dep/ioctl_linux.c:1868:9:
drivers/staging/r8188eu/os_dep/ioctl_linux.c:412:41: warning: array subscript ‘struct ndis_802_11_wep[0]’ is partly outside array bounds of ‘void[25]’ [-Warray-bounds]
  412 |                         pwep->KeyLength = wep_key_len;
      |                         ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
In file included from drivers/staging/r8188eu/os_dep/../include/osdep_service.h:19,
                 from drivers/staging/r8188eu/os_dep/ioctl_linux.c:4:
In function ‘kmalloc’,
    inlined from ‘kzalloc’ at ./include/linux/slab.h:733:9,
    inlined from ‘wpa_set_encryption’ at drivers/staging/r8188eu/os_dep/ioctl_linux.c:408:11,
    inlined from ‘rtw_wx_set_enc_ext’ at drivers/staging/r8188eu/os_dep/ioctl_linux.c:1868:9:
./include/linux/slab.h:605:16: note: object of size [17, 25] allocated by ‘__kmalloc’
  605 |         return __kmalloc(size, flags);
      |                ^~~~~~~~~~~~~~~~~~~~~~
./include/linux/slab.h:600:24: note: object of size [17, 25] allocated by ‘kmem_cache_alloc_trace’
  600 |                 return kmem_cache_alloc_trace(
      |                        ^~~~~~~~~~~~~~~~~~~~~~~
  601 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  602 |                                 flags, size);
      |                                 ~~~~~~~~~~~~

Although it is unlikely that anyone is still using WEP encryption, the
size of the allocation needs to be increased just in case.

Fixes commit 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220531013103.2175-3-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index 60bd1cc2b3af..607c5e1eb320 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -404,7 +404,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, KeyMaterial);
+			wep_total_len = wep_key_len + sizeof(*pwep);
 			pwep = kzalloc(wep_total_len, GFP_KERNEL);
 			if (!pwep)
 				goto exit;
-- 
2.35.1



