Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE428226522
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgGTPvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbgGTPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A38522064B;
        Mon, 20 Jul 2020 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260269;
        bh=n5GM2xtcQsiskfkd81xbgvJBOG5hvwow6kFdJJsoFUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhU9p0P37STqv3uqeDaZQvGfCX+VY9FoQ30YMkwAHyRbQs01W6YQuazmHsB2FsW2w
         q5Nx8MaZhmz2gaE11mGibN04gUjPCPhxjGCNJszrnijNpTWE1kLNgo54Z7kfyTjXL/
         oEKIFPcHy6yUO+NdgoVMj8Zg5K1IPdolTVcMkKVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/133] Revert "usb/xhci-plat: Set PM runtime as active on resume"
Date:   Mon, 20 Jul 2020 17:36:29 +0200
Message-Id: <20200720152805.751847223@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 661f5686a1c805e9b1bff65c312c38ef97faa91d.

Eugeniu Rosca writes:

On Thu, Jul 09, 2020 at 09:00:23AM +0200, Eugeniu Rosca wrote:
>After integrating v4.14.186 commit 5410d158ca2a50 ("usb/ehci-platform:
>Set PM runtime as active on resume") into downstream v4.14.x, we started
>to consistently experience below panic [1] on every second s2ram of
>R-Car H3 Salvator-X Renesas reference board.
>
>After some investigations, we concluded the following:
> - the issue does not exist in vanilla v5.8-rc4+
> - [bisecting shows that] the panic on v4.14.186 is caused by the lack
>   of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
>   link support"). Getting evidence for that is easy. Reverting
>   987351e1ea7772 in vanilla leads to a similar backtrace [2].
>
>Questions:
> - Backporting 987351e1ea7772 ("phy: core: Add consumer device
>   link support") to v4.14.187 looks challenging enough, so probably not
>   worth it. Anybody to contradict this?
> - Assuming no plans to backport the missing mainline commit to v4.14.x,
>   should the following three v4.14.186 commits be reverted on v4.14.x?
>   * baef809ea497a4 ("usb/ohci-platform: Fix a warning when hibernating")
>   * 9f33eff4958885 ("usb/xhci-plat: Set PM runtime as active on resume")
>   * 5410d158ca2a50 ("usb/ehci-platform: Set PM runtime as active on resume"

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 65972c186c641..adc437ca83b88 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -408,15 +408,7 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = xhci_resume(xhci, 0);
-	if (ret)
-		return ret;
-
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
-	return 0;
+	return xhci_resume(xhci, 0);
 }
 
 static int __maybe_unused xhci_plat_runtime_suspend(struct device *dev)
-- 
2.25.1



