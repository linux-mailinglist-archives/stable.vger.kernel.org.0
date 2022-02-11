Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D064B20B2
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348296AbiBKIxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiBKIxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C72E80;
        Fri, 11 Feb 2022 00:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50CE7B828BD;
        Fri, 11 Feb 2022 08:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D7FC340E9;
        Fri, 11 Feb 2022 08:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569629;
        bh=5+NIpsxK7JvStAaW2IkN4u7rl5TzyIcffENzq/zapj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wy/KUW0SjB5nUnfV6ZNrsqTpPnxuEntN+ldZWCmJKPm7L9A8BPILYXY4BVqnEIOnE
         qSKCyODybMSHT8+PSk2jpz3aNdZ+LnYq3o5QRnVjyxsHBHELKrGZAVdSbcAIvyEsx+
         ZedCmChpg8O5UDU/PC3JqmjY01mvDOTgrkW6Tt/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.16.9
Date:   Fri, 11 Feb 2022 09:53:40 +0100
Message-Id: <1644569619235124@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164456961925244@kroah.com>
References: <164456961925244@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0cbab4df51b9..1f32bb42f328 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 16
-SUBLEVEL = 8
+SUBLEVEL = 9
 EXTRAVERSION =
 NAME = Gobble Gobble
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8fc9c79c899b..41a6fe086fdc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4711,6 +4711,8 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
 		return -E2BIG;
+	if (!kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_SIDA_READ:
diff --git a/crypto/algapi.c b/crypto/algapi.c
index a366cb3e8aa1..76fdaa16bd4a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1324,3 +1324,4 @@ module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cryptographic algorithms API");
+MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/crypto/api.c b/crypto/api.c
index cf0869dd130b..7ddfe946dd56 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -643,4 +643,3 @@ EXPORT_SYMBOL_GPL(crypto_req_done);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1cdf8cfcc31b..94bc5dbb31e1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2486,23 +2486,21 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 	struct ata_cpr_log *cpr_log = NULL;
 	u8 *desc, *buf = NULL;
 
-	if (!ata_identify_page_supported(dev,
-				 ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+	if (ata_id_major_version(dev->id) < 11 ||
+	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
 		goto out;
 
 	/*
-	 * Read IDENTIFY DEVICE data log, page 0x47
-	 * (concurrent positioning ranges). We can have at most 255 32B range
-	 * descriptors plus a 64B header.
+	 * Read the concurrent positioning ranges log (0x47). We can have at
+	 * most 255 32B range descriptors plus a 64B header.
 	 */
 	buf_len = (64 + 255 * 32 + 511) & ~511;
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
-	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
-				     ATA_LOG_CONCURRENT_POSITIONING_RANGES,
-				     buf, buf_len >> 9);
+	err_mask = ata_read_log_page(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES,
+				     0, buf, buf_len >> 9);
 	if (err_mask)
 		goto out;
 
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 16d1c7a43d33..b6eb75f4bbfc 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -705,12 +705,12 @@ static int moxart_remove(struct platform_device *pdev)
 	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
 		dma_release_channel(host->dma_chan_rx);
 	mmc_remove_host(mmc);
-	mmc_free_host(mmc);
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 	writel(0, host->base + REG_POWER_CONTROL);
 	writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 	       host->base + REG_CLOCK_CONTROL);
+	mmc_free_host(mmc);
 
 	return 0;
 }
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 32300bd6af7a..1ff1e52f398f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2688,7 +2688,7 @@ int smb2_open(struct ksmbd_work *work)
 					(struct create_posix *)context;
 				if (le16_to_cpu(context->DataOffset) +
 				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix)) {
+				    sizeof(struct create_posix) - 4) {
 					rc = -EINVAL;
 					goto err_out1;
 				}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 199e47e97d64..21292b5bbb55 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -324,12 +324,12 @@ enum {
 	ATA_LOG_NCQ_NON_DATA	= 0x12,
 	ATA_LOG_NCQ_SEND_RECV	= 0x13,
 	ATA_LOG_IDENTIFY_DEVICE	= 0x30,
+	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device log pages: */
 	ATA_LOG_SECURITY	  = 0x06,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
-	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device SATA settings log:*/
 	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 09ae8448f394..4e7936d9b442 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2199,7 +2199,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	struct tipc_msg *hdr = buf_msg(skb);
 	struct tipc_gap_ack_blks *ga = NULL;
 	bool reply = msg_probe(hdr), retransmitted = false;
-	u16 dlen = msg_data_sz(hdr), glen = 0;
+	u32 dlen = msg_data_sz(hdr), glen = 0;
 	u16 peers_snd_nxt =  msg_next_sent(hdr);
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
@@ -2213,6 +2213,10 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	void *data;
 
 	trace_tipc_proto_rcv(skb, false, l->name);
+
+	if (dlen > U16_MAX)
+		goto exit;
+
 	if (tipc_link_is_blocked(l) || !xmitq)
 		goto exit;
 
@@ -2308,7 +2312,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 
 		/* Receive Gap ACK blocks from peer if any */
 		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
-
+		if(glen > dlen)
+			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 407619697292..2f4d23238a7e 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -496,6 +496,8 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->probing = false;
 
 	/* Sanity check received domain record */
+	if (new_member_cnt > MAX_MON_DOMAIN)
+		return;
 	if (dlen < dom_rec_len(arrv_dom, 0))
 		return;
 	if (dlen != dom_rec_len(arrv_dom, new_member_cnt))
