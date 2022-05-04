Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E171451A98F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355816AbiEDRSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356445AbiEDRNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712444C7AC;
        Wed,  4 May 2022 09:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51DE161794;
        Wed,  4 May 2022 16:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E2EC385A4;
        Wed,  4 May 2022 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683480;
        bh=T65hD3lkedDqHQ8Jk1haw7M3WC4ltemQG+9Pml3DHDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjWOo3IZpltVESaWGEriZ7J7AQGXd/X4CbWiU7EnM4df1rqiHb23Vtxkhw/ThiJUr
         7WOQFgVWyPoOtDVDkwh4y11ZdEbvqH7F3Q9zBG+f53m6UUYmm/1GqC4W2yQ6WtNIoa
         YrA1SwmmVj/JgVfiEHjBxgtVHXr7KQ/60fwotzjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 142/225] platform/x86: asus-wmi: Fix driver not binding when fan curve control probe fails
Date:   Wed,  4 May 2022 18:46:20 +0200
Message-Id: <20220504153122.887393189@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9fe1bb29ea0ab231aa916dad4bcf0c435beb5869 ]

Before this commit fan_curve_check_present() was trying to not cause
the probe to fail on devices without fan curve control by testing for
known error codes returned by asus_wmi_evaluate_method_buf().

Checking for ENODATA or ENODEV, with the latter being returned by this
function when an ACPI integer with a value of ASUS_WMI_UNSUPPORTED_METHOD
is returned. But for other ACPI integer returns this function just returns
them as is, including the ASUS_WMI_DSTS_UNKNOWN_BIT value of 2.

On the Asus U36SD ASUS_WMI_DSTS_UNKNOWN_BIT gets returned, leading to:

  asus-nb-wmi: probe of asus-nb-wmi failed with error 2

Instead of playing whack a mole with error codes here, simply treat all
errors as there not being any fan curves, fixing the driver no longer
loading on the Asus U36SD laptop.

Fixes: e3d13da7f77d ("platform/x86: asus-wmi: Fix regression when probing for fan curve control")
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=2079125
Cc: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220427114956.332919-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 399a4a345224..1e7bc0c595c7 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2227,9 +2227,10 @@ static int fan_curve_check_present(struct asus_wmi *asus, bool *available,
 
 	err = fan_curve_get_factory_default(asus, fan_dev);
 	if (err) {
-		if (err == -ENODEV || err == -ENODATA)
-			return 0;
-		return err;
+		pr_debug("fan_curve_get_factory_default(0x%08x) failed: %d\n",
+			 fan_dev, err);
+		/* Don't cause probe to fail on devices without fan-curves */
+		return 0;
 	}
 
 	*available = true;
-- 
2.35.1



