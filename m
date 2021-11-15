Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64ED4511A7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbhKOTMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244123AbhKOTKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A911F60231;
        Mon, 15 Nov 2021 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000328;
        bh=xdEyeh42BxXPB41NBdisx1lK3QAfQdkGC4Brr9+jr3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsckS0IXUGtEI6xH1mBF9/QRB98pu5uayK6mJBlXkl8lJE/OrOF9hczz6TUccasRS
         hhR2VStG2wZMnC+kN3dic26H/hbRt77Q81ght9VGU6/Q0yKIhFF902Cz3qPle/u7TG
         UMaBZ2iJ6C14Fgjq2cz46EwKvZenolf9KsoZ7k3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 603/849] scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
Date:   Mon, 15 Nov 2021 18:01:26 +0100
Message-Id: <20211115165440.652014225@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f4875d509a0a78ad294a1a538d534b5ba94e685a ]

This variable is just a temporary variable, used to do an endian
conversion.  The problem is that the last byte is not initialized.  After
the conversion is completely done, the last byte is discarded so it doesn't
cause a problem.  But static checkers and the KMSan runtime checker can
detect the uninitialized read and will complain about it.

Link: https://lore.kernel.org/r/20211006073242.GA8404@kili
Fixes: 5036f0a0ecd3 ("[SCSI] csiostor: Fix sparse warnings.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index dc98f51f466fb..d5ac938970232 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -619,7 +619,7 @@ csio_ln_vnp_read_cbfn(struct csio_hw *hw, struct csio_mb *mbp)
 	struct fc_els_csp *csp;
 	struct fc_els_cssp *clsp;
 	enum fw_retval retval;
-	__be32 nport_id;
+	__be32 nport_id = 0;
 
 	retval = FW_CMD_RETVAL_G(ntohl(rsp->alloc_to_len16));
 	if (retval != FW_SUCCESS) {
-- 
2.33.0



