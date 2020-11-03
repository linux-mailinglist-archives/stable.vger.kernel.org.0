Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6202A57CA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbgKCVqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:46:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732093AbgKCUwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134C72071E;
        Tue,  3 Nov 2020 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436745;
        bh=R2uupPPjUrCiVXqiZGMwEogBjkihGfr35fgrFP4hGsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tm5/DAKLN5s9JpWZv5ofmKhByuCFn76a0tIeuiZQz/SCwL2cuvzXN/z/AcoOepQW5
         /4sFvheC255YUpeJ4mdi4ySJxbnyiJWoODOYHaWIUwgLgDv7tCyeH9CdxaYnJJUbWf
         Vg3w1e3ZXZ6Crrw0v1zHXugNzeYhVYMosFwOqVVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.9 382/391] staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice
Date:   Tue,  3 Nov 2020 21:37:13 +0100
Message-Id: <20201103203412.941117108@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 647a6002cb41d358d9ac5de101a8a6dc74748a59 upstream.

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
 drivers/staging/comedi/drivers/cb_pcidas.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1342,6 +1342,7 @@ static int cb_pcidas_auto_attach(struct
 		if (dev->irq && board->has_ao_fifo) {
 			dev->write_subdev = s;
 			s->subdev_flags	|= SDF_CMD_WRITE;
+			s->len_chanlist	= s->n_chan;
 			s->do_cmdtest	= cb_pcidas_ao_cmdtest;
 			s->do_cmd	= cb_pcidas_ao_cmd;
 			s->cancel	= cb_pcidas_ao_cancel;


