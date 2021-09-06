Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEC4401BE4
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243692AbhIFNAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243043AbhIFM6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6193860F43;
        Mon,  6 Sep 2021 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933066;
        bh=H6Ec/h8dYi+r/7tH8UjUPCKMdRzqno0ISBFRLdo00bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1req0OzIx3om4kTl/P93MRrDXPaaY5YsaR2Mx1dspTLEsZgPNnHjeaFh9dL1uLig
         S1Chy6XVJyk4MOT2tjrN68xj56VZo4UnEBH9VmqUmCqcbr6tsvTRLfm2LLRilKJjOg
         gv/T/fjoxRNSpmRcciFnX1BZo4hlW8NU5Jwe4paM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.13 17/24] USB: serial: pl2303: fix GL type detection
Date:   Mon,  6 Sep 2021 14:55:46 +0200
Message-Id: <20210906125449.679785193@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

commit dcf097e7d21fbdfbf20e473ac155f4d154018374 upstream.

At least some PL2303GL have a bcdDevice of 0x405 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: stable@vger.kernel.org	# 5.13
Link: https://lore.kernel.org/r/20210826110239.5269-1-robert.marko@sartura.hr
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -433,6 +433,7 @@ static int pl2303_detect_type(struct usb
 		switch (bcdDevice) {
 		case 0x100:
 		case 0x305:
+		case 0x405:
 			/*
 			 * Assume it's an HXN-type if the device doesn't
 			 * support the old read request value.


