Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB13674C50
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 06:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjATF3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 00:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjATF2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 00:28:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEE36E0EE
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 21:23:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30DD7B825E7
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 16:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D6AC433D2;
        Thu, 19 Jan 2023 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674145508;
        bh=UFQyLQQWyAXtCa8cGxQ2le/M9vzeoPuRnjuOqwiivLw=;
        h=Subject:To:From:Date:From;
        b=LE8l4+rz9J/RTwRPwMqdrJPJxpf9mTWbUNyZgVxOSnZPFp2Js214fkTv2gOhjHSE2
         Y/SfnmbaYEN1rdAIcNNf3zIxxN82jXJYUyeJ8AHGwyI9tXabrhep62cI4eyiHr5ABi
         ynz3esLLT8rXpEyfHIzifFkhTecrxke1+oJidfCc=
Subject: patch "comedi: adv_pci1760: Fix PWM instruction handling" added to char-misc-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Jan 2023 17:25:01 +0100
Message-ID: <167414550198189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    comedi: adv_pci1760: Fix PWM instruction handling

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2efb6edd52dc50273f5e68ad863dd1b1fb2f2d1c Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 3 Jan 2023 14:37:54 +0000
Subject: comedi: adv_pci1760: Fix PWM instruction handling

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
 drivers/comedi/drivers/adv_pci1760.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/adv_pci1760.c b/drivers/comedi/drivers/adv_pci1760.c
index fcfc2e299110..27f3890f471d 100644
--- a/drivers/comedi/drivers/adv_pci1760.c
+++ b/drivers/comedi/drivers/adv_pci1760.c
@@ -58,7 +58,7 @@
 #define PCI1760_CMD_CLR_IMB2		0x00	/* Clears IMB2 */
 #define PCI1760_CMD_SET_DO		0x01	/* Set output state */
 #define PCI1760_CMD_GET_DO		0x02	/* Read output status */
-#define PCI1760_CMD_GET_STATUS		0x03	/* Read current status */
+#define PCI1760_CMD_GET_STATUS		0x07	/* Read current status */
 #define PCI1760_CMD_GET_FW_VER		0x0e	/* Read firmware version */
 #define PCI1760_CMD_GET_HW_VER		0x0f	/* Read hardware version */
 #define PCI1760_CMD_SET_PWM_HI(x)	(0x10 + (x) * 2) /* Set "hi" period */
-- 
2.39.1


