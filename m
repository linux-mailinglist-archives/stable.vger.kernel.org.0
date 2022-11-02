Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C164615A4C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiKBD2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiKBD2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:28:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5C2DF74
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0FF50CE1E47
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4C5C4314B;
        Wed,  2 Nov 2022 03:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359703;
        bh=aAMbuvKLB1rxHJT681k2VuIQt+gbFbFVkLm8IkQyGRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaB2SDVda3Hj15EeV3TxtgiXj7pHWcILbCtbnzuHlAljkzL+7mMsberSQ1LbmDP20
         pbKFp8+dz7LCcxjKvlMiR/igLehH3JPVTvpkIop74y2ISSInPCxq5fEjHnZN3dx2nr
         ngsvlNWfeV3lD3U1niLN0yCKBgIVvlXxk0ePQkwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Auger <eric.auger@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 07/78] KVM: arm64: vgic: Fix exit condition in scan_its_table()
Date:   Wed,  2 Nov 2022 03:33:52 +0100
Message-Id: <20221102022053.138148267@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 virt/kvm/arm/vgic/vgic-its.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1915,7 +1915,7 @@ static int scan_its_table(struct vgic_it
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -1928,6 +1928,9 @@ static int scan_its_table(struct vgic_it
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;


