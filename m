Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7718549A487
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371465AbiAYAIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363969AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB619C0BD12C;
        Mon, 24 Jan 2022 13:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6CB6150C;
        Mon, 24 Jan 2022 21:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D35CC340E4;
        Mon, 24 Jan 2022 21:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060427;
        bh=Ss9cJ1xCoPXGKemzTHnuPgLOcrn/oCFFznA4VV3+pwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njEzyAmWujt4QL+AHE7KThXJMlQ0xCsokcX73JfYIwhcWb29zbi5kaBJEMhkuunIL
         LOgesxLSGiwXFH2mqvOIZIB6asJ1IeOf3ji8Ftkr+gFCJrIQCCSzx48lAgCxUdPncJ
         tEc1D9UYJPY9kjEK+jV8Si4lVxmnTT8ufapgGFFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.16 0911/1039] Documentation: dmaengine: Correctly describe dmatest with channel unset
Date:   Mon, 24 Jan 2022 19:45:00 +0100
Message-Id: <20220124184155.927905050@linuxfoundation.org>
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


