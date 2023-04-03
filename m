Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE96D4A62
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbjDCOqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbjDCOqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E097280C4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 181A861EFB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A21AC4339C;
        Mon,  3 Apr 2023 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533171;
        bh=Ia9vvw6uzgqyM9awMM8KJIvAZ/jNkNzpPj20+akxcr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOaiXLJ2CydNfWwGmFci3/E+CyuISp+qg8SsY9UfdaG1JjxvMZX3BHprNBzU7o+Nr
         Lp4UENf7ZCtuvZfbDwdRuaUhmrFk3O+qiDULAY77y10SGyutvhlzHiatQHqRdvcPWv
         iv7FdV2qLzhmzuvTUClojnlPOdFNF0gZxUzOsjXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 080/187] scsi: mpt3sas: Dont print sense pool info twice
Date:   Mon,  3 Apr 2023 16:08:45 +0200
Message-Id: <20230403140418.598630071@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit d684a7a26f7d2c7122a4581ac966ed64e88fb29c ]

_base_allocate_sense_dma_pool() already prints out the sense pool
information, so don't print it a second time after calling it in
_base_allocate_memory_pools(). In addition the version in
_base_allocate_memory_pools() was using the wrong size value, sz, which was
last assigned when doing some nvme calculations instead of sense_sz to
determine the pool size in kilobytes.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Fixes: 970ac2bb70e7 ("scsi: mpt3sas: Force sense buffer allocations to be within same 4 GB region")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20230324193204.567932-1-jsnitsel@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2ee9ea57554d7..14ae0a9c5d3d8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6616,11 +6616,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	else if (rc == -EAGAIN)
 		goto try_32bit_dma;
 	total_sz += sense_sz;
-	ioc_info(ioc,
-	    "sense pool(0x%p)- dma(0x%llx): depth(%d),"
-	    "element_size(%d), pool_size(%d kB)\n",
-	    ioc->sense, (unsigned long long)ioc->sense_dma, ioc->scsiio_depth,
-	    SCSI_SENSE_BUFFERSIZE, sz / 1024);
 	/* reply pool, 4 byte align */
 	sz = ioc->reply_free_queue_depth * ioc->reply_sz;
 	rc = _base_allocate_reply_pool(ioc, sz);
-- 
2.39.2



