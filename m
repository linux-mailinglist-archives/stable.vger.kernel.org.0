Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FA8232DD8
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgG3IL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729987AbgG3ILs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:11:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC0720842;
        Thu, 30 Jul 2020 08:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096707;
        bh=Ox1LBgxq2BbH8C3xaLYweJKjWUPcht9asvvNmBpt6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sd0j++wAoTET2TzmgrI67NoiewuV6Vz2a3CZWK4H8znLGVaQRVfX04YrSAxi6wgzU
         yKSP7cOS2jGu5UgjKk6AW7w14uYXsSRngkzoRZ8MdRLDeg4KTAvaBV/iYOk+24a7fp
         3IpOFZJKOhr/9maP9NgKJaFrTsw1JwokZr7dLmWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.4 29/54] staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support
Date:   Thu, 30 Jul 2020 10:05:08 +0200
Message-Id: <20200730074422.606886401@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit f07804ec77d77f8a9dcf570a24154e17747bc82f upstream.

`ni6527_intr_insn_config()` processes `INSN_CONFIG` comedi instructions
for the "interrupt" subdevice.  When `data[0]` is
`INSN_CONFIG_DIGITAL_TRIG` it is configuring the digital trigger.  When
`data[2]` is `COMEDI_DIGITAL_TRIG_ENABLE_EDGES` it is configuring rising
and falling edge detection for the digital trigger, using a base channel
number (or shift amount) in `data[3]`, a rising edge bitmask in
`data[4]` and falling edge bitmask in `data[5]`.

If the base channel number (shift amount) is greater than or equal to
the number of channels (24) of the digital input subdevice, there are no
changes to the rising and falling edges, so the mask of channels to be
changed can be set to 0, otherwise the mask of channels to be changed,
and the rising and falling edge bitmasks are shifted by the base channel
number before calling `ni6527_set_edge_detection()` to change the
appropriate registers.  Unfortunately, the code is comparing the base
channel (shift amount) to the interrupt subdevice's number of channels
(1) instead of the digital input subdevice's number of channels (24).
Fix it by comparing to 32 because all shift amounts for an `unsigned
int` must be less than that and everything from bit 24 upwards is
ignored by `ni6527_set_edge_detection()` anyway.

Fixes: 110f9e687c1a8 ("staging: comedi: ni_6527: support INSN_CONFIG_DIGITAL_TRIG")
Cc: <stable@vger.kernel.org> # 3.17+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200717145257.112660-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_6527.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -341,7 +341,7 @@ static int ni6527_intr_insn_config(struc
 		case COMEDI_DIGITAL_TRIG_ENABLE_EDGES:
 			/* check shift amount */
 			shift = data[3];
-			if (shift >= s->n_chan) {
+			if (shift >= 32) {
 				mask = 0;
 				rising = 0;
 				falling = 0;


