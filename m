Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD205FDF7A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJMRyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJMRyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:54:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7266153817;
        Thu, 13 Oct 2022 10:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 633D6B82025;
        Thu, 13 Oct 2022 17:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7FAC433C1;
        Thu, 13 Oct 2022 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683605;
        bh=noRvJC0nVSYY32afoEmpgXwbaIEjxRMiF+BbGEX269k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wG67tqKxeI2/D3k3e/8VSsvN2nW8QEnk7CXXCgp1x1+dHVvJsD1fi0Xb9ssgClANC
         5LqEUh8GTSQjcx8c9xBNDrVdy+aQY5fidF32Rmuj1S+yPEON4j7WDUsRlMfUI50Xkh
         BTbMOPkJ6fX55QsJFnsacTIgYdw0l3rfVVZjxY5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        hdthky <hdthky0@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 25/38] scsi: stex: Properly zero out the passthrough command structure
Date:   Thu, 13 Oct 2022 19:52:26 +0200
Message-Id: <20221013175145.100366344@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6022f210461fef67e6e676fd8544ca02d1bcfa7a upstream.

The passthrough structure is declared off of the stack, so it needs to be
set to zero before copied back to userspace to prevent any unintentional
data leakage.  Switch things to be statically allocated which will fill the
unused fields with 0 automatically.

Link: https://lore.kernel.org/r/YxrjN3OOw2HHl9tx@kroah.com
Cc: stable@kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: hdthky <hdthky0@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/stex.c      |   17 +++++++++--------
 include/scsi/scsi_cmnd.h |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -668,16 +668,17 @@ stex_queuecommand_lck(struct scsi_cmnd *
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
-			struct st_drvver ver;
+			const struct st_drvver ver = {
+				.major = ST_VER_MAJOR,
+				.minor = ST_VER_MINOR,
+				.oem = ST_OEM,
+				.build = ST_BUILD_VER,
+				.signature[0] = PASSTHRU_SIGNATURE,
+				.console_id = host->max_id - 1,
+				.host_no = hba->host->host_no,
+			};
 			size_t cp_len = sizeof(ver);
 
-			ver.major = ST_VER_MAJOR;
-			ver.minor = ST_VER_MINOR;
-			ver.oem = ST_OEM;
-			ver.build = ST_BUILD_VER;
-			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = host->max_id - 1;
-			ver.host_no = hba->host->host_no;
 			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
 			cmd->result = sizeof(ver) == cp_len ?
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -204,7 +204,7 @@ static inline int scsi_get_resid(struct
 	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
 
 static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
-					   void *buf, int buflen)
+					   const void *buf, int buflen)
 {
 	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
 				   buf, buflen);


