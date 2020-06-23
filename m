Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A4B206199
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392778AbgFWUp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390236AbgFWUp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:45:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2832221556;
        Tue, 23 Jun 2020 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945157;
        bh=fDPxEN2laKuOofyfZvjWh8lcMNwzEztQA23LMtZmpKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj1iLTntRWGGKokjTOht9eO5PA2guR7bDssFGno6nfkEohi03FdXJrdcrPRpGqBWl
         Ltff/9HXLLBOWgmr1PKriKgPhM2Q0nf9ziDqcsiXjJtaT5gjOdKypzx7zpQ/FO5mK5
         6AHGRK26O9MKxXfGFsxoRleUaLjCN8KUDWjvUIkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Arlott <simon@octiron.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 034/136] scsi: sr: Fix sr_probe() missing deallocate of device minor
Date:   Tue, 23 Jun 2020 21:58:10 +0200
Message-Id: <20200623195305.359509797@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Arlott <simon@octiron.net>

[ Upstream commit 6555781b3fdec5e94e6914511496144241df7dee ]

If the cdrom fails to be registered then the device minor should be
deallocated.

Link: https://lore.kernel.org/r/072dac4b-8402-4de8-36bd-47e7588969cd@0882a8b5-c6c3-11e9-b005-00805fc181fe
Signed-off-by: Simon Arlott <simon@octiron.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d0389b20574d0..5be3d6b7991b4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -748,7 +748,7 @@ static int sr_probe(struct device *dev)
 	cd->cdi.disk = disk;
 
 	if (register_cdrom(&cd->cdi))
-		goto fail_put;
+		goto fail_minor;
 
 	/*
 	 * Initialize block layer runtime PM stuffs before the
@@ -766,6 +766,10 @@ static int sr_probe(struct device *dev)
 
 	return 0;
 
+fail_minor:
+	spin_lock(&sr_index_lock);
+	clear_bit(minor, sr_index_bits);
+	spin_unlock(&sr_index_lock);
 fail_put:
 	put_disk(disk);
 fail_free:
-- 
2.25.1



