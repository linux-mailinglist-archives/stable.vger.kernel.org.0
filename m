Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207D960B771
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiJXTYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiJXTXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:23:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B508B4F662;
        Mon, 24 Oct 2022 10:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09A75CE16C3;
        Mon, 24 Oct 2022 12:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26122C433C1;
        Mon, 24 Oct 2022 12:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615628;
        bh=m6At7l19ztXJBe8+Gs6Cv+XbDSWUNIKG+Bz9ku+n7nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pd6ABswv0fyxG6JdFmwhILTpb3y/IUFSJey9fUwHpEhw8hQWgjTTtBLb3huierRVs
         OlaR77Z05EqXf5WXbnzN5tXUvLlMl81UBQ3ri+2ZkKNrYk8QT/WYgFb4pl0Xw6NItd
         TrRJhJ1tXXwIjZm68EVFdsQlxHVXTgwzaxcP5FJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Artem S. Tashkinov" <aros@gmx.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/530] xhci: Dont show warning for reinit on known broken suspend
Date:   Mon, 24 Oct 2022 13:31:06 +0200
Message-Id: <20221024113059.611279557@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3cac7e40456e..8c7710698428 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1165,7 +1165,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
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



