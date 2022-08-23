Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991A059D609
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241878AbiHWI5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbiHWI5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:57:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1888049F;
        Tue, 23 Aug 2022 01:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8131AB81C50;
        Tue, 23 Aug 2022 08:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44F2C433D7;
        Tue, 23 Aug 2022 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242762;
        bh=2MjMmv1DWYOrh+U1u+hL4AFpZ83wNRy9AWvFn4o+AHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fB/K8e4F+E5apPYoT25Mr2yoltJBFxF/71B3Fh54uVsayYdR/W/3mmAo5jrQYBKP+
         /i0mrJS7/OG+C6fQJts+t6TXoLeOAu5nbOdFdhTbFv4jk6e9Vq2YVId7+2oKMZtDcT
         GS9szMeiTe4Nk0VBlckA6z5WikTSKIZeBv8kSZAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liangbin Lian <jjm2473@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.19 165/365] fs/ntfs3: Fix missing i_op in ntfs_read_mft
Date:   Tue, 23 Aug 2022 10:01:06 +0200
Message-Id: <20220823080125.115283591@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 37a530bfe56ca9a0d3129598803f2794c7428aae upstream.

There is null pointer dereference because i_op == NULL.
The bug happens because we don't initialize i_op for records in $Extend.
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")

Reported-by: Liangbin Lian <jjm2473@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -430,6 +430,7 @@ end_enum:
 	} else if (fname && fname->home.low == cpu_to_le32(MFT_REC_EXTEND) &&
 		   fname->home.seq == cpu_to_le16(MFT_REC_EXTEND)) {
 		/* Records in $Extend are not a files or general directories. */
+		inode->i_op = &ntfs_file_inode_operations;
 	} else {
 		err = -EINVAL;
 		goto out;


