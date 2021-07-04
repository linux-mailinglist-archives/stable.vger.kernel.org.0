Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C8E3BB30F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhGDXRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhGDXOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F063A61416;
        Sun,  4 Jul 2021 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440246;
        bh=37z3XHH9xjvhReLs/bGj/iV8WdTVclypy0jnbAomuwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTSaNV9DkjEAwS3ZV6ADwVq3uAZ4+8r9SlTtIuQ2q3dRmiPLX4fU2q6L8a+1GsE8g
         Jufoznrsqhy3rZvtD+K3UE1jpeze7Pl1eRKZIlh4u8jrDFW5/kw0076GoIoac1oQns
         YCBy2PRAdLf6l+k31z5ffB8fnsVO5lGuBQqR8uGF7isb8xhHyHGA0ctvUaQnnwxH++
         UYyqwclthXVbVOGJvTtkbKBbtcX4fIjv5jucQQpXqbA1QUht8pnkqdeo7eddf5mERr
         V2AeCaThEq1xJs+96cI6vx29Rf1tPm8qN4CMKE1FRSBGil/jNeWoDVfqL1ZQd+1efz
         nHvNgsGqDAonw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/31] media: s5p: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:10:14 -0400
Message-Id: <20210704231043.1491209-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit fdc34e82c0f968ac4c157bd3d8c299ebc24c9c63 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, check if the PM runtime error was caught at
s5p_cec_adap_enable().

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-cec/s5p_cec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 8837e2678bde..fe78292df8a6 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -39,10 +39,13 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
 
 static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
+	int ret;
 	struct s5p_cec_dev *cec = cec_get_drvdata(adap);
 
 	if (enable) {
-		pm_runtime_get_sync(cec->dev);
+		ret = pm_runtime_resume_and_get(cec->dev);
+		if (ret < 0)
+			return ret;
 
 		s5p_cec_reset(cec);
 
-- 
2.30.2

