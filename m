Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E03D217169
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgGGPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgGGPTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7BCB2065D;
        Tue,  7 Jul 2020 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135160;
        bh=g1YPOiapB8xx6KVZwvvF7K1+yVd3HG9sagiVKT3VVdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWPz5V+L2C2FwcFrgI+BOu3x2qv4VtUzcEWnzC87TsWnQN1JaSh11OKa/9mIo8/NH
         a+OGmUIKGuyyJO+j6Iqnj+QN1+CUIX8rqkiwrfXrDmlWtSLHwpeuXx62OL7htqNcE/
         8gUWz98yuN4EOyfkzFjfp+geJIHk0qs/bZw7gwtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 35/36] dm zoned: assign max_io_len correctly
Date:   Tue,  7 Jul 2020 17:17:27 +0200
Message-Id: <20200707145750.834126861@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.

The unit of max_io_len is sector instead of byte (spotted through
code review), so fix it.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/md/dm-zoned-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -789,7 +789,7 @@ static int dmz_ctr(struct dm_target *ti,
 	}
 
 	/* Set target (no write same support) */
-	ti->max_io_len = dev->zone_nr_sectors << 9;
+	ti->max_io_len = dev->zone_nr_sectors;
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_zeroes_bios = 1;


