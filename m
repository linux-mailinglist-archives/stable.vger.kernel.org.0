Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2BA472899
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbhLMKOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46178 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbhLMJ45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E16FACE0E86;
        Mon, 13 Dec 2021 09:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D08C34600;
        Mon, 13 Dec 2021 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389411;
        bh=uf172LFsvGkogJ4pSihMNlwgTlNtAhValDJMtbHFdNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqZV7rrhQkoJ6KfHCcuJ3fAXI6yfCtTjBxx0083FJW5U1tNpYJTi2n+hwphBp/nD5
         ohb4dFCjo7Rx/FvFV53uVg1OqzAyJNNB11HGLzlD79y/Ajpqm6X5Qye2e0LnSqRMdZ
         XJlMJcB/nUHJafvyGrH1d9TCivfvx/2Nqeb7/RIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 089/171] mmc: renesas_sdhi: initialize variable properly when tuning
Date:   Mon, 13 Dec 2021 10:30:04 +0100
Message-Id: <20211213092948.047760768@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -673,7 +673,7 @@ static int renesas_sdhi_execute_tuning(s
 
 	/* Issue CMD19 twice for each tap */
 	for (i = 0; i < 2 * priv->tap_num; i++) {
-		int cmd_error;
+		int cmd_error = 0;
 
 		/* Set sampling clock position */
 		sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_TAPSET, i % priv->tap_num);


