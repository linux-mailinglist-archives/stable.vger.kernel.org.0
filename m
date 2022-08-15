Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C75594505
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbiHOWCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348684AbiHOWBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:01:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ADBAEDA1;
        Mon, 15 Aug 2022 12:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BDA06113B;
        Mon, 15 Aug 2022 19:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92945C433C1;
        Mon, 15 Aug 2022 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592132;
        bh=7M4uIosGCQ+JVXn5ixS/gPXhPLLzxgVy6nzH25ETjwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSeUHA5XEMkRfPwD/Z03uDeFEfb0tZcHw5mSHuiAyy8uYcZ68DMphwGrd2evma83m
         6eSpNO3mSjrBDFotn9ZFW7BZsOm1G+IPQQy/5rE6dOSD+sf7+BILma50anEG+e8THi
         TmTh8CCFjfMz0/c+6tskQi5G6ip+/G7OSFY0HkeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.19 0063/1157] parisc: Fix device names in /proc/iomem
Date:   Mon, 15 Aug 2022 19:50:19 +0200
Message-Id: <20220815180442.022281406@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit cab56b51ec0e69128909cef4650e1907248d821b upstream.

Fix the output of /proc/iomem to show the real hardware device name
including the pa_pathname, e.g. "Merlin 160 Core Centronics [8:16:0]".
Up to now only the pa_pathname ("[8:16.0]") was shown.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/drivers.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -520,7 +520,6 @@ alloc_pa_dev(unsigned long hpa, struct h
 	dev->id.hversion_rev = iodc_data[1] & 0x0f;
 	dev->id.sversion = ((iodc_data[4] & 0x0f) << 16) |
 			(iodc_data[5] << 8) | iodc_data[6];
-	dev->hpa.name = parisc_pathname(dev);
 	dev->hpa.start = hpa;
 	/* This is awkward.  The STI spec says that gfx devices may occupy
 	 * 32MB or 64MB.  Unfortunately, we don't know how to tell whether
@@ -534,10 +533,10 @@ alloc_pa_dev(unsigned long hpa, struct h
 		dev->hpa.end = hpa + 0xfff;
 	}
 	dev->hpa.flags = IORESOURCE_MEM;
-	name = parisc_hardware_description(&dev->id);
-	if (name) {
-		strlcpy(dev->name, name, sizeof(dev->name));
-	}
+	dev->hpa.name = dev->name;
+	name = parisc_hardware_description(&dev->id) ? : "unknown";
+	snprintf(dev->name, sizeof(dev->name), "%s [%s]",
+		name, parisc_pathname(dev));
 
 	/* Silently fail things like mouse ports which are subsumed within
 	 * the keyboard controller


