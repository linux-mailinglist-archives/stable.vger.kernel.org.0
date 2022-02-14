Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FB34B47BA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244080AbiBNJh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244593AbiBNJgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4AB1ADB1;
        Mon, 14 Feb 2022 01:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDAA6B80DCE;
        Mon, 14 Feb 2022 09:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0967C340EF;
        Mon, 14 Feb 2022 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831234;
        bh=Jn7SyqQMTieEnO8xObfW/Ak4+IPgh1fcbZ4OR9XFWTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnFMgtQRFw34PM0MnywjkIbGuyoscJXSarXcMPi41BXH0TfO4Wga8g0nan8kbEa45
         7ShDmapfzyiBZ8TRyH+6bXrFtgOSH0kZkj38RgmWm6tbGsxnJ5biJoodV4g3bCGlky
         U0unXWtLb0vR352PpYOqST1hTCafOr79Wq5HbHdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Szymon Heidrich <szymon.heidrich@gmail.com>, stable@kernel.org
Subject: [PATCH 4.19 40/49] USB: gadget: validate interface OS descriptor requests
Date:   Mon, 14 Feb 2022 10:26:06 +0100
Message-Id: <20220214092449.627098545@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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
@@ -1930,6 +1930,9 @@ unknown:
 				if (w_index != 0x5 || (w_value >> 8))
 					break;
 				interface = w_value & 0xFF;
+				if (interface >= MAX_CONFIG_INTERFACES ||
+				    !os_desc_cfg->interface[interface])
+					break;
 				buf[6] = w_index;
 				count = count_ext_prop(os_desc_cfg,
 					interface);


