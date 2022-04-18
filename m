Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AC4505632
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242222AbiDRNch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244859AbiDRNa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C291EEC9;
        Mon, 18 Apr 2022 05:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4376115A;
        Mon, 18 Apr 2022 12:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA13C385A1;
        Mon, 18 Apr 2022 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286584;
        bh=fg5zFCcA8CyEjfMuNxKCF1EzV/gKnpC9HIKp+iAn9D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyQ8Y31c5zxm090HR+TL6eRu3v2zfrQXumxY1HEWVWePWQm2s31k/N3+AfOpemQqC
         iGNjgMCGveB289/uUS3lfXvW4wdk+LNlpM99UPVMaKP8I/cOHEc771N9CQmspxJ1Ca
         KnzwkQwaA6L+yi9BgWVDTYAvEoLwAHb0LfKMkLb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 182/284] scsi: qla2xxx: Fix warning for missing error code
Date:   Mon, 18 Apr 2022 14:12:43 +0200
Message-Id: <20220418121216.912614105@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

commit 14cb838d245ae0d523b2f7804af5a02c22e79f5a upstream.

Fix smatch-reported warning message:

drivers/scsi/qla2xxx/qla_target.c:3324 qlt_xmit_response() warn: missing error
code 'res'

Link: https://lore.kernel.org/r/20220110050218.3958-12-njavali@marvell.com
Fixes: 4a8f71014b4d ("scsi: qla2xxx: Fix unmap of already freed sgl")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3095,6 +3095,7 @@ int qlt_xmit_response(struct qla_tgt_cmd
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
+		res = 0;
 		goto out_unmap_unlock;
 	}
 


