Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E530624B9D5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgHTLzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730406AbgHTKCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430572075E;
        Thu, 20 Aug 2020 10:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917739;
        bh=7JvEIUdPWVk1UdixZoBPCQ1DY5YCc+fVM11ymS5y2hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwO0rKyXK49t5W60TJa2CKiF3HViyx4greGd+JMIWx1udfgTkZySH6SRyqpp7cWTY
         AzO8p3JITIv7B4Sx3rz5WGpT5KHtiQs4p5cPYS1QiX+JYLrww4biUTP4Xop8+84qhm
         naboHq6mdTaP0SSkRUhtU2GeUc1RT3Loy++s4Mcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 141/212] wl1251: fix always return 0 error
Date:   Thu, 20 Aug 2020 11:21:54 +0200
Message-Id: <20200820091609.468897067@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 20e6421344b5bc2f97b8e2db47b6994368417904 ]

wl1251_event_ps_report() should not always return 0 because
wl1251_ps_set_mode() may fail. Change it to return 'ret'.

Fixes: f7ad1eed4d4b ("wl1251: retry power save entry")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200730073939.33704-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index d0593bc1f1a92..daddeaa66bf4a 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -84,7 +84,7 @@ static int wl1251_event_ps_report(struct wl1251 *wl,
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static void wl1251_event_mbox_dump(struct event_mailbox *mbox)
-- 
2.25.1



