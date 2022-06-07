Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA333541B28
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381001AbiFGVmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381283AbiFGVkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C101826558;
        Tue,  7 Jun 2022 12:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B30D617DA;
        Tue,  7 Jun 2022 19:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC3CC385A2;
        Tue,  7 Jun 2022 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628766;
        bh=q41phyPIPeloQ6si3/G89TZ9tn96bErSYBQJUnEKDZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEI4SX8gci3zKW/N8O+UpsengUMnExeiuCLCtLKv1fYh1uq3q6V1BTOOsopQipeFt
         1Z4Czv6PD1Y0tHcb7YO9nNRnjQCUERUEMSR+Z9RtBVfMx9ZP8Jy7I7Jx3b7CKJrnY3
         0QcOtD42VBESDxX2qDvQpt0HbcTOkPopet5FKygM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 447/879] media: make RADIO_ADAPTERS tristate
Date:   Tue,  7 Jun 2022 18:59:25 +0200
Message-Id: <20220607165015.845592042@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 215d49a41709610b9e82a49b27269cfaff1ef0b6 ]

Fix build errors when RADIO_TEA575X=y, VIDEO_BT848=m, and VIDEO_DEV=m.

The build errors occur due to [in drivers/media/Makefile]:
obj-$(CONFIG_VIDEO_DEV) += radio/
so the (would be) builtin tea575x.o is not being built.

This is also due to drivers/media/radio/Kconfig declaring a bool
Kconfig symbol (RADIO_ADAPTERS) that depends on a tristate (VIDEO_DEV),
so when VIDEO_DEV=m, RADIO_ADAPTERS becomes =y, and then the drivers
that depend on RADIO_ADPATERS can be configured as builtin (=y) or
as loadable modules (=m).

Fix this by converting RADIO_ADAPTERS to a tristate symbol instead
of a bool symbol.

Fixes these build errors:

ERROR: modpost: "snd_tea575x_hw_init" [drivers/media/pci/bt8xx/bttv.ko] undefined!
ERROR: modpost: "snd_tea575x_set_freq" [drivers/media/pci/bt8xx/bttv.ko] undefined!
ERROR: modpost: "snd_tea575x_s_hw_freq_seek" [drivers/media/pci/bt8xx/bttv.ko] undefined!
ERROR: modpost: "snd_tea575x_enum_freq_bands" [drivers/media/pci/bt8xx/bttv.ko] undefined!
ERROR: modpost: "snd_tea575x_g_tuner" [drivers/media/pci/bt8xx/bttv.ko] undefined!

Link: lore.kernel.org/r/202204191711.IKJJFjgU-lkp@intel.com

Fixes: 9958d30f38b9 ("media: Kconfig: cleanup VIDEO_DEV dependencies")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index cca03bd2cc42..616a38feb641 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -4,10 +4,10 @@
 #
 
 menuconfig RADIO_ADAPTERS
-	bool "Radio Adapters"
+	tristate "Radio Adapters"
 	depends on VIDEO_DEV
 	depends on MEDIA_RADIO_SUPPORT
-	default y
+	default VIDEO_DEV
 	help
 	  Say Y here to enable selecting AM/FM radio adapters.
 
-- 
2.35.1



