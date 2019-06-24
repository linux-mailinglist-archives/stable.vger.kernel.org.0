Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A8350771
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbfFXKHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730255AbfFXKHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:06 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A022E214DA;
        Mon, 24 Jun 2019 10:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370825;
        bh=Xob4prRYpzGNCy0BfQoNaMaioIygswDmCuiakzquiK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FypKb7s32FSqa6AF2dAsWlEt/5V3GDEfgMxbAwb7tpDwFPAu5Jybaw5EGQCUcnXvd
         neF7XwJ9BGTtQEHNXRenm/rq1Shy4zvvCFaHSQlfvXmGyrrOiIgCE3AGOL7j/RQj4s
         JB/Rc58nICJGA8E+Mwu7RRLmqp8sk7ecDO5t7+48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.1 015/121] IB/hfi1: Validate fault injection opcode user input
Date:   Mon, 24 Jun 2019 17:55:47 +0800
Message-Id: <20190624092321.411704799@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 5f90677ed31963abb184ee08ebee4a4a68225dd8 upstream.

The opcode range for fault injection from user should be validated before
it is applied to the fault->opcodes[] bitmap to avoid out-of-bound
error.

Cc: <stable@vger.kernel.org>
Fixes: a74d5307caba ("IB/hfi1: Rework fault injection machinery")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/fault.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -153,6 +153,7 @@ static ssize_t fault_opcodes_write(struc
 		char *dash;
 		unsigned long range_start, range_end, i;
 		bool remove = false;
+		unsigned long bound = 1U << BITS_PER_BYTE;
 
 		end = strchr(ptr, ',');
 		if (end)
@@ -178,6 +179,10 @@ static ssize_t fault_opcodes_write(struc
 				    BITS_PER_BYTE);
 			break;
 		}
+		/* Check the inputs */
+		if (range_start >= bound || range_end >= bound)
+			break;
+
 		for (i = range_start; i <= range_end; i++) {
 			if (remove)
 				clear_bit(i, fault->opcodes);


