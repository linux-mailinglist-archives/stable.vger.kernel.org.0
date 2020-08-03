Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D0523A52F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgHCMeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbgHCMeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:34:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF68204EC;
        Mon,  3 Aug 2020 12:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458043;
        bh=mGIoNqX0wHrYxrN0N04836iTnMVld3FpDskrIXmcDW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRVX+9xPjGegsivOQWDeOU/qaWdoH9dYQ2eql8RhZcOdFffmfzPGD82aYdx5Uf0n4
         ttR8iFl4u9/esiBO2ni/EKpa8qLOniB45omZG+MBiPFfqeGFZ9BSKQ7TzdP4okwvpF
         RPj8f0EFzFkwSqJnjuVlBvg+wqEyavJltWopvsQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/51] ath9k: release allocated buffer if timed out
Date:   Mon,  3 Aug 2020 14:19:52 +0200
Message-Id: <20200803121849.821831945@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 728c1e2a05e4b5fc52fab3421dce772a806612a2 ]

In ath9k_wmi_cmd, the allocated network buffer needs to be released
if timeout happens. Otherwise memory will be leaked.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index f57f48e4d7a0a..4b68804f3742e 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -338,6 +338,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
 		mutex_unlock(&wmi->op_mutex);
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
-- 
2.25.1



