Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0A65920A2
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbiHNP3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbiHNP2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:28:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685D2AE7A;
        Sun, 14 Aug 2022 08:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C0360C05;
        Sun, 14 Aug 2022 15:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD36C433D7;
        Sun, 14 Aug 2022 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490920;
        bh=mr9tRLqQ8X+aGtXimse11oHRXOJPJJGTmgtdeuO+DJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rY/r9FrvBaySEajKV7KlfNFD1OUkXpaCvUdIvASZBHchpQXkK6QbTqudehEWcvzOC
         m/mBPR1OjsKsM46RVbIHs1JyPtiND9FZw6DrmA4GhG0XK+JxGdJUd4uMcGSQTaXgfa
         c3sd647nfj4B9yHX/6MIowq/ATSLJ54yXMBondqnmCJxgfgkm4hFvaJ0Ck6srZZ5CR
         WUx2EJtDda17a4DveeTnOimAOfeBKqACX2vRberNsj8cS0T2IYsmevWVp+yj3T2Pj3
         3ESZ8vRI4kUFZ0D6YfOsmG1gYxWKnb9SFTOzn/mEYPUlXT/sGWav3+ZYeAfMkasQzW
         +aV1HMoDpcv1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, cleech@redhat.com,
        jejb@linux.ibm.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 22/64] scsi: iscsi: Fix HW conn removal use after free
Date:   Sun, 14 Aug 2022 11:23:55 -0400
Message-Id: <20220814152437.2374207-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e ]

If qla4xxx doesn't remove the connection before the session, the iSCSI
class tries to remove the connection for it. We were doing a
iscsi_put_conn() in the iter function which is not needed and will result
in a use after free because iscsi_remove_conn() will free the connection.

Link: https://lore.kernel.org/r/20220616222738.5722-2-michael.christie@oracle.com
Tested-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5d21f07456c6..6e73f14b9749 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2143,8 +2143,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
-	iscsi_put_conn(iscsi_dev_to_conn(dev));
-
 	return 0;
 }
 
-- 
2.35.1

