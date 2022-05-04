Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA10B51A911
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbiEDRRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355792AbiEDRIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B551E73;
        Wed,  4 May 2022 09:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4B961851;
        Wed,  4 May 2022 16:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977CFC385A4;
        Wed,  4 May 2022 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683274;
        bh=y1D8LeGMgAJ4kn6HvDYXfJHSZWVRSoy07IEQjK7OxQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OH+1C1qVje9NlIWUCtWCDENIq2U7rZeG/OkUXVEiIMC9vkH/4B5IQM2l5fC4oRW79
         7A3HnhkD+BuIhhmlkYyR+MEsxyGbUWAMfkyPOcPHPpE39hXmX5nhZ6IHkhB+UrR7UY
         RFBknQ9KI8AeSFydQ156ZJQcqPcOgLtpEl0hTaX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Woody Suwalski <wsuwalski@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 140/177] Revert "ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40"
Date:   Wed,  4 May 2022 18:45:33 +0200
Message-Id: <20220504153105.772291535@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 20e582e16af24b074e583f9551fad557882a3c9d upstream.

This reverts commit bfe55a1f7fd6bfede16078bf04c6250fbca11588.

This was presumably misdiagnosed as an inability to use C3 at
all when I suspect the real problem is just misconfiguration of
C3 vs. ARB_DIS.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Tested-by: Woody Suwalski <wsuwalski@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -95,11 +95,6 @@ static const struct dmi_system_id proces
 	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
 	 (void *)1},
-	/* T40 can not handle C3 idle state */
-	{ set_max_cstate, "IBM ThinkPad T40", {
-	  DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "23737CU")},
-	 (void *)2},
 	{},
 };
 


