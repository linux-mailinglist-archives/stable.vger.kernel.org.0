Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809AFD9EE9
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387879AbfJPWDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438497AbfJPV7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:25 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85114222C5;
        Wed, 16 Oct 2019 21:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263164;
        bh=/iJQzNXElDmKgwIE4nZvZC9laLfJRJJ8f7XcsOp9AWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO/ZYagQ6vWWLGqcA/h8hrBwliTXUmGAkmssGGX3s9dCuR1mcgpmXBLk0qZC27I6p
         rGwJfVhDcVKqb8yqN6JDA70rXxlauP+natsWzFNa3Mtng/54Lln3jv1pg/IJ/k9B4Q
         ppH1oYucLFetKIyJjnBhK5RqJJYanRrHlPXtk0/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adit Ranadive <aditr@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 092/112] RDMA/vmw_pvrdma: Free SRQ only once
Date:   Wed, 16 Oct 2019 14:51:24 -0700
Message-Id: <20191016214905.597203901@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adit Ranadive <aditr@vmware.com>

commit 18545e8b6871d21aa3386dc42867138da9948a33 upstream.

An extra kfree cleanup was missed since these are now deallocated by core.

Link: https://lore.kernel.org/r/1568848066-12449-1-git-send-email-aditr@vmware.com
Cc: <stable@vger.kernel.org>
Fixes: 68e326dea1db ("RDMA: Handle SRQ allocations by IB/core")
Signed-off-by: Adit Ranadive <aditr@vmware.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -230,8 +230,6 @@ static void pvrdma_free_srq(struct pvrdm
 
 	pvrdma_page_dir_cleanup(dev, &srq->pdir);
 
-	kfree(srq);
-
 	atomic_dec(&dev->num_srqs);
 }
 


