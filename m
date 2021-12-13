Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7A4727A7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhLMKEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239881AbhLMJ67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658BAC08EB4E;
        Mon, 13 Dec 2021 01:48:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0549CE0E90;
        Mon, 13 Dec 2021 09:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4D5C33A40;
        Mon, 13 Dec 2021 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388926;
        bh=M9QjttD6hCL49HuJ2hVth4mZlYBilqakPcQTGnAoDdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z08QgTRnqAq28GAQq6enCJLj7Kg9gagBQixriq81G7vDsVTi7VDAYJWuojwibIuk6
         oIzUUXy4fcVb5JICIQsm4XkciCtYSNJz9zYpl/9eNX38Ly79N9BIrQ7t3SSxfiy4K+
         ah4Se7VAjxFwlaHY/LkRcXcoSvd4zU2XnoN2QB8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 058/132] mmc: renesas_sdhi: initialize variable properly when tuning
Date:   Mon, 13 Dec 2021 10:29:59 +0100
Message-Id: <20211213092941.112914228@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 7dba402807a85fa3723f4a27504813caf81cc9d7 upstream.

'cmd_error' is not necessarily initialized on some error paths in
mmc_send_tuning(). Initialize it.

Fixes: 2c9017d0b5d3 ("mmc: renesas_sdhi: abort tuning when timeout detected")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211130132309.18246-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -660,7 +660,7 @@ static int renesas_sdhi_execute_tuning(s
 
 	/* Issue CMD19 twice for each tap */
 	for (i = 0; i < 2 * priv->tap_num; i++) {
-		int cmd_error;
+		int cmd_error = 0;
 
 		/* Set sampling clock position */
 		sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_TAPSET, i % priv->tap_num);


