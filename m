Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828CF49A94E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322438AbiAYDVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355546AbiAXUWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85B2C0417CD;
        Mon, 24 Jan 2022 11:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87DD66135E;
        Mon, 24 Jan 2022 19:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A815C340E5;
        Mon, 24 Jan 2022 19:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053206;
        bh=Ss9cJ1xCoPXGKemzTHnuPgLOcrn/oCFFznA4VV3+pwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUD6ZmlJtRmcwHo+Zd6D6EHzKzhWzoIYvjwBwqJWpf5ciP1IM8HP7y2zAtB4hSpn4
         y+o5epPQ6MEGj4XDcOokDds2f+wls7rp+CvNePGkr4uwp9IE0kUrk9uITltufESj1h
         SOFwVPaG88/2X8EsTEYOXPMbbmTWOxa91mGApV5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 277/320] Documentation: dmaengine: Correctly describe dmatest with channel unset
Date:   Mon, 24 Jan 2022 19:44:21 +0100
Message-Id: <20220124184003.392558506@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

commit c61d7b2ef141abf81140756b45860a2306f395a2 upstream.

Currently the documentation states that channels must be configured before
running the dmatest. This has not been true since commit 6b41030fdc79
("dmaengine: dmatest: Restore default for channel"). Fix accordingly.

Fixes: 6b41030fdc79 ("dmaengine: dmatest: Restore default for channel")
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Link: https://lore.kernel.org/r/20211118100952.27268-3-daniel.thompson@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/dmaengine/dmatest.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/driver-api/dmaengine/dmatest.rst
+++ b/Documentation/driver-api/dmaengine/dmatest.rst
@@ -143,13 +143,14 @@ Part 5 - Handling channel allocation
 Allocating Channels
 -------------------
 
-Channels are required to be configured prior to starting the test run.
-Attempting to run the test without configuring the channels will fail.
+Channels do not need to be configured prior to starting a test run. Attempting
+to run the test without configuring the channels will result in testing any
+channels that are available.
 
 Example::
 
     % echo 1 > /sys/module/dmatest/parameters/run
-    dmatest: Could not start test, no channels configured
+    dmatest: No channels configured, continue with any
 
 Channels are registered using the "channel" parameter. Channels can be requested by their
 name, once requested, the channel is registered and a pending thread is added to the test list.


