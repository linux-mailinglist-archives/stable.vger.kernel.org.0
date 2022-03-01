Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863A84C8FA3
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiCAQES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbiCAQES (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:04:18 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23AE506C7
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:03:35 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id z4so14704828pgh.12
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gvoIiFGA1CvHUT5z/fcFW+7rDLlYkOlziO1p4WtwfpM=;
        b=KNXLjyEt0tbWPgoShdf+zbXCf3pul9SuWIXYZwsy1GELNLF35e04MfJ/FmxqktH965
         ZY1BV6EmxtOwHGa23FMKmiDonLiT7wqcCoVaV1Muu2L3Kz4mcKfkSJNZ1I+jAsq9TE+P
         T4u7gfhwZ/KmaltyxqFJnI0URbP9p2S1n8Z5dVQmRxHbZKQ9bEUGKeaaQCWevsx3+J3S
         TLFEVbbT92aQy1qQCReBXupQRc4GJQIS6BV+JXgx8OA3zRvC+OECj5A43j1wHjPZwzA9
         GrEI4PSGGxhxlAS/xQTI3GcVXtETMVCPu8ETlgxljJ2E/nJDeK/xR509uqliHFwxZTNP
         xs0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gvoIiFGA1CvHUT5z/fcFW+7rDLlYkOlziO1p4WtwfpM=;
        b=vUn5h82Ce7NKDV0bk7vbIJ3ukpoCer1L5p4jpBD/U5mRkFOh8bll76ltktIPsz8D4G
         /0wn2RklP1qlrzPqDmV8BeQfGGntvogKLItI/YmIAJ0IYyR/a9duUuR9DigPooAcIqaI
         NY8K9HHtM3JEqe3zyNT5MS79nubYMaMHI4c4Db/ri51dYldyTAvszSKPPQqntXiZyBE4
         dl5yjMkCkaxBPAiuU6Gh+F0vmu1eaPkdewKf05uhHCSpKEIme4ezeosGa2WB1hvPZadv
         DfzZopvvSf8k9c3cQvgE5t3JR7QfpLpnqZR+P6oZn0qi/BXNwJYAMfn8cxbxhrhGwezg
         9c9A==
X-Gm-Message-State: AOAM5306hqXoHZb7H+P0a4bUV3wDTWgKdiTeVzEUSaJ4yfX2fwNyq7Gp
        /WtWh5n7LF6AFqsrGxrTOKa8
X-Google-Smtp-Source: ABdhPJwu9F0Gwk3R8BWU+8tSILcNfPNEfVn8tF6NAZoBnZxwgXXCzteOO/k+nlUNmuafXngOLuJj+w==
X-Received: by 2002:a05:6a00:1797:b0:4e1:935f:94b3 with SMTP id s23-20020a056a00179700b004e1935f94b3mr27754071pfg.75.1646150615235;
        Tue, 01 Mar 2022 08:03:35 -0800 (PST)
Received: from localhost.localdomain ([117.207.25.80])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm2489530pjn.34.2022.03.01.08.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:03:34 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        quic_bbhatt@quicinc.com, elder@linaro.org,
        paul.davey@alliedtelesis.co.nz,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 03/10] bus: mhi: Fix MHI DMA structure endianness
Date:   Tue,  1 Mar 2022 21:33:01 +0530
Message-Id: <20220301160308.107452-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301160308.107452-1-manivannan.sadhasivam@linaro.org>
References: <20220301160308.107452-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Davey <paul.davey@alliedtelesis.co.nz>

The MHI driver does not work on big endian architectures.  The
controller never transitions into mission mode.  This appears to be due
to the modem device expecting the various contexts and transfer rings to
have fields in little endian order in memory, but the driver constructs
them in native endianness.

Fix MHI event, channel and command contexts and TRE handling macros to
use explicit conversion to little endian.  Mark fields in relevant
structures as little endian to document this requirement.

Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/event ring doorbells")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/debugfs.c  |  26 +++----
 drivers/bus/mhi/core/init.c     |  36 +++++-----
 drivers/bus/mhi/core/internal.h | 119 ++++++++++++++++----------------
 drivers/bus/mhi/core/main.c     |  22 +++---
 drivers/bus/mhi/core/pm.c       |   4 +-
 5 files changed, 104 insertions(+), 103 deletions(-)

diff --git a/drivers/bus/mhi/core/debugfs.c b/drivers/bus/mhi/core/debugfs.c
index 858d7516410b..d818586c229d 100644
--- a/drivers/bus/mhi/core/debugfs.c
+++ b/drivers/bus/mhi/core/debugfs.c
@@ -60,16 +60,16 @@ static int mhi_debugfs_events_show(struct seq_file *m, void *d)
 		}
 
 		seq_printf(m, "Index: %d intmod count: %lu time: %lu",
-			   i, (er_ctxt->intmod & EV_CTX_INTMODC_MASK) >>
+			   i, (le32_to_cpu(er_ctxt->intmod) & EV_CTX_INTMODC_MASK) >>
 			   EV_CTX_INTMODC_SHIFT,
-			   (er_ctxt->intmod & EV_CTX_INTMODT_MASK) >>
+			   (le32_to_cpu(er_ctxt->intmod) & EV_CTX_INTMODT_MASK) >>
 			   EV_CTX_INTMODT_SHIFT);
 
-		seq_printf(m, " base: 0x%0llx len: 0x%llx", er_ctxt->rbase,
-			   er_ctxt->rlen);
+		seq_printf(m, " base: 0x%0llx len: 0x%llx", le64_to_cpu(er_ctxt->rbase),
+			   le64_to_cpu(er_ctxt->rlen));
 
-		seq_printf(m, " rp: 0x%llx wp: 0x%llx", er_ctxt->rp,
-			   er_ctxt->wp);
+		seq_printf(m, " rp: 0x%llx wp: 0x%llx", le64_to_cpu(er_ctxt->rp),
+			   le64_to_cpu(er_ctxt->wp));
 
 		seq_printf(m, " local rp: 0x%pK db: 0x%pad\n", ring->rp,
 			   &mhi_event->db_cfg.db_val);
@@ -106,18 +106,18 @@ static int mhi_debugfs_channels_show(struct seq_file *m, void *d)
 
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
 
-		seq_printf(m, " type: 0x%x event ring: %u", chan_ctxt->chtype,
-			   chan_ctxt->erindex);
+		seq_printf(m, " type: 0x%x event ring: %u", le32_to_cpu(chan_ctxt->chtype),
+			   le32_to_cpu(chan_ctxt->erindex));
 
 		seq_printf(m, " base: 0x%llx len: 0x%llx rp: 0x%llx wp: 0x%llx",
-			   chan_ctxt->rbase, chan_ctxt->rlen, chan_ctxt->rp,
-			   chan_ctxt->wp);
+			   le64_to_cpu(chan_ctxt->rbase), le64_to_cpu(chan_ctxt->rlen),
+			   le64_to_cpu(chan_ctxt->rp), le64_to_cpu(chan_ctxt->wp));
 
 		seq_printf(m, " local rp: 0x%pK local wp: 0x%pK db: 0x%pad\n",
 			   ring->rp, ring->wp,
diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 09394a1c29ec..d8787aaa176b 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -293,17 +293,17 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
 		if (mhi_chan->offload_ch)
 			continue;
 
-		tmp = chan_ctxt->chcfg;
+		tmp = le32_to_cpu(chan_ctxt->chcfg);
 		tmp &= ~CHAN_CTX_CHSTATE_MASK;
 		tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
 		tmp &= ~CHAN_CTX_BRSTMODE_MASK;
 		tmp |= (mhi_chan->db_cfg.brstmode << CHAN_CTX_BRSTMODE_SHIFT);
 		tmp &= ~CHAN_CTX_POLLCFG_MASK;
 		tmp |= (mhi_chan->db_cfg.pollcfg << CHAN_CTX_POLLCFG_SHIFT);
-		chan_ctxt->chcfg = tmp;
+		chan_ctxt->chcfg = cpu_to_le32(tmp);
 
-		chan_ctxt->chtype = mhi_chan->type;
-		chan_ctxt->erindex = mhi_chan->er_index;
+		chan_ctxt->chtype = cpu_to_le32(mhi_chan->type);
+		chan_ctxt->erindex = cpu_to_le32(mhi_chan->er_index);
 
 		mhi_chan->ch_state = MHI_CH_STATE_DISABLED;
 		mhi_chan->tre_ring.db_addr = (void __iomem *)&chan_ctxt->wp;
@@ -328,14 +328,14 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
 		if (mhi_event->offload_ev)
 			continue;
 
-		tmp = er_ctxt->intmod;
+		tmp = le32_to_cpu(er_ctxt->intmod);
 		tmp &= ~EV_CTX_INTMODC_MASK;
 		tmp &= ~EV_CTX_INTMODT_MASK;
 		tmp |= (mhi_event->intmod << EV_CTX_INTMODT_SHIFT);
-		er_ctxt->intmod = tmp;
+		er_ctxt->intmod = cpu_to_le32(tmp);
 
-		er_ctxt->ertype = MHI_ER_TYPE_VALID;
-		er_ctxt->msivec = mhi_event->irq;
+		er_ctxt->ertype = cpu_to_le32(MHI_ER_TYPE_VALID);
+		er_ctxt->msivec = cpu_to_le32(mhi_event->irq);
 		mhi_event->db_cfg.db_mode = true;
 
 		ring->el_size = sizeof(struct mhi_tre);
@@ -349,9 +349,9 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
 		 * ring is empty
 		 */
 		ring->rp = ring->wp = ring->base;
-		er_ctxt->rbase = ring->iommu_base;
+		er_ctxt->rbase = cpu_to_le64(ring->iommu_base);
 		er_ctxt->rp = er_ctxt->wp = er_ctxt->rbase;
-		er_ctxt->rlen = ring->len;
+		er_ctxt->rlen = cpu_to_le64(ring->len);
 		ring->ctxt_wp = &er_ctxt->wp;
 	}
 
@@ -378,9 +378,9 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
 			goto error_alloc_cmd;
 
 		ring->rp = ring->wp = ring->base;
-		cmd_ctxt->rbase = ring->iommu_base;
+		cmd_ctxt->rbase = cpu_to_le64(ring->iommu_base);
 		cmd_ctxt->rp = cmd_ctxt->wp = cmd_ctxt->rbase;
-		cmd_ctxt->rlen = ring->len;
+		cmd_ctxt->rlen = cpu_to_le64(ring->len);
 		ring->ctxt_wp = &cmd_ctxt->wp;
 	}
 
@@ -581,10 +581,10 @@ void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
 	chan_ctxt->rp = 0;
 	chan_ctxt->wp = 0;
 
-	tmp = chan_ctxt->chcfg;
+	tmp = le32_to_cpu(chan_ctxt->chcfg);
 	tmp &= ~CHAN_CTX_CHSTATE_MASK;
 	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
-	chan_ctxt->chcfg = tmp;
+	chan_ctxt->chcfg = cpu_to_le32(tmp);
 
 	/* Update to all cores */
 	smp_wmb();
@@ -618,14 +618,14 @@ int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
 		return -ENOMEM;
 	}
 
-	tmp = chan_ctxt->chcfg;
+	tmp = le32_to_cpu(chan_ctxt->chcfg);
 	tmp &= ~CHAN_CTX_CHSTATE_MASK;
 	tmp |= (MHI_CH_STATE_ENABLED << CHAN_CTX_CHSTATE_SHIFT);
-	chan_ctxt->chcfg = tmp;
+	chan_ctxt->chcfg = cpu_to_le32(tmp);
 
-	chan_ctxt->rbase = tre_ring->iommu_base;
+	chan_ctxt->rbase = cpu_to_le64(tre_ring->iommu_base);
 	chan_ctxt->rp = chan_ctxt->wp = chan_ctxt->rbase;
-	chan_ctxt->rlen = tre_ring->len;
+	chan_ctxt->rlen = cpu_to_le64(tre_ring->len);
 	tre_ring->ctxt_wp = &chan_ctxt->wp;
 
 	tre_ring->rp = tre_ring->wp = tre_ring->base;
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 3508cbbf555d..37c39bf1c7a9 100644
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
 
 struct mhi_ctxt {
@@ -258,8 +258,8 @@ struct mhi_ctxt {
 };
 
 struct mhi_tre {
-	u64 ptr;
-	u32 dword[2];
+	__le64 ptr;
+	__le32 dword[2];
 };
 
 struct bhi_vec_entry {
@@ -277,57 +277,58 @@ enum mhi_cmd_type {
 /* No operation command */
 #define MHI_TRE_CMD_NOOP_PTR (0)
 #define MHI_TRE_CMD_NOOP_DWORD0 (0)
-#define MHI_TRE_CMD_NOOP_DWORD1 (MHI_CMD_NOP << 16)
+#define MHI_TRE_CMD_NOOP_DWORD1 (cpu_to_le32(MHI_CMD_NOP << 16))
 
 /* Channel reset command */
 #define MHI_TRE_CMD_RESET_PTR (0)
 #define MHI_TRE_CMD_RESET_DWORD0 (0)
-#define MHI_TRE_CMD_RESET_DWORD1(chid) ((chid << 24) | \
-					(MHI_CMD_RESET_CHAN << 16))
+#define MHI_TRE_CMD_RESET_DWORD1(chid) (cpu_to_le32((chid << 24) | \
+					(MHI_CMD_RESET_CHAN << 16)))
 
 /* Channel stop command */
 #define MHI_TRE_CMD_STOP_PTR (0)
 #define MHI_TRE_CMD_STOP_DWORD0 (0)
-#define MHI_TRE_CMD_STOP_DWORD1(chid) ((chid << 24) | \
-				       (MHI_CMD_STOP_CHAN << 16))
+#define MHI_TRE_CMD_STOP_DWORD1(chid) (cpu_to_le32((chid << 24) | \
+				       (MHI_CMD_STOP_CHAN << 16)))
 
 /* Channel start command */
 #define MHI_TRE_CMD_START_PTR (0)
 #define MHI_TRE_CMD_START_DWORD0 (0)
-#define MHI_TRE_CMD_START_DWORD1(chid) ((chid << 24) | \
-					(MHI_CMD_START_CHAN << 16))
+#define MHI_TRE_CMD_START_DWORD1(chid) (cpu_to_le32((chid << 24) | \
+					(MHI_CMD_START_CHAN << 16)))
 
-#define MHI_TRE_GET_CMD_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
-#define MHI_TRE_GET_CMD_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
+#define MHI_TRE_GET_DWORD(tre, word) (le32_to_cpu((tre)->dword[(word)]))
+#define MHI_TRE_GET_CMD_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
+#define MHI_TRE_GET_CMD_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
 
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
+#define MHI_TRE_EV_DWORD1(chid, type) (cpu_to_le32((chid << 24) | (type << 16)))
+#define MHI_TRE_GET_EV_PTR(tre) (le64_to_cpu((tre)->ptr))
+#define MHI_TRE_GET_EV_CODE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_LEN(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFFFF)
+#define MHI_TRE_GET_EV_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
+#define MHI_TRE_GET_EV_STATE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_EXECENV(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_SEQ(tre) MHI_TRE_GET_DWORD(tre, 0)
+#define MHI_TRE_GET_EV_TIME(tre) (MHI_TRE_GET_EV_PTR(tre))
+#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits(MHI_TRE_GET_EV_PTR(tre))
+#define MHI_TRE_GET_EV_VEID(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 16) & 0xFF)
+#define MHI_TRE_GET_EV_LINKSPEED(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_LINKWIDTH(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFF)
 
 /* Transfer descriptor macros */
-#define MHI_TRE_DATA_PTR(ptr) (ptr)
-#define MHI_TRE_DATA_DWORD0(len) (len & MHI_MAX_MTU)
-#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) ((2 << 16) | (bei << 10) \
-	| (ieot << 9) | (ieob << 8) | chain)
+#define MHI_TRE_DATA_PTR(ptr) (cpu_to_le64(ptr))
+#define MHI_TRE_DATA_DWORD0(len) (cpu_to_le32(len & MHI_MAX_MTU))
+#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) (cpu_to_le32((2 << 16) | (bei << 10) \
+	| (ieot << 9) | (ieob << 8) | chain))
 
 /* RSC transfer descriptor macros */
-#define MHI_RSCTRE_DATA_PTR(ptr, len) (((u64)len << 48) | ptr)
-#define MHI_RSCTRE_DATA_DWORD0(cookie) (cookie)
-#define MHI_RSCTRE_DATA_DWORD1 (MHI_PKT_TYPE_COALESCING << 16)
+#define MHI_RSCTRE_DATA_PTR(ptr, len) (cpu_to_le64(((u64)len << 48) | ptr))
+#define MHI_RSCTRE_DATA_DWORD0(cookie) (cpu_to_le32(cookie))
+#define MHI_RSCTRE_DATA_DWORD1 (cpu_to_le32(MHI_PKT_TYPE_COALESCING << 16))
 
 enum mhi_pkt_type {
 	MHI_PKT_TYPE_INVALID = 0x0,
@@ -500,7 +501,7 @@ struct state_transition {
 struct mhi_ring {
 	dma_addr_t dma_handle;
 	dma_addr_t iommu_base;
-	u64 *ctxt_wp; /* point to ctxt wp */
+	__le64 *ctxt_wp; /* point to ctxt wp */
 	void *pre_aligned;
 	void *base;
 	void *rp;
diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index ffde617f93a3..85f4f7c8d7c6 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -114,7 +114,7 @@ void mhi_ring_er_db(struct mhi_event *mhi_event)
 	struct mhi_ring *ring = &mhi_event->ring;
 
 	mhi_event->db_cfg.process_db(mhi_event->mhi_cntrl, &mhi_event->db_cfg,
-				     ring->db_addr, *ring->ctxt_wp);
+				     ring->db_addr, le64_to_cpu(*ring->ctxt_wp));
 }
 
 void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
@@ -123,7 +123,7 @@ void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
 	struct mhi_ring *ring = &mhi_cmd->ring;
 
 	db = ring->iommu_base + (ring->wp - ring->base);
-	*ring->ctxt_wp = db;
+	*ring->ctxt_wp = cpu_to_le64(db);
 	mhi_write_db(mhi_cntrl, ring->db_addr, db);
 }
 
@@ -140,7 +140,7 @@ void mhi_ring_chan_db(struct mhi_controller *mhi_cntrl,
 	 * before letting h/w know there is new element to fetch.
 	 */
 	dma_wmb();
-	*ring->ctxt_wp = db;
+	*ring->ctxt_wp = cpu_to_le64(db);
 
 	mhi_chan->db_cfg.process_db(mhi_cntrl, &mhi_chan->db_cfg,
 				    ring->db_addr, db);
@@ -432,7 +432,7 @@ irqreturn_t mhi_irq_handler(int irq_number, void *dev)
 	struct mhi_event_ctxt *er_ctxt =
 		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
 	struct mhi_ring *ev_ring = &mhi_event->ring;
-	dma_addr_t ptr = er_ctxt->rp;
+	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
 	void *dev_rp;
 
 	if (!is_valid_ring_ptr(ev_ring, ptr)) {
@@ -537,14 +537,14 @@ static void mhi_recycle_ev_ring_element(struct mhi_controller *mhi_cntrl,
 
 	/* Update the WP */
 	ring->wp += ring->el_size;
-	ctxt_wp = *ring->ctxt_wp + ring->el_size;
+	ctxt_wp = le64_to_cpu(*ring->ctxt_wp) + ring->el_size;
 
 	if (ring->wp >= (ring->base + ring->len)) {
 		ring->wp = ring->base;
 		ctxt_wp = ring->iommu_base;
 	}
 
-	*ring->ctxt_wp = ctxt_wp;
+	*ring->ctxt_wp = cpu_to_le64(ctxt_wp);
 
 	/* Update the RP */
 	ring->rp += ring->el_size;
@@ -801,7 +801,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	u32 chan;
 	int count = 0;
-	dma_addr_t ptr = er_ctxt->rp;
+	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
 
 	/*
 	 * This is a quick check to avoid unnecessary event processing
@@ -940,7 +940,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
 		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
 		local_rp = ev_ring->rp;
 
-		ptr = er_ctxt->rp;
+		ptr = le64_to_cpu(er_ctxt->rp);
 		if (!is_valid_ring_ptr(ev_ring, ptr)) {
 			dev_err(&mhi_cntrl->mhi_dev->dev,
 				"Event ring rp points outside of the event ring\n");
@@ -970,7 +970,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
 	int count = 0;
 	u32 chan;
 	struct mhi_chan *mhi_chan;
-	dma_addr_t ptr = er_ctxt->rp;
+	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
 
 	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
 		return -EIO;
@@ -1011,7 +1011,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
 		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
 		local_rp = ev_ring->rp;
 
-		ptr = er_ctxt->rp;
+		ptr = le64_to_cpu(er_ctxt->rp);
 		if (!is_valid_ring_ptr(ev_ring, ptr)) {
 			dev_err(&mhi_cntrl->mhi_dev->dev,
 				"Event ring rp points outside of the event ring\n");
@@ -1533,7 +1533,7 @@ static void mhi_mark_stale_events(struct mhi_controller *mhi_cntrl,
 	/* mark all stale events related to channel as STALE event */
 	spin_lock_irqsave(&mhi_event->lock, flags);
 
-	ptr = er_ctxt->rp;
+	ptr = le64_to_cpu(er_ctxt->rp);
 	if (!is_valid_ring_ptr(ev_ring, ptr)) {
 		dev_err(&mhi_cntrl->mhi_dev->dev,
 			"Event ring rp points outside of the event ring\n");
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 4aae0baea008..c35c5ddc7220 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -218,7 +218,7 @@ int mhi_ready_state_transition(struct mhi_controller *mhi_cntrl)
 			continue;
 
 		ring->wp = ring->base + ring->len - ring->el_size;
-		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
+		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
 		/* Update all cores */
 		smp_wmb();
 
@@ -420,7 +420,7 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
 			continue;
 
 		ring->wp = ring->base + ring->len - ring->el_size;
-		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
+		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
 		/* Update to all cores */
 		smp_wmb();
 
-- 
2.25.1

