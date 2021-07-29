Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA14C3DA562
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbhG2OBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238558AbhG2N7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE2061052;
        Thu, 29 Jul 2021 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567151;
        bh=XOnHq33KEr7BZjl/ew9RZQkNJP4/vtPq5B3kqmwlO/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpW0LYX2sgTTWHQRB4K9vXhheyFEbdF3sZQV0WSaWvcqnvrOYDW5slKIgy8mgCnSL
         QNR0wpnjfn4/tTFrjENLPw/oz5IXuMdHn0o3SMLb/pP2kRcwIfg6k5SAxSp1Og9fDR
         I05IryXjGVkjTmXNHf/APO03WwjTtF0mzQDIZsXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 16/22] firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
Date:   Thu, 29 Jul 2021 15:54:47 +0200
Message-Id: <20210729135137.847496226@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
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
index 74986bf96656..6bff4cceb3c3 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -47,7 +47,6 @@ enum scmi_error_codes {
 	SCMI_ERR_GENERIC = -8,	/* Generic Error */
 	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
 	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
-	SCMI_ERR_MAX
 };
 
 /* List of all SCMI devices active in system */
@@ -166,8 +165,10 @@ static const int scmi_linux_errmap[] = {
 
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



