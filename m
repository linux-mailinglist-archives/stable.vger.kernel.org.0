Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEE610BFD5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfK0Vp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbfK0Ue6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72857215F1;
        Wed, 27 Nov 2019 20:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886897;
        bh=MmcJ9yyJiqzSZ3u8XL93f5OPWh7yjOKwUHGqn3LdkBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oy/8NSn5zj5gvKg0k5Q0MOI+9iq3kCqmURkJ4yQcfsKhU0+1wLdoN8yIRRGnWC4UR
         HG6S/q5LrvU/ascTEM5qLfYorpVJp717r6T58CeeJsJ9iYE+awBUa6xlAQYh5vyjxI
         7r/KwImRJp+XxBKt0BAqYQqxlSzQtPMybnnLZVzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 036/132] scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler
Date:   Wed, 27 Nov 2019 21:30:27 +0100
Message-Id: <20191127202930.898119175@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit e9e9a103528c7e199ead6e5374c9c52cf16b5802 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/scsi/isci/request.c:1629:13: warning: implicit conversion from
enumeration type 'enum sci_io_status' to different enumeration type
'enum sci_status' [-Wenum-conversion]
                        status = SCI_IO_FAILURE_RESPONSE_VALID;
                               ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/isci/request.c:1631:12: warning: implicit conversion from
enumeration type 'enum sci_io_status' to different enumeration type
'enum sci_status' [-Wenum-conversion]
                status = SCI_IO_FAILURE_RESPONSE_VALID;
                       ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

status is of type sci_status but SCI_IO_FAILURE_RESPONSE_VALID is of
type sci_io_status. Use SCI_FAILURE_IO_RESPONSE_VALID, which is from
sci_status and has SCI_IO_FAILURE_RESPONSE_VALID's exact value since
that is what SCI_IO_FAILURE_RESPONSE_VALID is mapped to in the isci.h
file.

Link: https://github.com/ClangBuiltLinux/linux/issues/153
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index cfd0084f1cd2b..224c9c60834cd 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1626,9 +1626,9 @@ static enum sci_status atapi_d2h_reg_frame_handler(struct isci_request *ireq,
 
 	if (status == SCI_SUCCESS) {
 		if (ireq->stp.rsp.status & ATA_ERR)
-			status = SCI_IO_FAILURE_RESPONSE_VALID;
+			status = SCI_FAILURE_IO_RESPONSE_VALID;
 	} else {
-		status = SCI_IO_FAILURE_RESPONSE_VALID;
+		status = SCI_FAILURE_IO_RESPONSE_VALID;
 	}
 
 	if (status != SCI_SUCCESS) {
-- 
2.20.1



