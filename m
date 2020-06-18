Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797381FE836
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgFRCrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgFRBK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 466A120B1F;
        Thu, 18 Jun 2020 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442627;
        bh=LvZa/7AsDPAYb/1zpp6H+ylMgU8pk/XBS6Sdc/QdG0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+1miItGjl+bLI6+hthY4CyLdCOL+si4pN4FI4WQFeJB7oCGCytGLJzPBAgqToCKb
         be1rhRfU9xgxgUxxj85wkM3PQ8bQf1oAPvaxuMehlid8RL1JR429a9H3C3baNd/JGI
         oyjNVe9P3DEKZyqg/kXjgBuQdipdVKi9+7eqs1e0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Arlott <simon@octiron.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 105/388] scsi: sr: Fix sr_probe() missing mutex_destroy
Date:   Wed, 17 Jun 2020 21:03:22 -0400
Message-Id: <20200618010805.600873-105-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Arlott <simon@octiron.net>

[ Upstream commit a247e07f8dadba5da9f188aaf4f96db0302146d9 ]

If the device minor cannot be allocated or the cdrom fails to be registered
then the mutex should be destroyed.

Link: https://lore.kernel.org/r/06e9de38-eeed-1cab-5e08-e889288935b3@0882a8b5-c6c3-11e9-b005-00805fc181fe
Fixes: 51a858817dcd ("scsi: sr: get rid of sr global mutex")
Signed-off-by: Simon Arlott <simon@octiron.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d2fe3fa470f9..8d062d4f3ce0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -817,6 +817,7 @@ static int sr_probe(struct device *dev)
 
 fail_put:
 	put_disk(disk);
+	mutex_destroy(&cd->lock);
 fail_free:
 	kfree(cd);
 fail:
-- 
2.25.1

