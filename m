Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8252450D26
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhKORwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238664AbhKORtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:49:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67AF56120F;
        Mon, 15 Nov 2021 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997449;
        bh=4YamMmPewrVW2qrua6yAloqcbZ6UoG+EsKNyCNx00/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGrI8aST/f/I10lE4U9MiJwrLjGaqrI/b8iojxeuiDIPtM8aIDdeExwHhWxJ5gwaq
         0nrQLenHWwfQ4gkUIs2Is+9rlUAZjYLaw09NCx8fUdQrMa0V/xNz79Atngz//nEq3C
         7/1IQ5S+js4pmbP24HxcVoWOzKt9i90jmW0ur0JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Reimar=20D=C3=B6ffinger?= <Reimar.Doeffinger@gmx.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.10 109/575] libata: fix checking of DMA state
Date:   Mon, 15 Nov 2021 17:57:14 +0100
Message-Id: <20211115165347.429522866@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reimar Döffinger <Reimar.Doeffinger@gmx.de>

commit f971a85439bd25dc7b4d597cf5e4e8dc7ffc884b upstream.

Checking if DMA is enabled should be done via the
ata_dma_enabled helper function, since the init state
0xff indicates disabled.
This meant that ATA_CMD_READ_LOG_DMA_EXT was used and probed
for before DMA was enabled, which caused hangs for some combinations
of controllers and devices.
It might also have caused it to be incorrectly disabled as broken,
but there have been no reports of that.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=195895
Signed-off-by: Reimar Döffinger <Reimar.Doeffinger@gmx.de>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2004,7 +2004,7 @@ unsigned int ata_read_log_page(struct at
 
 retry:
 	ata_tf_init(dev, &tf);
-	if (dev->dma_mode && ata_id_has_read_log_dma_ext(dev->id) &&
+	if (ata_dma_enabled(dev) && ata_id_has_read_log_dma_ext(dev->id) &&
 	    !(dev->horkage & ATA_HORKAGE_NO_DMA_LOG)) {
 		tf.command = ATA_CMD_READ_LOG_DMA_EXT;
 		tf.protocol = ATA_PROT_DMA;


