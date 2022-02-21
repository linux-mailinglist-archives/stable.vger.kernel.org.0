Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3C4BE076
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347182AbiBUJEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347190AbiBUJA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD727B27;
        Mon, 21 Feb 2022 00:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 365EEB80EAA;
        Mon, 21 Feb 2022 08:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1F1C340E9;
        Mon, 21 Feb 2022 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433727;
        bh=hevMNI8JP0s+vSotsMBfQsYPHAGrUmm4+XL55KLcPJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vw94g88A4eV0nUmEadY16bOKwO375nYVsv2IbR/CnZ6G/T7ztgcmhzYo9UdEDVtx7
         wtUwZ77HMrlXDQq4ldyQL0HzMDFb8lkH7FdXeKAFmU6EbNLXpxcrgmKSJL8eiz9zuS
         nXZwTRKDAhxP92Q3Si4s7QJ0dfJ5bRv1HDt1dQuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 06/58] btrfs: send: in case of IO error log it
Date:   Mon, 21 Feb 2022 09:48:59 +0100
Message-Id: <20220221084912.092328977@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dāvis Mosāns <davispuh@gmail.com>

commit 2e7be9db125a0bf940c5d65eb5c40d8700f738b5 upstream.

Currently if we get IO error while doing send then we abort without
logging information about which file caused issue.  So log it to help
with debugging.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Dāvis Mosāns <davispuh@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4956,6 +4956,10 @@ static ssize_t fill_read_buf(struct send
 			lock_page(page);
 			if (!PageUptodate(page)) {
 				unlock_page(page);
+				btrfs_err(fs_info,
+			"send: IO error at offset %llu for inode %llu root %llu",
+					page_offset(page), sctx->cur_ino,
+					sctx->send_root->root_key.objectid);
 				put_page(page);
 				ret = -EIO;
 				break;


