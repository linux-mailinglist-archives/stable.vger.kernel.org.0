Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C352553C12
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 22:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354572AbiFUUyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355539AbiFUUyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8BD3135E;
        Tue, 21 Jun 2022 13:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA65A6183B;
        Tue, 21 Jun 2022 20:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98021C3411C;
        Tue, 21 Jun 2022 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844580;
        bh=3PjshUGZxQk6YNxZZzX8HOQM3GtVU4b/kpi+bYMZqLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERZHEjzaHhxfzsIaC3UKyRHLWneYx8aqYljMw86xjs9f6m13caBtDIlNce2MMTtkL
         TnduaaajOd7sIA+pg3P4fEurIE+/koXkb7+N7WZ0b+AFGi6H6px3BFEV2EqEjUpvvx
         NA1xTpixnLcyqzL0ehfU1TJiEAy6HSZoqPhzgL2u1gcljRTBKTQ2UZ5kRMP9hgLb/w
         AAfKqVWujNSAeHAicSK0fNctlkayEfNZ/4zPata8zG3sMGJj4duin3ar44Gn3MUBW/
         ecY5+rqhKzuPSJpMrQGy4VNHNqZ1fEfgYtEp5v2OkpQ/0oID4R5snBlsEihmzMIFb1
         TZluFN2FJthdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-staging@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
        straube.linux@gmail.com, arnd@arndb.de
Subject: [PATCH AUTOSEL 5.18 03/22] staging: rtl8723bs: Allocate full pwep structure
Date:   Tue, 21 Jun 2022 16:49:09 -0400
Message-Id: <20220621204928.249907-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 67ea0a2adbf667cd6da4965fbcfd0da741035084 ]

The pwep allocation was always being allocated smaller than the true
structure size. Avoid this by always allocating the full structure.
Found with GCC 12 and -Warray-bounds:

../drivers/staging/rtl8723bs/os_dep/ioctl_linux.c: In function 'rtw_set_encryption':
../drivers/staging/rtl8723bs/os_dep/ioctl_linux.c:591:29: warning: array subscript 'struct ndis_802_11_wep[0]' is partly outside array bounds of 'void[25]' [-Warray-bounds]
  591 |                         pwep->length = wep_total_len;
      |                             ^~

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fabio Aiuto <fabioaiuto83@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: linux-staging@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220608215512.1070847-1-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index ece97e37ac91..30374a820496 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -90,7 +90,8 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);
-			pwep = kzalloc(wep_total_len, GFP_KERNEL);
+			/* Allocate a full structure to avoid potentially running off the end. */
+			pwep = kzalloc(sizeof(*pwep), GFP_KERNEL);
 			if (!pwep) {
 				ret = -ENOMEM;
 				goto exit;
@@ -582,7 +583,8 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);
-			pwep = kzalloc(wep_total_len, GFP_KERNEL);
+			/* Allocate a full structure to avoid potentially running off the end. */
+			pwep = kzalloc(sizeof(*pwep), GFP_KERNEL);
 			if (!pwep)
 				goto exit;
 
-- 
2.35.1

