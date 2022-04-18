Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10985050DF
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiDRM3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239710AbiDRM2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:28:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D09201A9;
        Mon, 18 Apr 2022 05:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C998EB80EC4;
        Mon, 18 Apr 2022 12:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A730C385A1;
        Mon, 18 Apr 2022 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284542;
        bh=+Xd3EYsE54NRnjPktOTOQq1qGWDsUlebxiZdA2bq+tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbMdng3lnVxpi7LIxW93Q5OhOjXPZ9dFrIjTf3ULagwDH8BCWQggGvdkhnXjYU4tv
         ZTm1ElMEujdZFoEM2VQrgCENUH1AQYTP+UP5TcAQP/ZmYuGbHSopf7O2/suJxrBtek
         3XBGRAIJp6P5Ldl7Hr7XVKhxrIka1cfEpq3jdWeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 149/219] scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024
Date:   Mon, 18 Apr 2022 14:11:58 +0200
Message-Id: <20220418121211.058527039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 0bade8e53279157c7cc9dd95d573b7e82223d78a ]

The adapter request_limit is hardcoded to be INITIAL_SRP_LIMIT which is
currently an arbitrary value of 800. Increase this value to 1024 which
better matches the characteristics of the typical IBMi Initiator that
supports 32 LUNs and a queue depth of 32.

This change also has the secondary benefit of being a power of two as
required by the kfifo API. Since, Commit ab9bb6318b09 ("Partially revert
"kfifo: fix kfifo_alloc() and kfifo_init()"") the size of IU pool for each
target has been rounded down to 512 when attempting to kfifo_init() those
pools with the current request_limit size of 800.

Link: https://lore.kernel.org/r/20220322194443.678433-1-tyreld@linux.ibm.com
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f06f6885a5..89b9fbce7488 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -36,7 +36,7 @@
 
 #define IBMVSCSIS_VERSION	"v0.2"
 
-#define	INITIAL_SRP_LIMIT	800
+#define	INITIAL_SRP_LIMIT	1024
 #define	DEFAULT_MAX_SECTORS	256
 #define MAX_TXU			1024 * 1024
 
-- 
2.35.1



