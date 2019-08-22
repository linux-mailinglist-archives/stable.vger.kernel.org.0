Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACAE99E02
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391408AbfHVRrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391428AbfHVRWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:41 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AEF32341B;
        Thu, 22 Aug 2019 17:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494560;
        bh=xOV+gfsvhKxuTMaRavsJgT56mMrub52ODkJUQy0F564=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ft0oN5yHbCabtStsfxmAd2pPCb4rqASqvQ48BDdnWbU6Soq6lKLvPtyW0zOwAkFW
         MTolQovBo6runb4vX2msKbHn36WCrbDfyjc6NWZRJTDLzO9ZGV20gFFGAz/7SmW0gB
         8l1IGYQlkDScZ1egjoMrDCo/v0UyeIRew7t8qbfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrin Jose T <jeffrin@rajagiritech.edu.in>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 48/78] libata: zpodd: Fix small read overflow in zpodd_get_mech_type()
Date:   Thu, 22 Aug 2019 10:18:52 -0700
Message-Id: <20190822171833.429785068@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 71d6c505b4d9e6f76586350450e785e3d452b346 ]

Jeffrin reported a KASAN issue:

  BUG: KASAN: global-out-of-bounds in ata_exec_internal_sg+0x50f/0xc70
  Read of size 16 at addr ffffffff91f41f80 by task scsi_eh_1/149
  ...
  The buggy address belongs to the variable:
    cdb.48319+0x0/0x40

Much like commit 18c9a99bce2a ("libata: zpodd: small read overflow in
eject_tray()"), this fixes a cdb[] buffer length, this time in
zpodd_get_mech_type():

We read from the cdb[] buffer in ata_exec_internal_sg(). It has to be
ATAPI_CDB_LEN (16) bytes long, but this buffer is only 12 bytes.

Reported-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Fixes: afe759511808c ("libata: identify and init ZPODD devices")
Link: https://lore.kernel.org/lkml/201907181423.E808958@keescook/
Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-zpodd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 7017a81d53cf2..083856272e92a 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -55,7 +55,7 @@ static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
 	unsigned int ret;
 	struct rm_feature_desc *desc;
 	struct ata_taskfile tf;
-	static const char cdb[] = {  GPCMD_GET_CONFIGURATION,
+	static const char cdb[ATAPI_CDB_LEN] = {  GPCMD_GET_CONFIGURATION,
 			2,      /* only 1 feature descriptor requested */
 			0, 3,   /* 3, removable medium feature */
 			0, 0, 0,/* reserved */
-- 
2.20.1



