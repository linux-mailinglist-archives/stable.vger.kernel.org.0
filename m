Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363C91D6E27
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 01:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgEQX4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 19:56:22 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15209 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgEQX4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 19:56:22 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec1ced80000>; Sun, 17 May 2020 16:55:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 17 May 2020 16:56:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 17 May 2020 16:56:22 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 17 May
 2020 23:56:21 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 17 May 2020 23:56:21 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.48.175]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ec1cf250001>; Sun, 17 May 2020 16:56:21 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     John Hubbard <jhubbard@nvidia.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-media@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] rapidio: fix an error in get_user_pages_fast() error handling
Date:   Sun, 17 May 2020 16:56:19 -0700
Message-ID: <20200517235620.205225-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200517235620.205225-1-jhubbard@nvidia.com>
References: <20200517235620.205225-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589759704; bh=/caTfybzk6G8zCAwE/wUhpELjA48X6aFYrwn8ihzqac=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=dmu8XjIpWdlFyVyCLNuEEDWxs3IKVzKyvRAL4FwJTpqxQE6JVIUMLgNPyzRJjKFhp
         EWzhzIg07dcjnuLMAV18Y48JC2BF6mKHnNrXuM9BcGCHDmTkprjgazysiwJnPr6paU
         dIsibGJQIs7Jst04M2DTx6ot+HxZfrM7Nt8zovjQk+Ua17VwpMJjWoXZl43m0lrIpK
         jXb/dElldN9iDmH8iuuGkLT5kC9ndZuZ6hYBi3gDVhcDj9J3pz16B4z+83gyiRnZBT
         kIiEstjnTRbetP6lnvytfWmEkuePv3Jqixpb4XI8Vuk/0usrpbdnPY8qB0BLNi8khs
         ffU4GgzyT4x4g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the case of get_user_pages_fast() returning fewer pages than
requested, rio_dma_transfer() does not quite do the right thing.
It attempts to release all the pages that were requested, rather
than just the pages that were pinned.

Fix the error handling so that only the pages that were successfully
pinned are released.

Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/dev=
ices/rio_mport_cdev.c
index 8155f59ece38..10af330153b5 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -877,6 +877,11 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
 				rmcd_error("pinned %ld out of %ld pages",
 					   pinned, nr_pages);
 			ret =3D -EFAULT;
+			/*
+			 * Set nr_pages up to mean "how many pages to unpin, in
+			 * the error handler:
+			 */
+			nr_pages =3D pinned;
 			goto err_pg;
 		}
=20
--=20
2.26.2

