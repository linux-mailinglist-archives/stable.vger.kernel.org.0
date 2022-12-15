Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57A064E074
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLOSOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiLOSNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:13:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6106A4A07C
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:13:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A89F2B81C3A
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07525C433EF;
        Thu, 15 Dec 2022 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671128001;
        bh=sCd/RpVzTHWfscuq/JRkDn0LnaDIzYEJDSh6sNXPh1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VOh48YTG3ocGZMOXQqvqy/jSDaq1+dn+0ELcu4rm/BNscgkbt2UNKZSRgYcXqiau
         WovMTqPe2RA5ZCm1mCCCINpzjA7YbzmSw3h+58wru5gAaIy9OfbrSeymKEVNWUAZIT
         EGJ+QMwrVEQ5VziuZgKnIcQUfk4kIecjJ4mBgAf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.0 05/16] rtc: cmos: fix build on non-ACPI platforms
Date:   Thu, 15 Dec 2022 19:10:49 +0100
Message-Id: <20221215172908.379253879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit db4e955ae333567dea02822624106c0b96a2f84f upstream.

Now that rtc_wake_setup is called outside of cmos_wake_setup, it also need
to be defined on non-ACPI platforms.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20221018203512.2532407-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1346,6 +1346,9 @@ static void cmos_check_acpi_rtc_status(s
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP


