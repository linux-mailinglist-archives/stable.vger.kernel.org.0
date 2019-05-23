Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D692890F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391631AbfEWTaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392158AbfEWTa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D40A21850;
        Thu, 23 May 2019 19:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639828;
        bh=FnalDg18hBi6kHR+z/J9Vm5QcBsPty/hXYq3rg0fMHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug5BfHbpVloD5WCpIIDw5vf+u+NjON+OT2oMa8aoqMJuzcOpzg9LJ/Htvhw8RSxwp
         5Qu8J6661cDEu2dK99D8HXeTE8rVz1VevHU97Pv7ixVvGPDOgIyx3cpC4kqLRxwAus
         XRj4soXahH7NuALICUeMuUSYNWnIpfY6rpg+2XKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 107/122] dm integrity: correctly calculate the size of metadata area
Date:   Thu, 23 May 2019 21:07:09 +0200
Message-Id: <20190523181719.547624425@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 30bba430ddf737978e40561198693ba91386dac1 upstream.

When we use separate devices for data and metadata, dm-integrity would
incorrectly calculate the size of the metadata device as if it had
512-byte block size - and it would refuse activation with larger block
size and smaller metadata device.

Fix this so that it takes actual block size into account, which fixes
the following reported issue:
https://gitlab.com/cryptsetup/cryptsetup/issues/450

Fixes: 356d9d52e122 ("dm integrity: allow separate metadata device")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2568,7 +2568,7 @@ static int calculate_device_limits(struc
 		if (last_sector < ic->start || last_sector >= ic->meta_device_sectors)
 			return -EINVAL;
 	} else {
-		__u64 meta_size = ic->provided_data_sectors * ic->tag_size;
+		__u64 meta_size = (ic->provided_data_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size;
 		meta_size = (meta_size + ((1U << (ic->log2_buffer_sectors + SECTOR_SHIFT)) - 1))
 				>> (ic->log2_buffer_sectors + SECTOR_SHIFT);
 		meta_size <<= ic->log2_buffer_sectors;
@@ -3439,7 +3439,7 @@ try_smaller_buffer:
 	DEBUG_print("	journal_sections %u\n", (unsigned)le32_to_cpu(ic->sb->journal_sections));
 	DEBUG_print("	journal_entries %u\n", ic->journal_entries);
 	DEBUG_print("	log2_interleave_sectors %d\n", ic->sb->log2_interleave_sectors);
-	DEBUG_print("	device_sectors 0x%llx\n", (unsigned long long)ic->device_sectors);
+	DEBUG_print("	data_device_sectors 0x%llx\n", (unsigned long long)ic->data_device_sectors);
 	DEBUG_print("	initial_sectors 0x%x\n", ic->initial_sectors);
 	DEBUG_print("	metadata_run 0x%x\n", ic->metadata_run);
 	DEBUG_print("	log2_metadata_run %d\n", ic->log2_metadata_run);


