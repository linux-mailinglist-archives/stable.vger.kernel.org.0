Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D013294C9F
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440331AbgJUMbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 08:31:46 -0400
Received: from smtp92.iad3b.emailsrvr.com ([146.20.161.92]:55283 "EHLO
        smtp92.iad3b.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440313AbgJUMbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 08:31:46 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 08:31:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1603282912;
        bh=ZE9+XG2zA9RyTvFol/riiOC1znkCkwM5Eh0yONeEWgE=;
        h=From:To:Subject:Date:From;
        b=K4xJippQtG1HZ04utJL9fWCtqQPnAIXWt0hos05jOwcy8NByWiJLgtj1meFtXgIwi
         Poinnzwoa9fIOOeXyVLqCDlKTBcTEXNfFgf5W/nvoFfLDybuxTxeT8Q+yQFK+2Hiva
         eZhVf57NUJ348PRs2EzYnVDRj0hvh1SQQhHyde94=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp20.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 7C947A00DF;
        Wed, 21 Oct 2020 08:21:51 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice
Date:   Wed, 21 Oct 2020 13:21:42 +0100
Message-Id: <20201021122142.81628-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 3d247cbd-23fe-49e7-91e7-faeaa4e78242-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "cb_pcidas" driver supports asynchronous commands on the analog
output (AO) subdevice for those boards that have an AO FIFO.  The code
(in `cb_pcidas_ao_check_chanlist()` and `cb_pcidas_ao_cmd()`) to
validate and set up the command supports output to a single channel or
to two channels simultaneously (the boards have two AO channels).
However, the code in `cb_pcidas_auto_attach()` that initializes the
subdevices neglects to initialize the AO subdevice's `len_chanlist`
member, leaving it set to 0, but the Comedi core will "correct" it to 1
if the driver neglected to set it.  This limits commands to use a single
channel (either channel 0 or 1), but the limit should be two channels.
Set the AO subdevice's `len_chanlist` member to be the same value as the
`n_chan` member, which will be 2.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 48ec2ee953dc..d740c4782775 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1342,6 +1342,7 @@ static int cb_pcidas_auto_attach(struct comedi_device *dev,
 		if (dev->irq && board->has_ao_fifo) {
 			dev->write_subdev = s;
 			s->subdev_flags	|= SDF_CMD_WRITE;
+			s->len_chanlist	= s->n_chan;
 			s->do_cmdtest	= cb_pcidas_ao_cmdtest;
 			s->do_cmd	= cb_pcidas_ao_cmd;
 			s->cancel	= cb_pcidas_ao_cancel;
-- 
2.28.0

