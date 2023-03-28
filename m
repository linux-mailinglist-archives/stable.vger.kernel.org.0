Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA336CC422
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjC1PAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbjC1PAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C84E079
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6E761804
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DA1C433EF;
        Tue, 28 Mar 2023 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015609;
        bh=fBz92v9YhjUdwzznze4CNEBjdFnvqCppo2AMjOgJZeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4g+q6LPlS8AsXNoGglKc5G3bgCoyx59Fehl6ukusUHd7SE+D9o0Zz+GlqpbPCSbc
         rfjz/NmZfko/OZBKZnQy/CTtuXy9T9CS9y6c+xwzQzXxjUsYxd781jeIrEvafAVcdQ
         Po4rljwwk8iRsoVSW7sDhEJyHETr6Aa8MImZVFJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 109/224] thunderbolt: Call tb_check_quirks() after initializing adapters
Date:   Tue, 28 Mar 2023 16:41:45 +0200
Message-Id: <20230328142621.884972129@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit d2d6ddf188f609861489d5d188d545856a3ed399 upstream.

In order to apply quirks based on certain adapter types move call to
tb_check_quirks() happen after the adapters are initialized. This should
not affect the existing quirks.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2959,8 +2959,6 @@ int tb_switch_add(struct tb_switch *sw)
 			dev_warn(&sw->dev, "reading DROM failed: %d\n", ret);
 		tb_sw_dbg(sw, "uid: %#llx\n", sw->uid);
 
-		tb_check_quirks(sw);
-
 		ret = tb_switch_set_uuid(sw);
 		if (ret) {
 			dev_err(&sw->dev, "failed to set UUID\n");
@@ -2979,6 +2977,8 @@ int tb_switch_add(struct tb_switch *sw)
 			}
 		}
 
+		tb_check_quirks(sw);
+
 		tb_switch_default_link_ports(sw);
 
 		ret = tb_switch_update_link_attributes(sw);


