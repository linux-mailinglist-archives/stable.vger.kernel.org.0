Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0969676F56
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjAVPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjAVPUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00191222C7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FA4060C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DB6C433D2;
        Sun, 22 Jan 2023 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400818;
        bh=cR1yh4W0VK12+VUdagv+r1ltDmlYyXmS4h/0RKbsJMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yaw/njan9tYZyOON8s6rjQQ+8rs8gV2VCXkMP5orWZL6IEa2q7t3SrXH8/xGYfz2i
         O89qQ3aHb5IOJH/zae/qmm7oXNjfWQeWEeezzrZi8k3jdF0eq7JWarRZEt4/fsd/ZR
         PS9XctrfGJ10zriNFxeWd8Pv6muoi9lt8q0g86W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alon Zahavi <zahavi.alon@gmail.com>,
        Tal Lossos <tallossos@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 100/117] fs/ntfs3: Fix attr_punch_hole() null pointer derenference
Date:   Sun, 22 Jan 2023 16:04:50 +0100
Message-Id: <20230122150236.986137292@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alon Zahavi <zahavi.alon@gmail.com>

commit 6d5c9e79b726cc473d40e9cb60976dbe8e669624 upstream.

The bug occours due to a misuse of `attr` variable instead of `attr_b`.
`attr` is being initialized as NULL, then being derenfernced
as `attr->res.data_size`.

This bug causes a crash of the ntfs3 driver itself,
If compiled directly to the kernel, it crashes the whole system.

Signed-off-by: Alon Zahavi <zahavi.alon@gmail.com>
Co-developed-by: Tal Lossos <tallossos@gmail.com>
Signed-off-by: Tal Lossos <tallossos@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1967,7 +1967,7 @@ int attr_punch_hole(struct ntfs_inode *n
 		return -ENOENT;
 
 	if (!attr_b->non_res) {
-		u32 data_size = le32_to_cpu(attr->res.data_size);
+		u32 data_size = le32_to_cpu(attr_b->res.data_size);
 		u32 from, to;
 
 		if (vbo > data_size)


