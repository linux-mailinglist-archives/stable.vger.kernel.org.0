Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957E4541A06
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379135AbiFGV1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380147AbiFGV01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F44922872B;
        Tue,  7 Jun 2022 12:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11EDF617E1;
        Tue,  7 Jun 2022 19:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBE4C34115;
        Tue,  7 Jun 2022 19:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628512;
        bh=w+MagUlKTRVQeduCnzXsbmwB37LA3qchQOIHBHtTyP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crnfDhmT7LwRNDrDw6mCwsUIvQkBk8YUc66LHGmEbxJys9S6bIZ4vQU9wNsNEEMEp
         SZVkT9Rwt6MLsARCEnQNy5bJNTPbVWIHQMlXSVUmPEkLMH+1aVT0iCCLAq5KxjL7dn
         cvwyKhaOA8yHKcGPRMB0aJWDixOQ7zFh5EJzZsUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 355/879] scsi: iscsi: Fix harmless double shift bug
Date:   Tue,  7 Jun 2022 18:57:53 +0200
Message-Id: <20220607165013.167730718@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 565138ac5f8a5330669a20e5f94759764e9165ec ]

These flags are supposed to be bit numbers.  Right now they cause a double
shift bug where we use BIT(BIT(2)) instead of BIT(2).  Fortunately, the bit
numbers are small and it's done consistently so it does not cause an issue
at run time.

Link: https://lore.kernel.org/r/YmFyWHf8nrrx+SHa@kili
Fixes: 5bd856256f8c ("scsi: iscsi: Merge suspend fields")
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/libiscsi.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d0a24779c52d..c0703cd20a99 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -54,9 +54,9 @@ enum {
 #define ISID_SIZE			6
 
 /* Connection flags */
-#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
-#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
-#define ISCSI_CONN_FLAG_BOUND		BIT(2)
+#define ISCSI_CONN_FLAG_SUSPEND_TX	0
+#define ISCSI_CONN_FLAG_SUSPEND_RX	1
+#define ISCSI_CONN_FLAG_BOUND		2
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
-- 
2.35.1



