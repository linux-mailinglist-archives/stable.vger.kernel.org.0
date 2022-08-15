Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215715944FD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350650AbiHOWsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351978AbiHOWr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C2A7CA99;
        Mon, 15 Aug 2022 12:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEC3D6122B;
        Mon, 15 Aug 2022 19:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAAFC43140;
        Mon, 15 Aug 2022 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593190;
        bh=UkexD9rfgmwaolcR9QQUHVrlFEriZt7CFdO7HMCyRRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/cWFyzIb1MB447S3abr/n3ZlQvoXCGsYUljIcwd8uZUp7G9xY65wrEJJ11SL5D77
         FMy5iSgwCZHXb6bC2p3sFypJiYy+9LAOEx3R7oJVk/xT1CaGDT3yCS8Qt28xBjy0r3
         bKqK+Y1UutYJdpzzsDPavJAb1r3CO7z3mPM+7Afo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Terry Bowman <terry.bowman@amd.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0909/1095] watchdog: sp5100_tco: Fix a memory leak of EFCH MMIO resource
Date:   Mon, 15 Aug 2022 20:05:08 +0200
Message-Id: <20220815180506.896913248@linuxfoundation.org>
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

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit c6d9c0798ed366a09a9e53d71edcd2266e34a6eb ]

Unlike release_mem_region(), a call to release_resource() does not
free the resource, so it has to be freed explicitly to avoid a memory
leak.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 0578fff4aae5 ("Watchdog: sp5100_tco: Add initialization using EFCH MMIO")
Cc: Terry Bowman <terry.bowman@amd.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220621152840.420a0f4c@endymion.delvare
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sp5100_tco.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 86ffb58fbc85..ae54dd33e233 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -402,6 +402,7 @@ static int sp5100_tco_setupdevice_mmio(struct device *dev,
 		iounmap(addr);
 
 	release_resource(res);
+	kfree(res);
 
 	return ret;
 }
-- 
2.35.1



