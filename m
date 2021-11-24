Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1345C0B1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245586AbhKXNKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348378AbhKXNJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 206126124F;
        Wed, 24 Nov 2021 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757628;
        bh=0Yvkc9CjRcWzbtFqkI5TOzKmnag491/csDOKwWvB6zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYtFq7wV1FwMOBdg5hwODmCPLelu4QFoczvcXMw3f3TIwVX9njhnRyQ9QFqhLas28
         m8FolfS4xK2bmPjjoozERo5nSd5ei0/dzukTnyXJlJPwr1JKXoehcEeIV4BHWWpNNg
         S9owq/jPo2c+H7pEk/+0Y0YMygDEws9YQAbI5U6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/323] scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
Date:   Wed, 24 Nov 2021 12:56:22 +0100
Message-Id: <20211124115725.423489633@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index a8e29e3d35726..98944fb3f0b85 100644
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



