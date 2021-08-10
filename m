Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636E93E7E93
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhHJReU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232747AbhHJRdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAB0760FC4;
        Tue, 10 Aug 2021 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616805;
        bh=sRPFH21GUHaIfPsrdFoiMnFo8Ti4ntSLsfKaoA+wXGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI3HNTeu84Rtv1psOSIAr6oNFWkY85cJqnu8LPlYQrEZCF/RwRUgiYmx04SPsFNvz
         L1QtKWOdr1jtzeeevB6z0Yw3AsQ2XSom/0pBnI+UEVF2rPY50deSSinquUBhAYmoHF
         gGetNqWTCgSVSPHU6BHDqRG5fmVTi05GFUfTwHAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 4.19 43/54] pcmcia: i82092: fix a null pointer dereference bug
Date:   Tue, 10 Aug 2021 19:30:37 +0200
Message-Id: <20210810172945.607419062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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


