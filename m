Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157D3226BB9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgGTQn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbgGTPlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:41:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989FE2064B;
        Mon, 20 Jul 2020 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259706;
        bh=H65Z4LoXTK7spilxX0Aich7GtXg8kljEivi0SLB3HZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZzWBar+oUXB/WU0JkN1TMrem/22HnBuOOPA4dSJ9wLVsOEW3aLQzyOPUhROs3IBS
         3ysVezZHsUrSi4ZtJdrJmlp9f2Mpw33RiUSHD0+Wi56+U0o6FZBIjeil+UdBPpabpP
         hKD+Id1FbdPhBNduEdYo+IbrvxLvBcLsrNLzz25g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 50/86] Revert "usb/xhci-plat: Set PM runtime as active on resume"
Date:   Mon, 20 Jul 2020 17:36:46 +0200
Message-Id: <20200720152755.681432535@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9e148a5e5e0929a4cb3000de9c843a07508ce575.

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
>   * 5410d158ca2a50 ("usb/ehci-platform: Set PM runtime as active on resume")

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 169d7b2feb1f7..781283a5138ea 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -313,17 +313,8 @@ static int xhci_plat_resume(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
-	int ret;
-
-	ret = xhci_resume(xhci, 0);
-	if (ret)
-		return ret;
-
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
 
-	return 0;
+	return xhci_resume(xhci, 0);
 }
 
 static const struct dev_pm_ops xhci_plat_pm_ops = {
-- 
2.25.1



