Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE646499BB6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379573AbiAXVyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33472 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379034AbiAXVoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D638C61534;
        Mon, 24 Jan 2022 21:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A88C340E4;
        Mon, 24 Jan 2022 21:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060647;
        bh=157YON3ewFpZewgxjqxaCDDdcCeplABo9eTS1EJvvBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjb5nDQIzmgEnWMfvXCY5T83twSZlgWVp1wP8nLDiqHlXJQifdBl4ap9K6191/t6g
         tpI/5J/6DKWb2QC5Vvoo0syn949KYc+q6cQVMDlvaiMR5iXoarB+hE454j6UNqsbgX
         kUCXKEzBcL8Yve7Xen/wK5NTCCv+bqP8+cUlZOeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1010/1039] net: ipa: fix atomic update in ipa_endpoint_replenish()
Date:   Mon, 24 Jan 2022 19:46:39 +0100
Message-Id: <20220124184159.242299257@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


