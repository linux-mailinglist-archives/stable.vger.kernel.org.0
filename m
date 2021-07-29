Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643113DA537
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhG2N7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238285AbhG2N6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81BD60F6F;
        Thu, 29 Jul 2021 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567095;
        bh=oruk/BqRssBIvqF3sA9W+md/ywlIw6OeWGOj+hoG1PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5HB+L1Bmnu+6wuu+dI7/OnLAv1E18dfJSmosOXfo2H5IU6CSEv6qxDvCPXpGWeqm
         x1ov9nt+8BCy7yngXMLmW8f0lEdikdv4QZ1/Ok2pey4Jo46+XbZrgtbjRdX6YTC+eh
         3K615TgibC4OoMRdDb2EXBhFuaTTLo/se30VpdlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/24] firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
Date:   Thu, 29 Jul 2021 15:54:38 +0200
Message-Id: <20210729135137.834179056@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7a691f16ccad05d770f813d9c4b4337a30c6d63f ]

The scmi_linux_errmap buffer access index is supposed to depend on the
array size to prevent element out of bounds access. It uses SCMI_ERR_MAX
to check bounds but that can mismatch with the array size. It also
changes the success into -EIO though scmi_linux_errmap is never used in
case of success, it is expected to work for success case too.

It is slightly confusing code as the negative of the error code
is used as index to the buffer. Fix it by negating it at the start and
make it more readable.

Link: https://lore.kernel.org/r/20210707135028.1869642-1-sudeep.holla@arm.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index af4560dab6b4..6fa024d1dd99 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -43,7 +43,6 @@ enum scmi_error_codes {
 	SCMI_ERR_GENERIC = -8,	/* Generic Error */
 	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
 	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
-	SCMI_ERR_MAX
 };
 
 /* List of all SCMI devices active in system */
@@ -118,8 +117,10 @@ static const int scmi_linux_errmap[] = {
 
 static inline int scmi_to_linux_errno(int errno)
 {
-	if (errno < SCMI_SUCCESS && errno > SCMI_ERR_MAX)
-		return scmi_linux_errmap[-errno];
+	int err_idx = -errno;
+
+	if (err_idx >= SCMI_SUCCESS && err_idx < ARRAY_SIZE(scmi_linux_errmap))
+		return scmi_linux_errmap[err_idx];
 	return -EIO;
 }
 
-- 
2.30.2



