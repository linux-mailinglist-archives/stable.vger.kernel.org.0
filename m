Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01565D9B1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbjADQ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239805AbjADQ1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:27:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554473D1EB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C6B617A6
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17B8C433D2;
        Wed,  4 Jan 2023 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849623;
        bh=OfMgNU9HOVTNL9A+i8r3ITOYwJJKCwChbeZVBMZJt+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F923qPPCQO7BhZLX5VELG+ERyhrjWzwZEEW3XisT1vQ40JGONrmmBkp6k7ru1Eosc
         KVPJ7vxJ2MzKr9O9zYG2AvujlMFTbqIdar46swibf/o4ong5G7hKMH3z18x4oT1MdY
         BSfyk6M3TUOJavkL0geobQ7XugVtLWNd5Zg5//0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 147/177] ext4: fix leaking uninitialized memory in fast-commit journal
Date:   Wed,  4 Jan 2023 17:07:18 +0100
Message-Id: <20230104160512.113744253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 594bc43b410316d70bb42aeff168837888d96810 upstream.

When space at the end of fast-commit journal blocks is unused, make sure
to zero it out so that uninitialized memory is not leaked to disk.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-4-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -745,6 +745,9 @@ static u8 *ext4_fc_reserve_space(struct
 		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	/* Don't leak uninitialized memory in the unused last byte. */
+	*((u8 *)(tl + 1) + pad_len) = 0;
+
 	ext4_fc_submit_bh(sb, false);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
@@ -801,6 +804,8 @@ static int ext4_fc_write_tail(struct sup
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb, true);
 


