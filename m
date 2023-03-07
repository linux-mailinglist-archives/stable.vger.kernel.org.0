Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966846AF51D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjCGTWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbjCGTWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:22:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564CCC6E6B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E866153C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA4C433D2;
        Tue,  7 Mar 2023 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216015;
        bh=y8ijsG2h02xzR2ry/W6aYhQ2DubvJ4bKezImAwMuvCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tg8IEE+OmlIE9jaKA7zKTIwwnpS1TCorOwvi/u/a1937eczavNOLZaQVim2bT5dSm
         612NQWRZtKGbZhily4RN/3gcUeSzz1ZW2tBpeA+bsBPRqKBso5hoFQn0EqAIx03Cv9
         DQAUSFTkyRe725xkozYpL5/v9pcmd+cYnLPo6yrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 448/567] exfat: redefine DIR_DELETED as the bad cluster number
Date:   Tue,  7 Mar 2023 18:03:04 +0100
Message-Id: <20230307165925.332565490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Sungjong Seo <sj1557.seo@samsung.com>

commit bdaadfd343e3cba49ad0b009ff4b148dad0fa404 upstream.

When a file or a directory is deleted, the hint for the cluster of
its parent directory in its in-memory inode is set as DIR_DELETED.
Therefore, DIR_DELETED must be one of invalid cluster numbers. According
to the exFAT specification, a volume can have at most 2^32-11 clusters.
However, DIR_DELETED is wrongly defined as 0xFFFF0321, which could be
a valid cluster number. To fix it, let's redefine DIR_DELETED as
0xFFFFFFF7, the bad cluster number.

Fixes: 1acf1a564b60 ("exfat: add in-memory and on-disk structures and headers")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/exfat_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -42,7 +42,7 @@ enum {
 #define ES_2_ENTRIES		2
 #define ES_ALL_ENTRIES		0
 
-#define DIR_DELETED		0xFFFF0321
+#define DIR_DELETED		0xFFFFFFF7
 
 /* type values */
 #define TYPE_UNUSED		0x0000


