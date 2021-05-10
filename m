Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AD4378884
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhEJLVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237150AbhEJLL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2093461874;
        Mon, 10 May 2021 11:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644859;
        bh=Ai/Iihhwz8TIr9UK4qChdwmv+rUHq3whMCkx6XhD7pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFARoJlWlmo9iJHvKD5EcW1Nq9VVmy7DgzGmmTyRduOg4Yz0l8y0IfOXFNluPgKlf
         Eqd/L0xelyxWkRl99KWrhS6uk3YCWq9/U2zwos24PxvUaBUqSlJHDKlCbk1rc86W77
         U+RGoSRRuB9OtFnBaOD85roPzkfjme+QHG81LeUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 253/384] scsi: mpt3sas: Fix out-of-bounds warnings in _ctl_addnl_diag_query
Date:   Mon, 10 May 2021 12:20:42 +0200
Message-Id: <20210510102023.220390408@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 16660db3fc2af8664af5e0a3cac69c4a54bfb794 ]

Fix the following out-of-bounds warnings by embedding existing struct
htb_rel_query into struct mpt3_addnl_diag_query, instead of duplicating its
members:

include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [19, 32] from the object at 'karg' is out of the bounds of referenced subobject 'buffer_rel_condition' with type 'short unsigned int' at offset 16 [-Warray-bounds]
include/linux/fortify-string.h:22:29: warning: '__builtin_memset' offset [19, 32] from the object at 'karg' is out of the bounds of referenced subobject 'buffer_rel_condition' with type 'short unsigned int' at offset 16 [-Warray-bounds]

The problem is that the original code is trying to copy data into a bunch
of struct members adjacent to each other in a single call to memcpy(). All
those members are exactly the same contained in struct htb_rel_query, so
instead of duplicating them into struct mpt3_addnl_diag_query, replace them
with new member rel_query of type struct htb_rel_query. So, now that this
new object is introduced, memcpy() doesn't overrun the length of
&karg.buffer_rel_condition, because the address of the new struct object
_rel_query_ is used as destination, instead. The same issue is present when
calling memset(), and it is fixed with this same approach.

Below is a comparison of struct mpt3_addnl_diag_query, before and after
this change (the size and cachelines remain the same):

$ pahole -C mpt3_addnl_diag_query drivers/scsi/mpt3sas/mpt3sas_ctl.o
struct mpt3_addnl_diag_query {
	struct mpt3_ioctl_header   hdr;                  /*     0    12 */
	uint32_t                   unique_id;            /*    12     4 */
	uint16_t                   buffer_rel_condition; /*    16     2 */
	uint16_t                   reserved1;            /*    18     2 */
	uint32_t                   trigger_type;         /*    20     4 */
	uint32_t                   trigger_info_dwords[2]; /*    24     8 */
	uint32_t                   reserved2[2];         /*    32     8 */

	/* size: 40, cachelines: 1, members: 7 */
	/* last cacheline: 40 bytes */
};

$ pahole -C mpt3_addnl_diag_query drivers/scsi/mpt3sas/mpt3sas_ctl.o
struct mpt3_addnl_diag_query {
	struct mpt3_ioctl_header   hdr;                  /*     0    12 */
	uint32_t                   unique_id;            /*    12     4 */
	struct htb_rel_query       rel_query;            /*    16    16 */
	uint32_t                   reserved2[2];         /*    32     8 */

	/* size: 40, cachelines: 1, members: 4 */
	/* last cacheline: 40 bytes */
};

Also, this helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines on
memcpy().

Link: https://github.com/KSPP/linux/issues/109
Link: https://lore.kernel.org/lkml/60659889.bJJILx2THu3hlpxW%25lkp@intel.com/
Link: https://lore.kernel.org/r/20210401162054.GA397186@embeddedor
Build-tested-by: kernel test robot <lkp@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  5 ++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.h | 12 ++++--------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 44f9a05db94e..2ec11be62a82 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2507,7 +2507,7 @@ _ctl_addnl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		    __func__, karg.unique_id);
 		return -EPERM;
 	}
-	memset(&karg.buffer_rel_condition, 0, sizeof(struct htb_rel_query));
+	memset(&karg.rel_query, 0, sizeof(karg.rel_query));
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
 		ioc_info(ioc, "%s: buffer_type(0x%02x) is not registered\n",
@@ -2520,8 +2520,7 @@ _ctl_addnl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		    __func__, buffer_type);
 		return -EPERM;
 	}
-	memcpy(&karg.buffer_rel_condition, &ioc->htb_rel,
-	    sizeof(struct  htb_rel_query));
+	memcpy(&karg.rel_query, &ioc->htb_rel, sizeof(karg.rel_query));
 out:
 	if (copy_to_user(arg, &karg, sizeof(struct mpt3_addnl_diag_query))) {
 		ioc_err(ioc, "%s: unable to write mpt3_addnl_diag_query data @ %p\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index d2ccdafb8df2..8f6ffb40261c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -50,6 +50,8 @@
 #include <linux/miscdevice.h>
 #endif
 
+#include "mpt3sas_base.h"
+
 #ifndef MPT2SAS_MINOR
 #define MPT2SAS_MINOR		(MPT_MINOR + 1)
 #endif
@@ -436,19 +438,13 @@ struct mpt3_diag_read_buffer {
  * struct mpt3_addnl_diag_query - diagnostic buffer release reason
  * @hdr - generic header
  * @unique_id - unique id associated with this buffer.
- * @buffer_rel_condition - Release condition ioctl/sysfs/reset
- * @reserved1
- * @trigger_type - Master/Event/scsi/MPI
- * @trigger_info_dwords - Data Correspondig to trigger type
+ * @rel_query - release query.
  * @reserved2
  */
 struct mpt3_addnl_diag_query {
 	struct mpt3_ioctl_header hdr;
 	uint32_t unique_id;
-	uint16_t buffer_rel_condition;
-	uint16_t reserved1;
-	uint32_t trigger_type;
-	uint32_t trigger_info_dwords[2];
+	struct htb_rel_query rel_query;
 	uint32_t reserved2[2];
 };
 
-- 
2.30.2



