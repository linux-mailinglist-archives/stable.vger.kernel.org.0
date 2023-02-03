Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A8C6894F5
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjBCKPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjBCKPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:15:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAEF8E68D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7350360691
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5331AC433D2;
        Fri,  3 Feb 2023 10:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419299;
        bh=QsKsbBGiRqVtLWs+WkLHLaGbKXKHzpxMZzMwdkHnCaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfb11ODLQJvakpzSHn61M2wqsi3+HSYusaOyJU1T1Ra3bjtth7IOPefKvEHVmXFSq
         0nwTPiIKvjF+GEI73wUp8A8OBJja3ILLzZKPxyQEIKr7LLMhA505ZESpitatb3AZsf
         RteZyKqCE1EAwgiEwPFeCL6nWbQs7OLFxpwBtAyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 22/62] comedi: adv_pci1760: Fix PWM instruction handling
Date:   Fri,  3 Feb 2023 11:12:18 +0100
Message-Id: <20230203101013.974210835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 2efb6edd52dc50273f5e68ad863dd1b1fb2f2d1c upstream.

(Actually, this is fixing the "Read the Current Status" command sent to
the device's outgoing mailbox, but it is only currently used for the PWM
instructions.)

The PCI-1760 is operated mostly by sending commands to a set of Outgoing
Mailbox registers, waiting for the command to complete, and reading the
result from the Incoming Mailbox registers.  One of these commands is
the "Read the Current Status" command.  The number of this command is
0x07 (see the User's Manual for the PCI-1760 at
<https://advdownload.advantech.com/productfile/Downloadfile2/1-11P6653/PCI-1760.pdf>.
The `PCI1760_CMD_GET_STATUS` macro defined in the driver should expand
to this command number 0x07, but unfortunately it currently expands to
0x03.  (Command number 0x03 is not defined in the User's Manual.)
Correct the definition of the `PCI1760_CMD_GET_STATUS` macro to fix it.

This is used by all the PWM subdevice related instructions handled by
`pci1760_pwm_insn_config()` which are probably all broken.  The effect
of sending the undefined command number 0x03 is not known.

Fixes: 14b93bb6bbf0 ("staging: comedi: adv_pci_dio: separate out PCI-1760 support")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20230103143754.17564-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1760.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/adv_pci1760.c
+++ b/drivers/staging/comedi/drivers/adv_pci1760.c
@@ -68,7 +68,7 @@
 #define PCI1760_CMD_CLR_IMB2		0x00	/* Clears IMB2 */
 #define PCI1760_CMD_SET_DO		0x01	/* Set output state */
 #define PCI1760_CMD_GET_DO		0x02	/* Read output status */
-#define PCI1760_CMD_GET_STATUS		0x03	/* Read current status */
+#define PCI1760_CMD_GET_STATUS		0x07	/* Read current status */
 #define PCI1760_CMD_GET_FW_VER		0x0e	/* Read firware version */
 #define PCI1760_CMD_GET_HW_VER		0x0f	/* Read hardware version */
 #define PCI1760_CMD_SET_PWM_HI(x)	(0x10 + (x) * 2) /* Set "hi" period */


