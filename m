Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDD02A57C9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgKCUw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732081AbgKCUw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C662053B;
        Tue,  3 Nov 2020 20:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436747;
        bh=BaFJrIrgGT8v5Cot8Buo0h7H8c2SvrHPO0d8+aVBO2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gh/IlFNWbKbxmTj+eEHwYeNS3srvYK1KrOmbG/jUknapMl8U9R31ouW25TP3odc8H
         2gxygM9hSSSC6CUIURWLNY/nsFHg5gCV57dMXLPEo8GeHrbo6NnFpMvajHEOs6+z4y
         9JSSAxpu1EFhxTZrNMw4HVHJmL1AtUnSwp33BwiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.9 347/391] ext4: fix bs < ps issue reported with dioread_nolock mount opt
Date:   Tue,  3 Nov 2020 21:36:38 +0100
Message-Id: <20201103203410.550985335@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit d1e18b8824dd50cff255e6cecf515ea598eaf9f0 upstream.

left shifting m_lblk by blkbits was causing value overflow and hence
it was not able to convert unwritten to written extent.
So, make sure we typecast it to loff_t before do left shift operation.
Also in func ext4_convert_unwritten_io_end_vec(), make sure to initialize
ret variable to avoid accidentally returning an uninitialized ret.

This patch fixes the issue reported in ext4 for bs < ps with
dioread_nolock mount option.

Fixes: c8cc88163f40df39e50c ("ext4: Add support for blocksize < pagesize in dioread_nolock")
Cc: stable@kernel.org
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/af902b5db99e8b73980c795d84ad7bb417487e76.1602168865.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4770,7 +4770,7 @@ int ext4_convert_unwritten_extents(handl
 
 int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 {
-	int ret, err = 0;
+	int ret = 0, err = 0;
 	struct ext4_io_end_vec *io_end_vec;
 
 	/*
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2257,7 +2257,7 @@ static int mpage_process_page(struct mpa
 					err = PTR_ERR(io_end_vec);
 					goto out;
 				}
-				io_end_vec->offset = mpd->map.m_lblk << blkbits;
+				io_end_vec->offset = (loff_t)mpd->map.m_lblk << blkbits;
 			}
 			*map_bh = true;
 			goto out;


