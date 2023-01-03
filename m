Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04565C29B
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbjACO5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 09:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbjACO5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 09:57:08 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Jan 2023 06:56:45 PST
Received: from smtp99.iad3a.emailsrvr.com (smtp99.iad3a.emailsrvr.com [173.203.187.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC74120AC
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 06:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20221208-6x11dpa4; t=1672756696;
        bh=raLLg04Q27BCx4M0eo9jN8NQ6JGjtQUYVf+RsKoKD7o=;
        h=From:To:Subject:Date:From;
        b=Iy0S4B41ZgnTSCYIxlKtm0cziIZPmMLpPGBYUztmodM3h38W+3t8tx+6bIHdLC2Vd
         pNmQS3NmKY7izEvj9sbchfddom3XX/OMqLCraz8Xgi3KmmIwtEgvbVYSHVVG7VG+tF
         D7utxVWuFwEJ8fuETVZOOCyWd5RA1zQwZUS5qUTU=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp29.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 752FA22242;
        Tue,  3 Jan 2023 09:38:15 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH] comedi: adv_pci1760: Fix PWM instruction handling
Date:   Tue,  3 Jan 2023 14:37:54 +0000
Message-Id: <20230103143754.17564-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: c86974ef-dacd-49ee-8fd1-dc1fc4a19be1-1-1
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_BL_SPAMCOP_NET,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.35.1

