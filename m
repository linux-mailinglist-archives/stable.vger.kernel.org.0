Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786C847252D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhLMJlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:41:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhLMJjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:39:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0588B80DE8;
        Mon, 13 Dec 2021 09:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45278C00446;
        Mon, 13 Dec 2021 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388388;
        bh=d/RwNHzyE/q+cPHveFuVEpqveAwipIIEoZvQj/sw5pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsJO42MPxttfhptXENXayD+uk0TEhdzY+DQ4E24WibqqYdNizic6eEAP3dIXOwQeY
         tUlTsFpbJXD/7HovsTcR60VoenUt7+NcRnnUBrRgyHgiY6DHOH7ufyJ/H/R/C6qG3C
         MLIlb8Y+uBLuMQYapzA6cVQcvv3KEHn4E654Xn3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.19 33/74] libata: add horkage for ASMedia 1092
Date:   Mon, 13 Dec 2021 10:30:04 +0100
Message-Id: <20211213092931.925040473@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit a66307d473077b7aeba74e9b09c841ab3d399c2d upstream.

The ASMedia 1092 has a configuration mode which will present a
dummy device; sadly the implementation falsely claims to provide
a device with 100M which doesn't actually exist.
So disable this device to avoid errors during boot.

Cc: stable@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4453,6 +4453,8 @@ static const struct ata_blacklist_entry
 	{ "VRFDFC22048UCHC-TE*", NULL,		ATA_HORKAGE_NODMA },
 	/* Odd clown on sil3726/4726 PMPs */
 	{ "Config  Disk",	NULL,		ATA_HORKAGE_DISABLE },
+	/* Similar story with ASMedia 1092 */
+	{ "ASMT109x- Config",	NULL,		ATA_HORKAGE_DISABLE },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },


