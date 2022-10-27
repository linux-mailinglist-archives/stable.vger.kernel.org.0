Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099AC60FDA3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbiJ0Q5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiJ0Q5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B93B87A2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88450623D2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6E7C433C1;
        Thu, 27 Oct 2022 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889843;
        bh=lBD0BYU/aq/uaAIISqshs4Bf0wlTvKuWqpd+J1Fxcjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCSa4NeryfzT4wO7Ad0YQdaFLaPXs0ejQPAokv/cIZH4oEJpq8nf8TyaCY/w6hhPN
         g6G28Az2t+TkSpHCeiVv2eVsSwDB5AnRAH5QPRBHF05dCQ6/a+wZL86mT5rWWYpMug
         +2lJbJ5Zcm21PFFaiyvEMPGSYYeOQriAEM7i5sXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Auger <eric.auger@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.0 20/94] KVM: arm64: vgic: Fix exit condition in scan_its_table()
Date:   Thu, 27 Oct 2022 18:54:22 +0200
Message-Id: <20221027165057.871684634@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Ren <renzhengeek@gmail.com>

commit c000a2607145d28b06c697f968491372ea56c23a upstream.

With some PCIe topologies, restoring a guest fails while
parsing the ITS device tables.

Reproducer hints:
1. Create ARM virt VM with pxb-pcie bus which adds
   extra host bridges, with qemu command like:

```
  -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.x \
  ...
  -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.y \
  ...

```
2. Ensure the guest uses 2-level device table
3. Perform VM migration which calls save/restore device tables

In that setup, we get a big "offset" between 2 device_ids,
which makes unsigned "len" round up a big positive number,
causing the scan loop to continue with a bad GPA. For example:

1. L1 table has 2 entries;
2. and we are now scanning at L2 table entry index 2075 (pointed
   to by L1 first entry)
3. if next device id is 9472, we will get a big offset: 7397;
4. with unsigned 'len', 'len -= offset * esz', len will underflow to a
   positive number, mistakenly into next iteration with a bad GPA;
   (It should break out of the current L2 table scanning, and jump
   into the next L1 table entry)
5. that bad GPA fails the guest read.

Fix it by stopping the L2 table scan when the next device id is
outside of the current table, allowing the scan to continue from
the next L1 table entry.

Thanks to Eric Auger for the fix suggestion.

Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for tableookup")
Suggested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Ren <renzhengeek@gmail.com>
[maz: commit message tidy-up]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d9c3a564af9e2c5bf63f48a7dcbf08cd593c5c0b.1665802985.git.renzhengeek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2149,7 +2149,7 @@ static int scan_its_table(struct vgic_it
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -2162,6 +2162,9 @@ static int scan_its_table(struct vgic_it
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;


