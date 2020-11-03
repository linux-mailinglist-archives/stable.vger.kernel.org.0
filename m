Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F193B2A56D5
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732811AbgKCVb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732264AbgKCU5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D712053B;
        Tue,  3 Nov 2020 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437060;
        bh=8XRW9+8V2YtEQFuAZb5kFILEmhnjnyoFhcK+xRqzZ3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLDoIyOSpTErHcUxSzsDqd1/RhUgcARLtxNf4LSr4dTFdON7u5wr1h+x+IqOZbVz9
         No5JOTlwTN3dtDiqBipGPJdY2ZWadNtbU405I0Ek0RlTuC/CuL3XvU77gRDzxdbpQy
         Rm2KuqMTLBKM7PwBXhzB1T8qcBkGx1X+h6VaK+Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Daniel Xu <dxu@dxuuu.xyz>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 130/214] btrfs: tree-checker: validate number of chunk stripes and parity
Date:   Tue,  3 Nov 2020 21:36:18 +0100
Message-Id: <20201103203303.026049333@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Xu <dxu@dxuuu.xyz>

commit 85d07fbe09efd1c529ff3e025e2f0d2c6c96a1b7 upstream.

If there's no parity and num_stripes < ncopies, a crafted image can
trigger a division by zero in calc_stripe_length().

The image was generated through fuzzing.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=209587
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-checker.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -577,18 +577,36 @@ int btrfs_check_chunk_valid(struct exten
 	u64 type;
 	u64 features;
 	bool mixed = false;
+	int raid_index;
+	int nparity;
+	int ncopies;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
 	type = btrfs_chunk_type(leaf, chunk);
+	raid_index = btrfs_bg_flags_to_raid_index(type);
+	ncopies = btrfs_raid_array[raid_index].ncopies;
+	nparity = btrfs_raid_array[raid_index].nparity;
 
 	if (!num_stripes) {
 		chunk_err(leaf, chunk, logical,
 			  "invalid chunk num_stripes, have %u", num_stripes);
 		return -EUCLEAN;
 	}
+	if (num_stripes < ncopies) {
+		chunk_err(leaf, chunk, logical,
+			  "invalid chunk num_stripes < ncopies, have %u < %d",
+			  num_stripes, ncopies);
+		return -EUCLEAN;
+	}
+	if (nparity && num_stripes == nparity) {
+		chunk_err(leaf, chunk, logical,
+			  "invalid chunk num_stripes == nparity, have %u == %d",
+			  num_stripes, nparity);
+		return -EUCLEAN;
+	}
 	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
 		chunk_err(leaf, chunk, logical,
 		"invalid chunk logical, have %llu should aligned to %u",


