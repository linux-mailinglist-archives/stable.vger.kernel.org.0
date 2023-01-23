Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927D5677976
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 11:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjAWKqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 05:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjAWKqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 05:46:46 -0500
X-Greylist: delayed 586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Jan 2023 02:46:45 PST
Received: from smtp125.ord1d.emailsrvr.com (smtp125.ord1d.emailsrvr.com [184.106.54.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2712F04
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 02:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20221208-6x11dpa4; t=1674470218;
        bh=Z+IifiGGM+WyRQOOe4AdS9A8ssaYsf35oBp4mZFia0A=;
        h=From:To:Subject:Date:From;
        b=JWtePymms3DAQ8Tt+1kK5v76GYM9XMq14VStGFKcoNn1OWkaPq+5MsTEMO/+x8o3z
         JYhgVtuRNZcy1V3zeLB7M/UHf06lxOFU3oRS6Hrpfo2R2NCJmA/bV0EhLgSUXMCvHC
         oazVEnD+zy6XIP91ZI4cypUU7Lr5yDrCSM638KgA=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp24.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id AF6ECA00BC;
        Mon, 23 Jan 2023 05:36:57 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14] comedi: adv_pci1760: Fix PWM instruction handling
Date:   Mon, 23 Jan 2023 10:36:41 +0000
Message-Id: <20230123103641.9000-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: fbb9be5f-51ac-45f8-8b59-9e1e960e719a-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Should apply OK to v4.5 to v4.18 inclusive. [IA]
---
 drivers/staging/comedi/drivers/adv_pci1760.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1760.c b/drivers/staging/comedi/drivers/adv_pci1760.c
index 9f525ff7290c..67b0cf0b9066 100644
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
-- 
2.39.0

