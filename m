Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A431F6044E9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiJSMSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiJSMRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3B117425;
        Wed, 19 Oct 2022 04:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0C47B8246B;
        Wed, 19 Oct 2022 09:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174DAC433C1;
        Wed, 19 Oct 2022 09:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170172;
        bh=aRoHgLT18h88Rn43em+coJfcbxqhuSaOBcPrfYQ//0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQNu23nuUfbrsSUPFuhHAJQNdhPAj76eIFhtPmkb5WLGv7kKAJ1kqkHarW829DXCZ
         zowfUp40Zw92NskT2Oxpdh9wU7ZXe2HauupsozmnLsiQKdrKsMXXJIzfMsQntdmmkm
         cBW15+dm4rxpoHVCLybmBjPWhHDzCEM/f2KPdjNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Artem S. Tashkinov" <aros@gmx.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 553/862] xhci: Dont show warning for reinit on known broken suspend
Date:   Wed, 19 Oct 2022 10:30:40 +0200
Message-Id: <20221019083314.412569380@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 484d6f7aa3283d082c87654b7fe7a7f725423dfb ]

commit 8b328f8002bc ("xhci: re-initialize the HC during resume if HCE was
set") introduced a new warning message when the host controller error
was set and re-initializing.

This is expected behavior on some designs which already set
`xhci->broken_suspend` so the new warning is alarming to some users.

Modify the code to only show the warning if this was a surprising behavior
to the XHCI driver.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216470
Fixes: 8b328f8002bc ("xhci: re-initialize the HC during resume if HCE was set")
Reported-by: Artem S. Tashkinov <aros@gmx.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220921123450.671459-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 38649284ff88..a7ef675f00fd 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1183,7 +1183,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	/* re-initialize the HC on Restore Error, or Host Controller Error */
 	if (temp & (STS_SRE | STS_HCE)) {
 		reinit_xhc = true;
-		xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+		if (!xhci->broken_suspend)
+			xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
 	}
 
 	if (reinit_xhc) {
-- 
2.35.1



