Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF176CC41F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjC1PAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbjC1PAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5633B183
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E675261804
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B18C433EF;
        Tue, 28 Mar 2023 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015601;
        bh=yo/GowJspS9xIPJZdpuPQJlHVyI1uHUr04sRIKrsvcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxQx3oadTziwyewX7kmZr+XLQHZCCWUSrvxvcQV9j8deuJItGycVunmsUdsaEDUEc
         X4emKy5ogZnpAw54rlO4a8DywPzoSSyyVL0/1ghq+C//sYS1jtkiIFrAy2IsoAa7T1
         eljX+9z74OR2AscjvXjz+S2NcK3tgMe4TnQZ9fFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yaroslav Furman <yaro330@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 6.1 107/224] uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2
Date:   Tue, 28 Mar 2023 16:41:43 +0200
Message-Id: <20230328142621.797101205@linuxfoundation.org>
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

From: Yaroslav Furman <yaro330@gmail.com>

commit a37eb61b6ec064ac794b8a1e89fd33eb582fe51d upstream.

Just like other JMicron JMS5xx enclosures, it chokes on report-opcodes,
let's avoid them.

Signed-off-by: Yaroslav Furman <yaro330@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230312090745.47962-1-yaro330@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -111,6 +111,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported by: Yaroslav Furman <yaro330@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0583, 0x0000, 0x9999,
+		"JMicron",
+		"JMS583Gen 2",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
 		"PNY",


