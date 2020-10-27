Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF3029ABC5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 13:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751009AbgJ0MS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 08:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbgJ0MS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 08:18:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2C2522283;
        Tue, 27 Oct 2020 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603801105;
        bh=INsJBWlwcJJirta9xdzYeDim389p0z7sDIcU+ho0fKE=;
        h=Subject:To:From:Date:From;
        b=DfOrcENICblBNev0poR0TVswmHazIMTLitbHbF5KEDG8XqMNj0pGggiAMXhjDn7zI
         giA8pA4iRHmYwfdb0svS7GP3r3q2a3TqvwQ/P0kFIdKTDPnmXN2UZQYRzPlSmgCHrG
         qz9RTnLaUHMhq4bHetY7UC2TCRygGCl371+cIqz0=
Subject: patch "staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Oct 2020 13:19:07 +0100
Message-ID: <160380114725542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 647a6002cb41d358d9ac5de101a8a6dc74748a59 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Wed, 21 Oct 2020 13:21:42 +0100
Subject: staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

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
Link: https://lore.kernel.org/r/20201021122142.81628-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.29.1


