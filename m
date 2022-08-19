Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3288B59A1EA
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351069AbiHSQDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351462AbiHSQBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D0F108F1D;
        Fri, 19 Aug 2022 08:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6C54B82814;
        Fri, 19 Aug 2022 15:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3051AC433C1;
        Fri, 19 Aug 2022 15:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924404;
        bh=1tBHeFIEQC/xbFFgNO0fwdZJn6eyhjD4eBeuyYuriOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8tQgp7ztz7NXFdeT4bJpYznqNQdWkJ6DkxcHAK333Pm+ZB8Hm8EQnkMDa62sdy6l
         LXt6+wdoqk3Gl8hCgcid61KoWaUhrW7045eqLkQfWArncB4q0DqJWK00BVjZOW9S2w
         4uBDheYuqO8tQM1SWUvNlGeRadkz7Pc+wp9h9X3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        David Lechner <david@lechnology.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/545] drm/st7735r: Fix module autoloading for Okaya RH128128T
Date:   Fri, 19 Aug 2022 17:38:50 +0200
Message-Id: <20220819153836.520320999@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 9ad6f181ad9a19a26bda73a7b199df44ccfcdaba ]

The SPI core always reports a "MODALIAS=spi:<foo>", even if the device was
registered via OF. This means that the st7735r.ko module won't autoload if
a DT has a node with a compatible "okaya,rh128128t" string.

In that case, kmod expects a "MODALIAS=of:N*T*Cokaya,rh128128t" uevent but
instead will get a "MODALIAS=spi:rh128128t", which is not present in the
list of aliases:

  $ modinfo drivers/gpu/drm/tiny/st7735r.ko | grep alias
  alias:          of:N*T*Cokaya,rh128128tC*
  alias:          of:N*T*Cokaya,rh128128t
  alias:          of:N*T*Cjianda,jd-t18003-t01C*
  alias:          of:N*T*Cjianda,jd-t18003-t01
  alias:          spi:jd-t18003-t01

To workaround this issue, add in the SPI table an entry for that device.

Fixes: d1d511d516f7 ("drm: tiny: st7735r: Add support for Okaya RH128128T")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: David Lechner <david@lechnology.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220520091602.179078-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/st7735r.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tiny/st7735r.c b/drivers/gpu/drm/tiny/st7735r.c
index c0bc2a18edde..9d0c127bdb0c 100644
--- a/drivers/gpu/drm/tiny/st7735r.c
+++ b/drivers/gpu/drm/tiny/st7735r.c
@@ -175,6 +175,7 @@ MODULE_DEVICE_TABLE(of, st7735r_of_match);
 
 static const struct spi_device_id st7735r_id[] = {
 	{ "jd-t18003-t01", (uintptr_t)&jd_t18003_t01_cfg },
+	{ "rh128128t", (uintptr_t)&rh128128t_cfg },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, st7735r_id);
-- 
2.35.1



