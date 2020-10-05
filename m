Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11F4283A33
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgJEPcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727472AbgJEPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF12A2074F;
        Mon,  5 Oct 2020 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911930;
        bh=tSj8Ri06+wF3ANOcZBQI6Ri2GA0CBE4r2n61sONm++Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1gKEUR/nvj1ditek976OBvxJvUdR4Bo83+VCacJLP+DK6RBR5ueRSrjs69cygqGB
         q27dNqSHoKOmXvJFbCvPa4oM3MvXzMAwfG4D8Tqt5+aEGJ/CmHg00RF2x7lQEfNzkx
         52dfZCTCeSEzSp9MdlyYkABYI0vRoWNWWlJ3WXl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
        David Milburn <dmilburn@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 34/85] nvme-pci: disable the write zeros command for Intel 600P/P3100
Date:   Mon,  5 Oct 2020 17:26:30 +0200
Message-Id: <20201005142116.379776256@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

[ Upstream commit ce4cc3133dc72c31bd49ddcf22d0f9eeff47a761 ]

The write zeros command does not work with 4k range.

bash-4.4# ./blkdiscard /dev/nvme0n1p2
bash-4.4# strace -efallocate xfs_io -c "fzero 536895488 2048" /dev/nvme0n1p2
fallocate(3, FALLOC_FL_ZERO_RANGE, 536895488, 2048) = 0
+++ exited with 0 +++
bash-4.4# dd bs=1 if=/dev/nvme0n1p2 skip=536895488 count=512 | hexdump -C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

bash-4.4# ./blkdiscard /dev/nvme0n1p2
bash-4.4# strace -efallocate xfs_io -c "fzero 536895488 4096" /dev/nvme0n1p2
fallocate(3, FALLOC_FL_ZERO_RANGE, 536895488, 4096) = 0
+++ exited with 0 +++
bash-4.4# dd bs=1 if=/dev/nvme0n1p2 skip=536895488 count=512 | hexdump -C
00000000  5c 61 5c b0 96 21 1b 5e  85 0c 07 32 9c 8c eb 3c  |\a\..!.^...2...<|
00000010  4a a2 06 ca 67 15 2d 8e  29 8d a8 a0 7e 46 8c 62  |J...g.-.)...~F.b|
00000020  bb 4c 6c c1 6b f5 ae a5  e4 a9 bc 93 4f 60 ff 7a  |.Ll.k.......O`.z|

Reported-by: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: David Milburn <dmilburn@redhat.com>
Tested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 69a19fe241063..90346cba87d1e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3093,7 +3093,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_VDEVICE(INTEL, 0xf1a5),	/* Intel 600P/P3100 */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_MEDIUM_PRIO_SQ |
-				NVME_QUIRK_NO_TEMP_THRESH_CHANGE },
+				NVME_QUIRK_NO_TEMP_THRESH_CHANGE |
+				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0xf1a6),	/* Intel 760p/Pro 7600p */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
-- 
2.25.1



