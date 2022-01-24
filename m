Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40085499E44
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349041AbiAXWbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584631AbiAXWVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3DBC0424F4;
        Mon, 24 Jan 2022 12:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AB7160B21;
        Mon, 24 Jan 2022 20:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA219C340E5;
        Mon, 24 Jan 2022 20:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057547;
        bh=157YON3ewFpZewgxjqxaCDDdcCeplABo9eTS1EJvvBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvFxXD9JdrQP9uWWyvfouhRX8KQoFIySvq/MpMMxvKOqYptCdtzqKwThWX1K60vTa
         Ynsw89uI/ecCz9cuam3Ls69Arviet31Xi+58qV9wf7sPwFzTJknhTOW8rzRFeif0oK
         ykj58tszmPkb2saeoOqiLDqHxS8n3tGP5bemI3XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 827/846] net: ipa: fix atomic update in ipa_endpoint_replenish()
Date:   Mon, 24 Jan 2022 19:45:44 +0100
Message-Id: <20220124184129.435103470@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit 6c0e3b5ce94947b311348c367db9e11dcb2ccc93 upstream.

In ipa_endpoint_replenish(), if an error occurs when attempting to
replenish a receive buffer, we just quit and try again later.  In
that case we increment the backlog count to reflect that the attempt
was unsuccessful.  Then, if the add_one flag was true we increment
the backlog again.

This second increment is not included in the backlog local variable
though, and its value determines whether delayed work should be
scheduled.  This is a bug.

Fix this by determining whether 1 or 2 should be added to the
backlog before adding it in a atomic_add_return() call.

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1067,6 +1067,7 @@ static void ipa_endpoint_replenish(struc
 {
 	struct gsi *gsi;
 	u32 backlog;
+	int delta;
 
 	if (!endpoint->replenish_enabled) {
 		if (add_one)
@@ -1084,10 +1085,8 @@ static void ipa_endpoint_replenish(struc
 
 try_again_later:
 	/* The last one didn't succeed, so fix the backlog */
-	backlog = atomic_inc_return(&endpoint->replenish_backlog);
-
-	if (add_one)
-		atomic_inc(&endpoint->replenish_backlog);
+	delta = add_one ? 2 : 1;
+	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
 
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even


