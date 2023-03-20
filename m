Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE06C181D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjCTPUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjCTPT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB19B2721
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:14:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C446B80ED7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABA4C4339C;
        Mon, 20 Mar 2023 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325240;
        bh=w/EVluFcOFBdtYa+rB/fHuaoQlj8JQPiqBjehzQCaek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrSSZWvSvubURpCSZhTFpXgXfPAPcyFtKR7HjRomt00GJc4zBT4JoAql7Re2zoeQf
         QERioTowKEsZmNhyDIvva7FpHN6kPTNycAkrSJqONVc9AfOZHWNsTu7HKUj+p+t10U
         z21pz73oOKNNRee3OAg+xFoDiqK6HYAQNAyAuKKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 020/211] scsi: mpi3mr: Fix sas_hba.phy memory leak in mpi3mr_remove()
Date:   Mon, 20 Mar 2023 15:52:35 +0100
Message-Id: <20230320145514.147522617@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit d4caa1a4255cc44be56bcab3db2c97c632e6cc10 ]

Free mrioc->sas_hba.phy at .remove.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-5-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5032b0b5186d4..5698e7b90f852 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5127,6 +5127,12 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	}
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 
+	if (mrioc->sas_hba.num_phys) {
+		kfree(mrioc->sas_hba.phy);
+		mrioc->sas_hba.phy = NULL;
+		mrioc->sas_hba.num_phys = 0;
+	}
+
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
-- 
2.39.2



