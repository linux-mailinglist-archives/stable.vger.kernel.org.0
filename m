Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173B64B4838
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245726AbiBNJww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344830AbiBNJwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:52:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6267B542;
        Mon, 14 Feb 2022 01:43:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED2360FA2;
        Mon, 14 Feb 2022 09:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9948EC340E9;
        Mon, 14 Feb 2022 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831797;
        bh=W/rZpCwWfP2MIfCd7ghjXQZP0wpoXvZV20V3NBzfweU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/AOPdbSG6Z4bnPJKnW/bSPRVC+V6RlOgvCecexDWjo8I5KGPZq3wYgylUCeX7PAq
         +gps+2a9WGPyYDE3ite41FXQGzfTrBoXxF8QJdLq8UOHoKTRdOwQ8qUQv+bpi9QKGL
         1X5qz5iooLmgp4d5txH20d9XpvN46IU1zS9jjpMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Szymon Heidrich <szymon.heidrich@gmail.com>, stable@kernel.org
Subject: [PATCH 5.10 098/116] USB: gadget: validate interface OS descriptor requests
Date:   Mon, 14 Feb 2022 10:26:37 +0100
Message-Id: <20220214092502.161187259@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

commit 75e5b4849b81e19e9efe1654b30d7f3151c33c2c upstream.

Stall the control endpoint in case provided index exceeds array size of
MAX_CONFIG_INTERFACES or when the retrieved function pointer is null.

Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1944,6 +1944,9 @@ unknown:
 				if (w_index != 0x5 || (w_value >> 8))
 					break;
 				interface = w_value & 0xFF;
+				if (interface >= MAX_CONFIG_INTERFACES ||
+				    !os_desc_cfg->interface[interface])
+					break;
 				buf[6] = w_index;
 				count = count_ext_prop(os_desc_cfg,
 					interface);


