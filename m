Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1480C2F14EF
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbhAKNcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732212AbhAKNO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A08922AAF;
        Mon, 11 Jan 2021 13:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370857;
        bh=ZoDqznAwqNHhPb2APJusivNYTMkNm5vnEnrW6EVFyDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzvgjvj5n/63UWHYCXjhEp8OFq+GdynyhLS4AC0jjc4hBX8IKecoDZLY1WOv87cbC
         /JD+mZyPutDs8M5JsGo/6JPp8SkFDzFAwzEYhuKHb0QGf8LpGBycFj0koG/Yz6Fzvq
         18JDHvZbqqWzUzjWgsDFH/5Hyd73isnr4isgPOE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Yijun Shen <Yijun.shen@dell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 027/145] e1000e: Only run S0ix flows if shutdown succeeded
Date:   Mon, 11 Jan 2021 14:00:51 +0100
Message-Id: <20210111130049.813369506@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

[ Upstream commit 808e0d8832cc81738f3e8df12dff0688352baf50 ]

If the shutdown failed, the part will be thawed and running
S0ix flows will put it into an undefined state.

Reported-by: Alexander Duyck <alexander.duyck@gmail.com>
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6970,13 +6970,14 @@ static __maybe_unused int e1000e_pm_susp
 	e1000e_pm_freeze(dev);
 
 	rc = __e1000_shutdown(pdev, false);
-	if (rc)
+	if (rc) {
 		e1000e_pm_thaw(dev);
-
-	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
-		e1000e_s0ix_entry_flow(adapter);
+	} else {
+		/* Introduce S0ix implementation */
+		if (hw->mac.type >= e1000_pch_cnp &&
+		    !e1000e_check_me(hw->adapter->pdev->device))
+			e1000e_s0ix_entry_flow(adapter);
+	}
 
 	return rc;
 }


