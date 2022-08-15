Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631AD594178
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbiHOUwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346862AbiHOUvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0127BB6AE;
        Mon, 15 Aug 2022 12:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B12B810C6;
        Mon, 15 Aug 2022 19:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80B9C433D6;
        Mon, 15 Aug 2022 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590589;
        bh=aDKi8r+Ka7824Zy81hOI8/sqQakOv5cZuDn04XHuXOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WB9AR4wtNO7+mYKngDfiDsr4zAEUhcID7ekWyS5qSNoOARuAFUdSh1Nznpqq8sfks
         LmoMROw4kznseLlSf6r9cnRhF8CKFvH1ydS+by5mNe2oWgCIuQVDKB3SqGDBR5Jhtp
         QsORMPTqKS7sm5svIDX1RdZQ5EELDSQGrAtSp68o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        David Lechner <david@lechnology.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0308/1095] drm/st7735r: Fix module autoloading for Okaya RH128128T
Date:   Mon, 15 Aug 2022 19:55:07 +0200
Message-Id: <20220815180442.547058193@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 29d618093e94..e0f02d367d88 100644
--- a/drivers/gpu/drm/tiny/st7735r.c
+++ b/drivers/gpu/drm/tiny/st7735r.c
@@ -174,6 +174,7 @@ MODULE_DEVICE_TABLE(of, st7735r_of_match);
 
 static const struct spi_device_id st7735r_id[] = {
 	{ "jd-t18003-t01", (uintptr_t)&jd_t18003_t01_cfg },
+	{ "rh128128t", (uintptr_t)&rh128128t_cfg },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, st7735r_id);
-- 
2.35.1



