Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502EE5AEADD
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiIFNuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiIFNt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30E3DF58;
        Tue,  6 Sep 2022 06:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D01C9B818D6;
        Tue,  6 Sep 2022 13:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FA9C433B5;
        Tue,  6 Sep 2022 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471552;
        bh=jbIoN1M1QMAVfRj6osU18qOxo+Oja85/EIutg+DQAjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sO06zojBO2BMIA5rWZjzV44Zn+ho6vYDPMeBl+FwBX2lfjQXsXz05wVTKb/0Xunk
         68EN6THEVR1VtIUc3Ee8UvXWibUwzS9uZ/dY+n5h7dGHg4DnxGGblbEk+jK8+1kyTL
         KMHGdXHxk1PQ/mPyPuza3B0vKMp3ZxdloI0kEnFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Grzegorz Szymaszek <gszymaszek@short.pl>,
        Phillip Potter <phil@philpotter.co.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5.15 033/107] staging: r8188eu: add firmware dependency
Date:   Tue,  6 Sep 2022 15:30:14 +0200
Message-Id: <20220906132823.198257412@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Grzegorz Szymaszek <gszymaszek@short.pl>

commit b2fa9e13bbf101c662c4cd974608242a0db98cfc upstream.

The old rtl8188eu module, removed in commit 55dfa29b43d2 ("staging:
rtl8188eu: remove rtl8188eu driver from staging dir") (Linux kernel
v5.15-rc1), required (through a MODULE_FIRMWARE call()) the
rtlwifi/rtl8188eufw.bin firmware file, which the new r8188eu driver no
longer requires.

I have tested a few RTL8188EUS-based Wi-Fi cards and, while supported by
both drivers, they do not work when using the new one and the firmware
wasn't manually loaded. According to Larry Finger, the module
maintainer, all such cards need the firmware and the driver should
depend on it (see the linked mails).

Add a proper MODULE_FIRMWARE() call, like it was done in the old driver.

Thanks to Greg Kroah-Hartman and Larry Finger for quick responses to my
questions.

Cc: stable <stable@kernel.org>
Link: https://answers.launchpad.net/ubuntu/+source/linux-meta-hwe-5.15/+question/702611
Link: https://lore.kernel.org/lkml/YukkBu3TNODO3or9@nx64de-df6d00/
Signed-off-by: Grzegorz Szymaszek <gszymaszek@short.pl>
Link: https://lore.kernel.org/r/YulcdKfhA8dPQ78s@nx64de-df6d00
Acked-by: Phillip Potter <phil@philpotter.co.uk>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/os_intfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/r8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/r8188eu/os_dep/os_intfs.c
@@ -17,6 +17,7 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
 MODULE_AUTHOR("Realtek Semiconductor Corp.");
 MODULE_VERSION(DRIVERVERSION);
+MODULE_FIRMWARE("rtlwifi/rtl8188eufw.bin");
 
 #define CONFIG_BR_EXT_BRNAME "br0"
 #define RTW_NOTCH_FILTER 0 /* 0:Disable, 1:Enable, */


