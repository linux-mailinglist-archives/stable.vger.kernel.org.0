Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7F6648CA
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbjAJSPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjAJSOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:14:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DD68E9AA
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE855B81906
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E913C433D2;
        Tue, 10 Jan 2023 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374361;
        bh=zlkQeW0j/joRxquS61ZaE9dXO4i0jwb0Iajw7tswj5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNnRC3FGWLsZv5CeCex4U+hwzkjKPicvRa/1M4w3PsdRdej8vXglQ+8RsArGc0E/6
         2PW8HMn3kJ72Azx7caeV8NLTWf/aub3k7rKHACMJO62eZt1qkcA256vSZ83bk5FfE5
         3JCaCcPsNHpJoOblCGTk21RIvH5s+bBK3kBhoAQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 101/148] udf: Fix extension of the last extent in the file
Date:   Tue, 10 Jan 2023 19:03:25 +0100
Message-Id: <20230110180020.394592601@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 83c7423d1eb6806d13c521d1002cc1a012111719 ]

When extending the last extent in the file within the last block, we
wrongly computed the length of the last extent. This is mostly a
cosmetical problem since the extent does not contain any data and the
length will be fixed up by following operations but still.

Fixes: 1f3868f06855 ("udf: Fix extending file within last block")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index b9a83820e1ad..3c380140515d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -600,7 +600,7 @@ static void udf_do_extend_final_block(struct inode *inode,
 	 */
 	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
 		return;
-	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
+	added_bytes = new_elen - (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
-- 
2.35.1



