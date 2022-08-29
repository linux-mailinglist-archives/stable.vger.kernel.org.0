Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002595A4A96
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiH2Ln3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiH2LnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B736C85AA7;
        Mon, 29 Aug 2022 04:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DCEC611D7;
        Mon, 29 Aug 2022 11:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4535FC433C1;
        Mon, 29 Aug 2022 11:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771979;
        bh=4WjlWH8J126wrlHjO6n2BS/x3Mg6Ty1H/2N1ZLuMDIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZe8b8D08L8p0Z2p/UJLqWX1znryL83L+08TK4qCzrqQYTdECCPQy2xHF6uDBpP1j
         Hr0GctG3vcdrjolTOgp8wiQkrT0ntcz3LQ8a+5TklyZDrA+Hr44tO4KLgozeBbJk1B
         ix6jeXP+5lRN8ndq8qxuz6KW02zS3saF72zfOKpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 153/158] scsi: core: Fix passthrough retry counter handling
Date:   Mon, 29 Aug 2022 13:00:03 +0200
Message-Id: <20220829105815.534215031@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

commit fac8e558da9485e13a0ae0488aa0b8a8c307cd34 upstream.

Passthrough users will set the scsi_cmnd->allowed value and were expecting
up to $allowed retries. The problem is that before:

commit 6aded12b10e0 ("scsi: core: Remove struct scsi_request")

we used to set the retries on the scsi_request then copy them over to
scsi_cmnd->allowed in scsi_setup_scsi_cmnd. With that patch we now set
scsi_cmnd->allowed to 0 in scsi_prepare_cmd and overwrite what the
passthrough user set.

This moves the allowed initialization to after the blk_rq_is_passthrough()
check so it's only done for the non-passthrough path where the ULD
init_command will normally set an allowed value it prefers.

Link: https://lore.kernel.org/r/20220812011206.9157-1-michael.christie@oracle.com
Fixes: 6aded12b10e0 ("scsi: core: Remove struct scsi_request")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1549,7 +1549,6 @@ static blk_status_t scsi_prepare_cmd(str
 	scsi_init_command(sdev, cmd);
 
 	cmd->eh_eflags = 0;
-	cmd->allowed = 0;
 	cmd->prot_type = 0;
 	cmd->prot_flags = 0;
 	cmd->submitter = 0;
@@ -1600,6 +1599,8 @@ static blk_status_t scsi_prepare_cmd(str
 			return ret;
 	}
 
+	/* Usually overridden by the ULP */
+	cmd->allowed = 0;
 	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }


