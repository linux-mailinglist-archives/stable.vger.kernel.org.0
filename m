Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765741FCF43
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 16:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFQOPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 10:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgFQOPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 10:15:44 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BDFF207DD;
        Wed, 17 Jun 2020 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592403344;
        bh=cZ9rLHRSCMvYUTacBKpulUViRcf8ol8ccz9sF6lRIkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpR6Va/JM8pntwrhxC6AtX/r8X3GFuX9VnY34ZcyMbBq4Nxz3H0xYAuM9kTbA3/wP
         z+laxaBXpYtmi/tAgYgm07KkFV3DQJdw5BuS5fde6GX08FmEVR0rFbsKbG0wpuY33F
         h5tzaEBt+hB4bNcpCQVxNB7/iEC2faS63kYbULd4=
Date:   Wed, 17 Jun 2020 07:15:41 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     eduard@hasenleithner.at, sagi@grimberg.me, hch@lst.de,
        stable@vger.kernel.org, nirranjan@chelsio.com, bharat@chelsio.com
Subject: Re: [PATCH for-stable nvmet 0/6] nvme: Fix for blk_update_request IO
 error.
Message-ID: <20200617141541.GA712019@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611155339.9429-1-dakshaja@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 09:23:33PM +0530, Dakshaja Uppalapati wrote:
> The below error is seen in dmesg, while formatting the disks discovered on host.
> 
> dmesg:
>         [  636.733374] blk_update_request: I/O error, dev nvme4n1, sector 0 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
> 
> Patch 6 fixes it and there are 5 other dependent patches that also need to be 
> pulled from upstream to stable, 5.4 and 4.19 branches.
> 
> Patch 1 dependent patch
> 
> Patch 2 dependent patch
> 
> Patch 3 dependent patch
> 
> Patch 4 dependent patch
> 
> Patch 5 dependent patch
> 
> Patch 6 fix patch

1. You need to copy the linux-nvme mainling list for linux nvme kernel patches.

2. If you're sending someone else's patch, the patch is supposed to have
the From: tag so the author is appropriately identified.

3. Stable patches must referece the upstream commit ID.

As for this particular issue, while stable patches are required to
reference an upstream commit, you don't need to bring in dependent
patches. You are allowed to write an equivalent fix specific to the
stable branch so that stable doesn't need to take a bunch of unrelated
changes. For example, it looks like this particular isssue can be fixed
with the following simple stable patch:

---
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 1096dd01ca22..9399e23e69c3 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -234,8 +234,8 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 		return 0;
 	case nvme_cmd_dsm:
 		req->execute = nvmet_bdev_execute_dsm;
-		req->data_len = (le32_to_cpu(cmd->dsm.nr) + 1) *
-			sizeof(struct nvme_dsm_range);
+		req->data_len = max((le32_to_cpu(cmd->dsm.nr) + 1) *
+			sizeof(struct nvme_dsm_range), req->transfer_len);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_bdev_execute_write_zeroes;
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 39d972e2595f..f2fa6482d6dd 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -332,8 +332,8 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 		return 0;
 	case nvme_cmd_dsm:
 		req->execute = nvmet_file_execute_dsm;
-		req->data_len = (le32_to_cpu(cmd->dsm.nr) + 1) *
-			sizeof(struct nvme_dsm_range);
+		req->data_len = max((le32_to_cpu(cmd->dsm.nr) + 1) *
+			sizeof(struct nvme_dsm_range), req->transfer_len);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_file_execute_write_zeroes;
--
