Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB00C4BE59E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349572AbiBUJ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:29:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349552AbiBUJ2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:28:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ECF23BC8;
        Mon, 21 Feb 2022 01:12:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F22DC60F03;
        Mon, 21 Feb 2022 09:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0234C340F6;
        Mon, 21 Feb 2022 09:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434772;
        bh=kV6xglYVzvEJRVFFxgMI+g9s28ikqyFntAQqvUpyTfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/WULOFWvVACD42jztr2kj5167CRQZvo/XDxlcRZLrBvau/X59Ba5hzbP3tFYO/72
         9d6cbpbbV9fPZRamGg4L4D6LLxc/al5Ol5qKgT7kLkQ0CUEzKJnngidb3aXxSUvyMV
         30z+sE7Z9tAp5I0myvmVFWPc0hcuquPTpK1N+MlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 126/196] scsi: ufs: Remove dead code
Date:   Mon, 21 Feb 2022 09:49:18 +0100
Message-Id: <20220221084935.150484212@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Bart Van Assche <bvanassche@acm.org>

commit d77ea8226b3be23b0b45aa42851243b62a27bda1 upstream.

Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
conflicts") guarantees that 'tag' is not in use by any SCSI command.
Remove the check that returns early if a conflict occurs.

Link: https://lore.kernel.org/r/20211203231950.193369-6-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6658,11 +6658,6 @@ static int ufshcd_issue_devman_upiu_cmd(
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
@@ -6730,8 +6725,8 @@ static int ufshcd_issue_devman_upiu_cmd(
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-out:
 	blk_put_request(req);
+
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;


