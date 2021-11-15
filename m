Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D157A45251B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbhKPBqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241917AbhKOSZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2450860EBC;
        Mon, 15 Nov 2021 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998981;
        bh=4YamMmPewrVW2qrua6yAloqcbZ6UoG+EsKNyCNx00/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OASn5mY1Q6VnREjrQlFO5wxO0v0Y5HAItIGjRGzHqYKiZMJr4W/a8cIKw5/MQ1TMz
         3Y5lqtNWHlDzzfu82ch7SYaid/zKBUVi7X65KOGeUQcTMZB9/zBz/6t7fqMjlcu0sx
         90MLCOwvo5m8aUW5NVPYnytCRLJkLbAtLCKDJEMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Reimar=20D=C3=B6ffinger?= <Reimar.Doeffinger@gmx.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.14 131/849] libata: fix checking of DMA state
Date:   Mon, 15 Nov 2021 17:53:34 +0100
Message-Id: <20211115165424.537633028@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


