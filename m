Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ECF13FFA7
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgAPXW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388757AbgAPXW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C650D20684;
        Thu, 16 Jan 2020 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216976;
        bh=v8+13b+Cd3htjOzD6R3jjLzCKwM/GVsqPfNVfB7J7WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laT5Ri9rkOO5RiJNoetBQasnz4bh6M72e83FCHBr/MtaAQebmWLyqeIIqX1gsUNCo
         Ulb4BWnRH9M2bnkcGy+uUunSu4q9I/DVpzuX/Uohp+xunnA21YiHgCTaU0Dec2gt0u
         435apyKnpFEop9zH+QT64hE/KVr2J95l/b3lPe8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 097/203] scsi: ufs: Give an unique ID to each ufs-bsg
Date:   Fri, 17 Jan 2020 00:16:54 +0100
Message-Id: <20200116231754.124146489@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

commit 8c850a0296004409e7bcb9464712fb2807da656a upstream.

Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an
unique ID by appending the scsi host number to its device name.

Link: https://lore.kernel.org/r/0101016eca8dc9d7-d24468d3-04d2-4ef3-a906-abe8b8cbcd3d-000000@us-west-2.amazonses.com
Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufs_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -202,7 +202,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	bsg_dev->parent = get_device(parent);
 	bsg_dev->release = ufs_bsg_node_release;
 
-	dev_set_name(bsg_dev, "ufs-bsg");
+	dev_set_name(bsg_dev, "ufs-bsg%u", shost->host_no);
 
 	ret = device_add(bsg_dev);
 	if (ret)


