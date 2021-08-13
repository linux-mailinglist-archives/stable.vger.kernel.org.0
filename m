Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19793EB800
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbhHMPK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241249AbhHMPKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 020C36109E;
        Fri, 13 Aug 2021 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867380;
        bh=sRPFH21GUHaIfPsrdFoiMnFo8Ti4ntSLsfKaoA+wXGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cm+MkjXGPGWMVqjq+2KYt4l4Ai0FhWfS6+Q35eKnzZfUUu4eE90wWEGs2VRy/EgcN
         ic+cKrDtL1ZiEa5XLSBfYMcnpBwa2/2jvoShzjA3aekG49KI4XvzA8zjmlR4MSLoWi
         mfy1PriZQ3YvOHFc4eqyC5KeNFNm71K+g+jJKtZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 4.9 21/30] pcmcia: i82092: fix a null pointer dereference bug
Date:   Fri, 13 Aug 2021 17:06:49 +0200
Message-Id: <20210813150523.121577368@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit e39cdacf2f664b09029e7c1eb354c91a20c367af upstream.

During the driver loading process, the 'dev' field was not assigned, but
the 'dev' field was referenced in the subsequent 'i82092aa_set_mem_map'
function.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
CC: <stable@vger.kernel.org>
[linux@dominikbrodowski.net: shorten commit message, add Cc to stable]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pcmcia/i82092.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -105,6 +105,7 @@ static int i82092aa_pci_probe(struct pci
 	for (i = 0;i<socket_count;i++) {
 		sockets[i].card_state = 1; /* 1 = present but empty */
 		sockets[i].io_base = pci_resource_start(dev, 0);
+		sockets[i].dev = dev;
 		sockets[i].socket.features |= SS_CAP_PCCARD;
 		sockets[i].socket.map_size = 0x1000;
 		sockets[i].socket.irq_mask = 0;


