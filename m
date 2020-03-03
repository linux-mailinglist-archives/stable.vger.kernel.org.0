Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B71176C08
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgCCCt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgCCCt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7925D246D5;
        Tue,  3 Mar 2020 02:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203766;
        bh=RMTGr3uER+/FS+YWZ/Knhm57es+YuOsOFMRZAznwVdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLOKnKa0JXbXF/QIPVjzvPa6hHybm3Br7nsJlchOZPmMmpGpkRNJSKpopxPE2M0RL
         DkqhEBUdvSShA3G+wohEtt8skofzKh7hu2Jt8R/86LJFH1a+CvRN88XiUAPvMcNvIf
         aLsbatDAp9jIM37GDrfhmjtLQk3a7vaBFzZf/fpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 27/32] nvme: Fix uninitialized-variable warning
Date:   Mon,  2 Mar 2020 21:48:46 -0500
Message-Id: <20200303024851.10054-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 15755854d53b4bbb0bb37a0fce66f0156cfc8a17 ]

gcc may detect a false positive on nvme using an unintialized variable
if setting features fails. Since this is not a fast path, explicitly
initialize this variable to suppress the warning.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f41fd15b7b7c2..a8132e8d72bb4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1058,8 +1058,8 @@ static struct nvme_id_ns *nvme_identify_ns(struct nvme_ctrl *ctrl,
 static int nvme_set_features(struct nvme_ctrl *dev, unsigned fid, unsigned dword11,
 		      void *buffer, size_t buflen, u32 *result)
 {
+	union nvme_result res = { 0 };
 	struct nvme_command c;
-	union nvme_result res;
 	int ret;
 
 	memset(&c, 0, sizeof(c));
-- 
2.20.1

