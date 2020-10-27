Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD929B185
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902143AbgJ0ObA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901921AbgJ0O3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9C82222C;
        Tue, 27 Oct 2020 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808958;
        bh=Ln77mXgNfQcIb9MvmS/cJx97WtVrEZEx0pq0fYNPTVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1R8uX0+8sKZKllNkbg68TvUDVU1Rjy0CWfrXd7/iVAfoj2cTsVWhBEmd3xmLDVPZ1
         4JFeh98Cbdcj7Z8mdqQ+s3sFynpknwnmpRaoOEsVDEyw8eKmNwZNrFbXn56nEZDeZE
         PWR5t7wXjnH0BDmD+C1q9+H270EyRuWxNPRxysvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
        David Milburn <dmilburn@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Andryuk <jandryuk@gmail.com>
Subject: [PATCH 5.4 024/408] nvme-pci: disable the write zeros command for Intel 600P/P3100
Date:   Tue, 27 Oct 2020 14:49:22 +0100
Message-Id: <20201027135456.184570834@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

commit ce4cc3133dc72c31bd49ddcf22d0f9eeff47a761 upstream.

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
[ Fix-up for 5.4 since NVME_QUIRK_NO_TEMP_THRESH_CHANGE doesn't exist ]
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3110,7 +3110,8 @@ static const struct pci_device_id nvme_i
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0xf1a5),	/* Intel 600P/P3100 */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
-				NVME_QUIRK_MEDIUM_PRIO_SQ },
+				NVME_QUIRK_MEDIUM_PRIO_SQ |
+				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0xf1a6),	/* Intel 760p/Pro 7600p */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */


