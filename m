Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF53E9CCD
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 05:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhHLDR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 23:17:29 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:54508 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbhHLDR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 23:17:28 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A650A806B5;
        Thu, 12 Aug 2021 15:17:02 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1628738222;
        bh=RAHvHJhanBkNE7vpYXjdEyrTfP5zP6CF1nnefkndLAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=14/21Dc/Md7HrvLKMrbpvgGTyNzxqarfu0Fi6ZclFeyc9aELbH8oz1WYim9OQOzOm
         FORS7dFUewWru+9RvDb9NcVIkosYa+1p6wh5xMIEty3YAokxwqjU/QBnLhAWch/vzk
         O5cnUPEZ2U/2wIhQxWiwjfrqmld7SXoTj//YyGNKdcJYLJSpbWcxJi7uXEJfsfTqSz
         /hkiGCJc0vEHA8/f20ty2lliPdNYuq3R7xCIE/9MmBX0Zwun6oVQvIScaKZkuwlnKg
         UUB6+iyz/1AVfeJfjyNND9pDUFKkr4OvEFYTk8T3HmhDRWieiBCqzaupnt84oKPgrO
         ELFF0TVTUrIJw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B611492ae0002>; Thu, 12 Aug 2021 15:17:02 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.37])
        by pat.atlnz.lc (Postfix) with ESMTP id 64A6E13EEAD;
        Thu, 12 Aug 2021 15:17:02 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 5C6EB1E041C; Thu, 12 Aug 2021 15:17:02 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        stable@vger.kernel.org
Subject: [PATCH v4 2/2] bus: mhi: Fix MHI DMA structure endianness
Date:   Thu, 12 Aug 2021 15:17:00 +1200
Message-Id: <20210812031700.23397-3-paul.davey@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812031700.23397-1-paul.davey@alliedtelesis.co.nz>
References: <20210812031700.23397-1-paul.davey@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=aqTM9hRV c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=VcFUL8-cEss-pW2IUzAA:9 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The MHI driver does not work on big endian architectures.  The
controller never transitions into mission mode.  This appears to be due
to the modem device expecting the various contexts and transfer rings to
have fields in little endian order in memory, but the driver constructs
them in native endianness.

Fix MHI event, channel and command contexts and TRE handling macros to
use explicit conversion to little endian.  Mark fields in relevant
structures as little endian to document this requirement.

Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transition=
s")
Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/eve=
nt ring doorbells")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
---
 drivers/bus/mhi/core/debugfs.c  |  26 +++----
 drivers/bus/mhi/core/init.c     |  36 +++++-----
 drivers/bus/mhi/core/internal.h | 119 ++++++++++++++++----------------
 drivers/bus/mhi/core/main.c     |  22 +++---
 drivers/bus/mhi/core/pm.c       |   4 +-
 5 files changed, 104 insertions(+), 103 deletions(-)

diff --git a/drivers/bus/mhi/core/debugfs.c b/drivers/bus/mhi/core/debugf=
s.c
index 858d7516410b..d818586c229d 100644
--- a/drivers/bus/mhi/core/debugfs.c
+++ b/drivers/bus/mhi/core/debugfs.c
@@ -60,16 +60,16 @@ static int mhi_debugfs_events_show(struct seq_file *m=
, void *d)
 		}
=20
 		seq_printf(m, "Index: %d intmod count: %lu time: %lu",
-			   i, (er_ctxt->intmod & EV_CTX_INTMODC_MASK) >>
+			   i, (le32_to_cpu(er_ctxt->intmod) & EV_CTX_INTMODC_MASK) >>
 			   EV_CTX_INTMODC_SHIFT,
-			   (er_ctxt->intmod & EV_CTX_INTMODT_MASK) >>
+			   (le32_to_cpu(er_ctxt->intmod) & EV_CTX_INTMODT_MASK) >>
 			   EV_CTX_INTMODT_SHIFT);
=20
-		seq_printf(m, " base: 0x%0llx len: 0x%llx", er_ctxt->rbase,
-			   er_ctxt->rlen);
+		seq_printf(m, " base: 0x%0llx len: 0x%llx", le64_to_cpu(er_ctxt->rbase=
),
+			   le64_to_cpu(er_ctxt->rlen));
=20
-		seq_printf(m, " rp: 0x%llx wp: 0x%llx", er_ctxt->rp,
-			   er_ctxt->wp);
+		seq_printf(m, " rp: 0x%llx wp: 0x%llx", le64_to_cpu(er_ctxt->rp),
+			   le64_to_cpu(er_ctxt->wp));
=20
 		seq_printf(m, " local rp: 0x%pK db: 0x%pad\n", ring->rp,
 			   &mhi_event->db_cfg.db_val);
@@ -106,18 +106,18 @@ static int mhi_debugfs_channels_show(struct seq_fil=
e *m, void *d)
=20
 		seq_printf(m,
 			   "%s(%u) state: 0x%lx brstmode: 0x%lx pollcfg: 0x%lx",
-			   mhi_chan->name, mhi_chan->chan, (chan_ctxt->chcfg &
+			   mhi_chan->name, mhi_chan->chan, (le32_to_cpu(chan_ctxt->chcfg) &
 			   CHAN_CTX_CHSTATE_MASK) >> CHAN_CTX_CHSTATE_SHIFT,
-			   (chan_ctxt->chcfg & CHAN_CTX_BRSTMODE_MASK) >>
-			   CHAN_CTX_BRSTMODE_SHIFT, (chan_ctxt->chcfg &
+			   (le32_to_cpu(chan_ctxt->chcfg) & CHAN_CTX_BRSTMODE_MASK) >>
+			   CHAN_CTX_BRSTMODE_SHIFT, (le32_to_cpu(chan_ctxt->chcfg) &
 			   CHAN_CTX_POLLCFG_MASK) >> CHAN_CTX_POLLCFG_SHIFT);
=20
-		seq_printf(m, " type: 0x%x event ring: %u", chan_ctxt->chtype,
-			   chan_ctxt->erindex);
+		seq_printf(m, " type: 0x%x event ring: %u", le32_to_cpu(chan_ctxt->cht=
ype),
+			   le32_to_cpu(chan_ctxt->erindex));
=20
 		seq_printf(m, " base: 0x%llx len: 0x%llx rp: 0x%llx wp: 0x%llx",
-			   chan_ctxt->rbase, chan_ctxt->rlen, chan_ctxt->rp,
-			   chan_ctxt->wp);
+			   le64_to_cpu(chan_ctxt->rbase), le64_to_cpu(chan_ctxt->rlen),
+			   le64_to_cpu(chan_ctxt->rp), le64_to_cpu(chan_ctxt->wp));
=20
 		seq_printf(m, " local rp: 0x%pK local wp: 0x%pK db: 0x%pad\n",
 			   ring->rp, ring->wp,
diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 0d588b60929e..17db8602d9ee 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -293,17 +293,17 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cn=
trl)
 		if (mhi_chan->offload_ch)
 			continue;
=20
-		tmp =3D chan_ctxt->chcfg;
+		tmp =3D le32_to_cpu(chan_ctxt->chcfg);
 		tmp &=3D ~CHAN_CTX_CHSTATE_MASK;
 		tmp |=3D (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
 		tmp &=3D ~CHAN_CTX_BRSTMODE_MASK;
 		tmp |=3D (mhi_chan->db_cfg.brstmode << CHAN_CTX_BRSTMODE_SHIFT);
 		tmp &=3D ~CHAN_CTX_POLLCFG_MASK;
 		tmp |=3D (mhi_chan->db_cfg.pollcfg << CHAN_CTX_POLLCFG_SHIFT);
-		chan_ctxt->chcfg =3D tmp;
+		chan_ctxt->chcfg =3D cpu_to_le32(tmp);
=20
-		chan_ctxt->chtype =3D mhi_chan->type;
-		chan_ctxt->erindex =3D mhi_chan->er_index;
+		chan_ctxt->chtype =3D cpu_to_le32(mhi_chan->type);
+		chan_ctxt->erindex =3D cpu_to_le32(mhi_chan->er_index);
=20
 		mhi_chan->ch_state =3D MHI_CH_STATE_DISABLED;
 		mhi_chan->tre_ring.db_addr =3D (void __iomem *)&chan_ctxt->wp;
@@ -328,14 +328,14 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cn=
trl)
 		if (mhi_event->offload_ev)
 			continue;
=20
-		tmp =3D er_ctxt->intmod;
+		tmp =3D le32_to_cpu(er_ctxt->intmod);
 		tmp &=3D ~EV_CTX_INTMODC_MASK;
 		tmp &=3D ~EV_CTX_INTMODT_MASK;
 		tmp |=3D (mhi_event->intmod << EV_CTX_INTMODT_SHIFT);
-		er_ctxt->intmod =3D tmp;
+		er_ctxt->intmod =3D cpu_to_le32(tmp);
=20
-		er_ctxt->ertype =3D MHI_ER_TYPE_VALID;
-		er_ctxt->msivec =3D mhi_event->irq;
+		er_ctxt->ertype =3D cpu_to_le32(MHI_ER_TYPE_VALID);
+		er_ctxt->msivec =3D cpu_to_le32(mhi_event->irq);
 		mhi_event->db_cfg.db_mode =3D true;
=20
 		ring->el_size =3D sizeof(struct mhi_tre);
@@ -349,9 +349,9 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntr=
l)
 		 * ring is empty
 		 */
 		ring->rp =3D ring->wp =3D ring->base;
-		er_ctxt->rbase =3D ring->iommu_base;
+		er_ctxt->rbase =3D cpu_to_le64(ring->iommu_base);
 		er_ctxt->rp =3D er_ctxt->wp =3D er_ctxt->rbase;
-		er_ctxt->rlen =3D ring->len;
+		er_ctxt->rlen =3D cpu_to_le64(ring->len);
 		ring->ctxt_wp =3D &er_ctxt->wp;
 	}
=20
@@ -378,9 +378,9 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntr=
l)
 			goto error_alloc_cmd;
=20
 		ring->rp =3D ring->wp =3D ring->base;
-		cmd_ctxt->rbase =3D ring->iommu_base;
+		cmd_ctxt->rbase =3D cpu_to_le64(ring->iommu_base);
 		cmd_ctxt->rp =3D cmd_ctxt->wp =3D cmd_ctxt->rbase;
-		cmd_ctxt->rlen =3D ring->len;
+		cmd_ctxt->rlen =3D cpu_to_le64(ring->len);
 		ring->ctxt_wp =3D &cmd_ctxt->wp;
 	}
=20
@@ -581,10 +581,10 @@ void mhi_deinit_chan_ctxt(struct mhi_controller *mh=
i_cntrl,
 	chan_ctxt->rp =3D 0;
 	chan_ctxt->wp =3D 0;
=20
-	tmp =3D chan_ctxt->chcfg;
+	tmp =3D le32_to_cpu(chan_ctxt->chcfg);
 	tmp &=3D ~CHAN_CTX_CHSTATE_MASK;
 	tmp |=3D (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
-	chan_ctxt->chcfg =3D tmp;
+	chan_ctxt->chcfg =3D cpu_to_le32(tmp);
=20
 	/* Update to all cores */
 	smp_wmb();
@@ -618,14 +618,14 @@ int mhi_init_chan_ctxt(struct mhi_controller *mhi_c=
ntrl,
 		return -ENOMEM;
 	}
=20
-	tmp =3D chan_ctxt->chcfg;
+	tmp =3D le32_to_cpu(chan_ctxt->chcfg);
 	tmp &=3D ~CHAN_CTX_CHSTATE_MASK;
 	tmp |=3D (MHI_CH_STATE_ENABLED << CHAN_CTX_CHSTATE_SHIFT);
-	chan_ctxt->chcfg =3D tmp;
+	chan_ctxt->chcfg =3D cpu_to_le32(tmp);
=20
-	chan_ctxt->rbase =3D tre_ring->iommu_base;
+	chan_ctxt->rbase =3D cpu_to_le64(tre_ring->iommu_base);
 	chan_ctxt->rp =3D chan_ctxt->wp =3D chan_ctxt->rbase;
-	chan_ctxt->rlen =3D tre_ring->len;
+	chan_ctxt->rlen =3D cpu_to_le64(tre_ring->len);
 	tre_ring->ctxt_wp =3D &chan_ctxt->wp;
=20
 	tre_ring->rp =3D tre_ring->wp =3D tre_ring->base;
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/inter=
nal.h
index 721739c5e0d5..43e8b47faf4b 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -209,14 +209,14 @@ extern struct bus_type mhi_bus_type;
 #define EV_CTX_INTMODT_MASK GENMASK(31, 16)
 #define EV_CTX_INTMODT_SHIFT 16
 struct mhi_event_ctxt {
-	__u32 intmod;
-	__u32 ertype;
-	__u32 msivec;
-
-	__u64 rbase __packed __aligned(4);
-	__u64 rlen __packed __aligned(4);
-	__u64 rp __packed __aligned(4);
-	__u64 wp __packed __aligned(4);
+	__le32 intmod;
+	__le32 ertype;
+	__le32 msivec;
+
+	__le64 rbase __packed __aligned(4);
+	__le64 rlen __packed __aligned(4);
+	__le64 rp __packed __aligned(4);
+	__le64 wp __packed __aligned(4);
 };
=20
 #define CHAN_CTX_CHSTATE_MASK GENMASK(7, 0)
@@ -227,25 +227,25 @@ struct mhi_event_ctxt {
 #define CHAN_CTX_POLLCFG_SHIFT 10
 #define CHAN_CTX_RESERVED_MASK GENMASK(31, 16)
 struct mhi_chan_ctxt {
-	__u32 chcfg;
-	__u32 chtype;
-	__u32 erindex;
-
-	__u64 rbase __packed __aligned(4);
-	__u64 rlen __packed __aligned(4);
-	__u64 rp __packed __aligned(4);
-	__u64 wp __packed __aligned(4);
+	__le32 chcfg;
+	__le32 chtype;
+	__le32 erindex;
+
+	__le64 rbase __packed __aligned(4);
+	__le64 rlen __packed __aligned(4);
+	__le64 rp __packed __aligned(4);
+	__le64 wp __packed __aligned(4);
 };
=20
 struct mhi_cmd_ctxt {
-	__u32 reserved0;
-	__u32 reserved1;
-	__u32 reserved2;
-
-	__u64 rbase __packed __aligned(4);
-	__u64 rlen __packed __aligned(4);
-	__u64 rp __packed __aligned(4);
-	__u64 wp __packed __aligned(4);
+	__le32 reserved0;
+	__le32 reserved1;
+	__le32 reserved2;
+
+	__le64 rbase __packed __aligned(4);
+	__le64 rlen __packed __aligned(4);
+	__le64 rp __packed __aligned(4);
+	__le64 wp __packed __aligned(4);
 };
=20
 struct mhi_ctxt {
@@ -258,8 +258,8 @@ struct mhi_ctxt {
 };
=20
 struct mhi_tre {
-	u64 ptr;
-	u32 dword[2];
+	__le64 ptr;
+	__le32 dword[2];
 };
=20
 struct bhi_vec_entry {
@@ -277,57 +277,58 @@ enum mhi_cmd_type {
 /* No operation command */
 #define MHI_TRE_CMD_NOOP_PTR (0)
 #define MHI_TRE_CMD_NOOP_DWORD0 (0)
-#define MHI_TRE_CMD_NOOP_DWORD1 (MHI_CMD_NOP << 16)
+#define MHI_TRE_CMD_NOOP_DWORD1 (cpu_to_le32(MHI_CMD_NOP << 16))
=20
 /* Channel reset command */
 #define MHI_TRE_CMD_RESET_PTR (0)
 #define MHI_TRE_CMD_RESET_DWORD0 (0)
-#define MHI_TRE_CMD_RESET_DWORD1(chid) ((chid << 24) | \
-					(MHI_CMD_RESET_CHAN << 16))
+#define MHI_TRE_CMD_RESET_DWORD1(chid) (cpu_to_le32((chid << 24) | \
+					(MHI_CMD_RESET_CHAN << 16)))
=20
 /* Channel stop command */
 #define MHI_TRE_CMD_STOP_PTR (0)
 #define MHI_TRE_CMD_STOP_DWORD0 (0)
-#define MHI_TRE_CMD_STOP_DWORD1(chid) ((chid << 24) | \
-				       (MHI_CMD_STOP_CHAN << 16))
+#define MHI_TRE_CMD_STOP_DWORD1(chid) (cpu_to_le32((chid << 24) | \
+				       (MHI_CMD_STOP_CHAN << 16)))
=20
 /* Channel start command */
 #define MHI_TRE_CMD_START_PTR (0)
 #define MHI_TRE_CMD_START_DWORD0 (0)
-#define MHI_TRE_CMD_START_DWORD1(chid) ((chid << 24) | \
-					(MHI_CMD_START_CHAN << 16))
+#define MHI_TRE_CMD_START_DWORD1(chid) (cpu_to_le32((chid << 24) | \
+					(MHI_CMD_START_CHAN << 16)))
=20
-#define MHI_TRE_GET_CMD_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
-#define MHI_TRE_GET_CMD_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
+#define MHI_TRE_GET_DWORD(tre, word) (le32_to_cpu((tre)->dword[(word)]))
+#define MHI_TRE_GET_CMD_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0=
xFF)
+#define MHI_TRE_GET_CMD_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0=
xFF)
=20
 /* Event descriptor macros */
-#define MHI_TRE_EV_PTR(ptr) (ptr)
-#define MHI_TRE_EV_DWORD0(code, len) ((code << 24) | len)
-#define MHI_TRE_EV_DWORD1(chid, type) ((chid << 24) | (type << 16))
-#define MHI_TRE_GET_EV_PTR(tre) ((tre)->ptr)
-#define MHI_TRE_GET_EV_CODE(tre) (((tre)->dword[0] >> 24) & 0xFF)
-#define MHI_TRE_GET_EV_LEN(tre) ((tre)->dword[0] & 0xFFFF)
-#define MHI_TRE_GET_EV_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
-#define MHI_TRE_GET_EV_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
-#define MHI_TRE_GET_EV_STATE(tre) (((tre)->dword[0] >> 24) & 0xFF)
-#define MHI_TRE_GET_EV_EXECENV(tre) (((tre)->dword[0] >> 24) & 0xFF)
-#define MHI_TRE_GET_EV_SEQ(tre) ((tre)->dword[0])
-#define MHI_TRE_GET_EV_TIME(tre) ((tre)->ptr)
-#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits((tre)->ptr)
-#define MHI_TRE_GET_EV_VEID(tre) (((tre)->dword[0] >> 16) & 0xFF)
-#define MHI_TRE_GET_EV_LINKSPEED(tre) (((tre)->dword[1] >> 24) & 0xFF)
-#define MHI_TRE_GET_EV_LINKWIDTH(tre) ((tre)->dword[0] & 0xFF)
+#define MHI_TRE_EV_PTR(ptr) (cpu_to_le64(ptr))
+#define MHI_TRE_EV_DWORD0(code, len) (cpu_to_le32((code << 24) | len))
+#define MHI_TRE_EV_DWORD1(chid, type) (cpu_to_le32((chid << 24) | (type =
<< 16)))
+#define MHI_TRE_GET_EV_PTR(tre) (le64_to_cpu((tre)->ptr))
+#define MHI_TRE_GET_EV_CODE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0x=
FF)
+#define MHI_TRE_GET_EV_LEN(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFFFF)
+#define MHI_TRE_GET_EV_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0x=
FF)
+#define MHI_TRE_GET_EV_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0x=
FF)
+#define MHI_TRE_GET_EV_STATE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0=
xFF)
+#define MHI_TRE_GET_EV_EXECENV(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) &=
 0xFF)
+#define MHI_TRE_GET_EV_SEQ(tre) MHI_TRE_GET_DWORD(tre, 0)
+#define MHI_TRE_GET_EV_TIME(tre) (MHI_TRE_GET_EV_PTR(tre))
+#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits(MHI_TRE_GET_EV_PTR(tre)=
)
+#define MHI_TRE_GET_EV_VEID(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 16) & 0x=
FF)
+#define MHI_TRE_GET_EV_LINKSPEED(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24)=
 & 0xFF)
+#define MHI_TRE_GET_EV_LINKWIDTH(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFF)
=20
 /* Transfer descriptor macros */
-#define MHI_TRE_DATA_PTR(ptr) (ptr)
-#define MHI_TRE_DATA_DWORD0(len) (len & MHI_MAX_MTU)
-#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) ((2 << 16) | (bei <<=
 10) \
-	| (ieot << 9) | (ieob << 8) | chain)
+#define MHI_TRE_DATA_PTR(ptr) (cpu_to_le64(ptr))
+#define MHI_TRE_DATA_DWORD0(len) (cpu_to_le32(len & MHI_MAX_MTU))
+#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) (cpu_to_le32((2 << 1=
6) | (bei << 10) \
+	| (ieot << 9) | (ieob << 8) | chain))
=20
 /* RSC transfer descriptor macros */
-#define MHI_RSCTRE_DATA_PTR(ptr, len) (((u64)len << 48) | ptr)
-#define MHI_RSCTRE_DATA_DWORD0(cookie) (cookie)
-#define MHI_RSCTRE_DATA_DWORD1 (MHI_PKT_TYPE_COALESCING << 16)
+#define MHI_RSCTRE_DATA_PTR(ptr, len) (cpu_to_le64(((u64)len << 48) | pt=
r))
+#define MHI_RSCTRE_DATA_DWORD0(cookie) (cpu_to_le32(cookie))
+#define MHI_RSCTRE_DATA_DWORD1 (cpu_to_le32(MHI_PKT_TYPE_COALESCING << 1=
6))
=20
 enum mhi_pkt_type {
 	MHI_PKT_TYPE_INVALID =3D 0x0,
@@ -499,7 +500,7 @@ struct state_transition {
 struct mhi_ring {
 	dma_addr_t dma_handle;
 	dma_addr_t iommu_base;
-	u64 *ctxt_wp; /* point to ctxt wp */
+	__le64 *ctxt_wp; /* point to ctxt wp */
 	void *pre_aligned;
 	void *base;
 	void *rp;
diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index c01ec2fef02c..8b6fa6a6779d 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -114,7 +114,7 @@ void mhi_ring_er_db(struct mhi_event *mhi_event)
 	struct mhi_ring *ring =3D &mhi_event->ring;
=20
 	mhi_event->db_cfg.process_db(mhi_event->mhi_cntrl, &mhi_event->db_cfg,
-				     ring->db_addr, *ring->ctxt_wp);
+				     ring->db_addr, le64_to_cpu(*ring->ctxt_wp));
 }
=20
 void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *m=
hi_cmd)
@@ -123,7 +123,7 @@ void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl=
, struct mhi_cmd *mhi_cmd)
 	struct mhi_ring *ring =3D &mhi_cmd->ring;
=20
 	db =3D ring->iommu_base + (ring->wp - ring->base);
-	*ring->ctxt_wp =3D db;
+	*ring->ctxt_wp =3D cpu_to_le64(db);
 	mhi_write_db(mhi_cntrl, ring->db_addr, db);
 }
=20
@@ -140,7 +140,7 @@ void mhi_ring_chan_db(struct mhi_controller *mhi_cntr=
l,
 	 * before letting h/w know there is new element to fetch.
 	 */
 	dma_wmb();
-	*ring->ctxt_wp =3D db;
+	*ring->ctxt_wp =3D cpu_to_le64(db);
=20
 	mhi_chan->db_cfg.process_db(mhi_cntrl, &mhi_chan->db_cfg,
 				    ring->db_addr, db);
@@ -432,7 +432,7 @@ irqreturn_t mhi_irq_handler(int irq_number, void *dev=
)
 	struct mhi_event_ctxt *er_ctxt =3D
 		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
 	struct mhi_ring *ev_ring =3D &mhi_event->ring;
-	dma_addr_t ptr =3D er_ctxt->rp;
+	dma_addr_t ptr =3D le64_to_cpu(er_ctxt->rp);
 	void *dev_rp;
=20
 	if (!is_valid_ring_ptr(ev_ring, ptr)) {
@@ -537,14 +537,14 @@ static void mhi_recycle_ev_ring_element(struct mhi_=
controller *mhi_cntrl,
=20
 	/* Update the WP */
 	ring->wp +=3D ring->el_size;
-	ctxt_wp =3D *ring->ctxt_wp + ring->el_size;
+	ctxt_wp =3D le64_to_cpu(*ring->ctxt_wp) + ring->el_size;
=20
 	if (ring->wp >=3D (ring->base + ring->len)) {
 		ring->wp =3D ring->base;
 		ctxt_wp =3D ring->iommu_base;
 	}
=20
-	*ring->ctxt_wp =3D ctxt_wp;
+	*ring->ctxt_wp =3D cpu_to_le64(ctxt_wp);
=20
 	/* Update the RP */
 	ring->rp +=3D ring->el_size;
@@ -801,7 +801,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *m=
hi_cntrl,
 	struct device *dev =3D &mhi_cntrl->mhi_dev->dev;
 	u32 chan;
 	int count =3D 0;
-	dma_addr_t ptr =3D er_ctxt->rp;
+	dma_addr_t ptr =3D le64_to_cpu(er_ctxt->rp);
=20
 	/*
 	 * This is a quick check to avoid unnecessary event processing
@@ -940,7 +940,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *m=
hi_cntrl,
 		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
 		local_rp =3D ev_ring->rp;
=20
-		ptr =3D er_ctxt->rp;
+		ptr =3D le64_to_cpu(er_ctxt->rp);
 		if (!is_valid_ring_ptr(ev_ring, ptr)) {
 			dev_err(&mhi_cntrl->mhi_dev->dev,
 				"Event ring rp points outside of the event ring\n");
@@ -970,7 +970,7 @@ int mhi_process_data_event_ring(struct mhi_controller=
 *mhi_cntrl,
 	int count =3D 0;
 	u32 chan;
 	struct mhi_chan *mhi_chan;
-	dma_addr_t ptr =3D er_ctxt->rp;
+	dma_addr_t ptr =3D le64_to_cpu(er_ctxt->rp);
=20
 	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
 		return -EIO;
@@ -1011,7 +1011,7 @@ int mhi_process_data_event_ring(struct mhi_controll=
er *mhi_cntrl,
 		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
 		local_rp =3D ev_ring->rp;
=20
-		ptr =3D er_ctxt->rp;
+		ptr =3D le64_to_cpu(er_ctxt->rp);
 		if (!is_valid_ring_ptr(ev_ring, ptr)) {
 			dev_err(&mhi_cntrl->mhi_dev->dev,
 				"Event ring rp points outside of the event ring\n");
@@ -1532,7 +1532,7 @@ static void mhi_mark_stale_events(struct mhi_contro=
ller *mhi_cntrl,
 	/* mark all stale events related to channel as STALE event */
 	spin_lock_irqsave(&mhi_event->lock, flags);
=20
-	ptr =3D er_ctxt->rp;
+	ptr =3D le64_to_cpu(er_ctxt->rp);
 	if (!is_valid_ring_ptr(ev_ring, ptr)) {
 		dev_err(&mhi_cntrl->mhi_dev->dev,
 			"Event ring rp points outside of the event ring\n");
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index fb99e3727155..059d61214168 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -218,7 +218,7 @@ int mhi_ready_state_transition(struct mhi_controller =
*mhi_cntrl)
 			continue;
=20
 		ring->wp =3D ring->base + ring->len - ring->el_size;
-		*ring->ctxt_wp =3D ring->iommu_base + ring->len - ring->el_size;
+		*ring->ctxt_wp =3D cpu_to_le64(ring->iommu_base + ring->len - ring->el=
_size);
 		/* Update all cores */
 		smp_wmb();
=20
@@ -420,7 +420,7 @@ static int mhi_pm_mission_mode_transition(struct mhi_=
controller *mhi_cntrl)
 			continue;
=20
 		ring->wp =3D ring->base + ring->len - ring->el_size;
-		*ring->ctxt_wp =3D ring->iommu_base + ring->len - ring->el_size;
+		*ring->ctxt_wp =3D cpu_to_le64(ring->iommu_base + ring->len - ring->el=
_size);
 		/* Update to all cores */
 		smp_wmb();
=20
--=20
2.32.0

