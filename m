Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7F9200EB2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392008AbgFSPKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392005AbgFSPKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A8F206FA;
        Fri, 19 Jun 2020 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579417;
        bh=bOJZp4MY8yMotHM7SIxa+gP+l7ndwy2nMGpeBaSHfwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eop+5ZteeRSkASjEygUO0ukQEp4qxVH/BMQJJCnHYZHtcrw2yXxqfwaTChdOigXxn
         hoLXVq5P4xmmEt/WlHTxVWRta3LoilBtihYfYYUtkqvU3ILF3TI2cbFFgxrCP7AmwB
         5mbBJdWy0T82bXHFjFd3LA6iJkTMeKUDzPlwAkKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/261] media: cec: silence shift wrapping warning in __cec_s_log_addrs()
Date:   Fri, 19 Jun 2020 16:31:39 +0200
Message-Id: <20200619141654.102091639@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3b5af3171e2d5a73ae6f04965ed653d039904eb6 ]

The log_addrs->log_addr_type[i] value is a u8 which is controlled by
the user and comes from the ioctl.  If it's over 31 then that results in
undefined behavior (shift wrapping) and that leads to a Smatch static
checker warning.  We already cap the value later so we can silence the
warning just by re-ordering the existing checks.

I think the UBSan checker will also catch this bug at runtime and
generate a warning.  But otherwise the bug is harmless.

Fixes: 9881fe0ca187 ("[media] cec: add HDMI CEC framework (adapter)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-adap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index b14c09cd9593..06383b26712b 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1732,6 +1732,10 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		unsigned j;
 
 		log_addrs->log_addr[i] = CEC_LOG_ADDR_INVALID;
+		if (log_addrs->log_addr_type[i] > CEC_LOG_ADDR_TYPE_UNREGISTERED) {
+			dprintk(1, "unknown logical address type\n");
+			return -EINVAL;
+		}
 		if (type_mask & (1 << log_addrs->log_addr_type[i])) {
 			dprintk(1, "duplicate logical address type\n");
 			return -EINVAL;
@@ -1752,10 +1756,6 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 			dprintk(1, "invalid primary device type\n");
 			return -EINVAL;
 		}
-		if (log_addrs->log_addr_type[i] > CEC_LOG_ADDR_TYPE_UNREGISTERED) {
-			dprintk(1, "unknown logical address type\n");
-			return -EINVAL;
-		}
 		for (j = 0; j < feature_sz; j++) {
 			if ((features[j] & 0x80) == 0) {
 				if (op_is_dev_features)
-- 
2.25.1



