Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7840E50F663
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345643AbiDZIqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346816AbiDZIpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546533BF89;
        Tue, 26 Apr 2022 01:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E80D36185A;
        Tue, 26 Apr 2022 08:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00799C385A0;
        Tue, 26 Apr 2022 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962145;
        bh=rW6yEKuVGsLMEoEc+BoXhVds8ZGtpnr5lkrCxZp1kwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+Gg5FICjl3ynToe6HLF2DnbtgXGzxPUFMZjUwtq8YBqxLSbd6r8K74O74LAEMjkL
         jMTQYnY4caNDpGsgP0r+CdmU1V4KBKbHM8wm+c30YeW1wIln22rzh9pqYZybYefdti
         ZCZIAc1qcs/khnKw+Vw3xn8l3WIyoo4jG/GY10fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 80/86] ext4: force overhead calculation if the s_overhead_cluster makes no sense
Date:   Tue, 26 Apr 2022 10:21:48 +0200
Message-Id: <20220426081743.524330987@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 85d825dbf4899a69407338bae462a59aa9a37326 upstream.

If the file system does not use bigalloc, calculating the overhead is
cheap, so force the recalculation of the overhead so we don't have to
trust the precalculated overhead in the superblock.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4933,9 +4933,18 @@ no_journal:
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.
 	 */
-	if (es->s_overhead_clusters)
-		sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
-	else {
+	sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
+	/* ignore the precalculated value if it is ridiculous */
+	if (sbi->s_overhead > ext4_blocks_count(es))
+		sbi->s_overhead = 0;
+	/*
+	 * If the bigalloc feature is not enabled recalculating the
+	 * overhead doesn't take long, so we might as well just redo
+	 * it to make sure we are using the correct value.
+	 */
+	if (!ext4_has_feature_bigalloc(sb))
+		sbi->s_overhead = 0;
+	if (sbi->s_overhead == 0) {
 		err = ext4_calculate_overhead(sb);
 		if (err)
 			goto failed_mount_wq;


