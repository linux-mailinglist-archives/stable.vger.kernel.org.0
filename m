Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395E759D854
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349775AbiHWJbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350527AbiHWJaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC37923F0;
        Tue, 23 Aug 2022 01:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA39B81C35;
        Tue, 23 Aug 2022 08:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01561C433C1;
        Tue, 23 Aug 2022 08:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243804;
        bh=vWwA4f4O0Bfos50TDwGtYO/p5gav7IBXlJJI5sEDmao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWL4YHd35MhrYi0OnY8k53WozE7iVZ1XwCQV5fYF50Uu7zpsWho4QpAtPTqePXz/g
         Thgdivg/y5qEY6yPjvbHPr0HchTlmeG9Xtq+kYcXclr0W8AxNgVEeeFWLofkFVpLej
         uNS+komgNRVumxZ+EclChohyq4KdFLxoI+jSO+cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 026/229] parisc: Fix device names in /proc/iomem
Date:   Tue, 23 Aug 2022 10:23:07 +0200
Message-Id: <20220823080054.396142524@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
@@ -505,7 +505,6 @@ alloc_pa_dev(unsigned long hpa, struct h
 	dev->id.hversion_rev = iodc_data[1] & 0x0f;
 	dev->id.sversion = ((iodc_data[4] & 0x0f) << 16) |
 			(iodc_data[5] << 8) | iodc_data[6];
-	dev->hpa.name = parisc_pathname(dev);
 	dev->hpa.start = hpa;
 	/* This is awkward.  The STI spec says that gfx devices may occupy
 	 * 32MB or 64MB.  Unfortunately, we don't know how to tell whether
@@ -519,10 +518,10 @@ alloc_pa_dev(unsigned long hpa, struct h
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


