Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17961206594
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgFWUG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388469AbgFWUG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2412064B;
        Tue, 23 Jun 2020 20:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942786;
        bh=gHUQKhBCFvh/IqKiVujYxJZeiQ18wAyVeBlVfzXE9jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cd7p4GuZBtCXCVRaBzCz0mfb+dVFP5hDYFdeX357dEcpuR7zK9c9Vf6977r3M7UzL
         Ystzk7iPQIPHwm7d2Hzk5w54/jx2eKXBbpGYYZRpAKblXoYWoRpNAk1T+DzEX5iIb1
         o26JozFQhAn7KXvfjlKonihY7EbqS+6wbWSiLc2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Arlott <simon@octiron.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/477] scsi: sr: Fix sr_probe() missing mutex_destroy
Date:   Tue, 23 Jun 2020 21:51:41 +0200
Message-Id: <20200623195412.508440198@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d2fe3fa470f95..8d062d4f3ce0b 100644
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



