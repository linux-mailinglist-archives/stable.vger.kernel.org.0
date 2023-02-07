Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17A68D8F5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjBGNO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjBGNOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:14:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D823B66A
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9ED7B818E8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E259C433D2;
        Tue,  7 Feb 2023 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775587;
        bh=pm9XZgkdvp3mzqs89wg0NvNQEd7ddgjucM5+/O0kS0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0nc4y+wvW4JzNyyYYPhEXooaVY6kCLRdsl9IwUANF/KMOmG0zAjASMTknXBJp/yT
         F1cPe/hoFsyVAEt47Pc7Z9774MAWw2xqB/CcpcUCEtKxKPDX8OxQaZeU8NWyN3unPX
         cxvqVyBM2z8pS3E+BNMUqbzJy+ysrffZfYp4I2V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 5.15 091/120] usb: gadget: f_uac2: Fix incorrect increment of bNumEndpoints
Date:   Tue,  7 Feb 2023 13:57:42 +0100
Message-Id: <20230207125622.635694020@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pratham Pratap <quic_ppratap@quicinc.com>

commit 2fa89458af9993fab8054daf827f38881e2ad473 upstream.

Currently connect/disconnect of USB cable calls afunc_bind and
eventually increments the bNumEndpoints. Performing multiple
plugin/plugout will increment bNumEndpoints incorrectly, and on
the next plug-in it leads to invalid configuration of descriptor
and hence enumeration fails.

Fix this by resetting the value of bNumEndpoints to 1 on every
afunc_bind call.

Fixes: 40c73b30546e ("usb: gadget: f_uac2: add adaptive sync support for capture")
Cc: stable <stable@kernel.org>
Signed-off-by: Pratham Pratap <quic_ppratap@quicinc.com>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/1674631645-28888-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1069,6 +1069,7 @@ afunc_bind(struct usb_configuration *cfg
 		}
 		std_as_out_if0_desc.bInterfaceNumber = ret;
 		std_as_out_if1_desc.bInterfaceNumber = ret;
+		std_as_out_if1_desc.bNumEndpoints = 1;
 		uac2->as_out_intf = ret;
 		uac2->as_out_alt = 0;
 


