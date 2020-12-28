Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69312E68A6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgL1QjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgL1NAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB42722573;
        Mon, 28 Dec 2020 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160397;
        bh=DE3cR/WXTTulpqmIcWjEFEhHP2EW4aJJyfdFm0vLJWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqL7HrUgc84vjW84d5QolGQ7rsuxnvpX2TsBV4AmJYd3HdZxPMrgz4UdssYO5zzsl
         W7qeTruG+dKrRywnBmbXIUbK+abVFsQeEHJAZfLLq15A6qWeoL6Gy4E+1R//odrqmp
         CMzny94APNqzqM1LQbWQ+H3bXxjG0jDi7qUavSyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Will McVicker <willmcvicker@google.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.9 038/175] USB: gadget: f_midi: setup SuperSpeed Plus descriptors
Date:   Mon, 28 Dec 2020 13:48:11 +0100
Message-Id: <20201228124855.092762987@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will McVicker <willmcvicker@google.com>

commit 457a902ba1a73b7720666b21ca038cd19764db18 upstream.

Needed for SuperSpeed Plus support for f_midi.  This allows the
gadget to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_midi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1008,6 +1008,12 @@ static int f_midi_bind(struct usb_config
 		f->hs_descriptors = usb_copy_descriptors(midi_function);
 		if (!f->hs_descriptors)
 			goto fail_f_midi;
+
+		if (gadget_is_superspeed_plus(c->cdev->gadget)) {
+			f->ssp_descriptors = usb_copy_descriptors(midi_function);
+			if (!f->ssp_descriptors)
+				goto fail_f_midi;
+		}
 	}
 
 	kfree(midi_function);


