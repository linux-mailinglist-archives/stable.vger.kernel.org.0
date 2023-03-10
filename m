Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0AC6B423D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjCJOBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjCJOBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:01:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E0114EF4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF90CB822C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7EAC4339B;
        Fri, 10 Mar 2023 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456856;
        bh=bm2WJ1roVdn9VBIkoVkk3KE1nkq8Xz3lJOvX4cwpvjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGEgmMMOFPxMR58NjXdbvd6sy98l8pLmsUZpTIH12Jo+xNDBwZxl1POhRR7cnYCoF
         eSH58O49TZpRbKnhOwN83w3dj1JaUsybm8aMMZG+4aVSBLLb2FAnqgGdCs3w3Ibmnb
         jc94wwLt+8zutiDCZndpNbqBKw5XPzU3t/fgK5rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 108/211] scsi: mpi3mr: Fix an issue found by KASAN
Date:   Fri, 10 Mar 2023 14:38:08 +0100
Message-Id: <20230310133722.040765188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit ae7d45f5283d30274039b95d3e6d53d33c66e991 ]

Write only correct size (32 instead of 64 bytes).

Link: https://lore.kernel.org/r/20230213193752.6859-1-thenzl@redhat.com
Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3fc897336b5e0..3b61815979dab 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1280,7 +1280,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 	if (mrioc->sas_hba.enclosure_handle) {
 		if (!(mpi3mr_cfg_get_enclosure_pg0(mrioc, &ioc_status,
-		    &encl_pg0, sizeof(dev_pg0),
+		    &encl_pg0, sizeof(encl_pg0),
 		    MPI3_ENCLOS_PGAD_FORM_HANDLE,
 		    mrioc->sas_hba.enclosure_handle)) &&
 		    (ioc_status == MPI3_IOCSTATUS_SUCCESS))
-- 
2.39.2



