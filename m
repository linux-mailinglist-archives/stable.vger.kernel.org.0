Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026BC664B36
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbjAJSjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbjAJSio (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:38:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED39D8CBC4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE8C1B818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D5FC433D2;
        Tue, 10 Jan 2023 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375652;
        bh=aUImv6LgCM7cGIQJ+6bKz43jYvM0T5axOkEfUX9q1Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tvasmeTVAg1Rro3+dx1uLjP8WW7lwHs8mb1YxxseqJVvgq/pP/AIVTylEQul+uFb
         rA0ldKWl/3hJV3ttBOteF5blIhrdtITKUEqGZxWWKVm2N1uB/hiNU/hkhta+N72cdN
         m8gPFsvCnGyEKyYOEPuIyUGUzkEFXkETmyogP0rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/290] udf: Fix extension of the last extent in the file
Date:   Tue, 10 Jan 2023 19:05:50 +0100
Message-Id: <20230110180040.894804167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
index 6a0e8ef664c1..d2488b7e54a5 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -599,7 +599,7 @@ static void udf_do_extend_final_block(struct inode *inode,
 	 */
 	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
 		return;
-	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
+	added_bytes = new_elen - (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
-- 
2.35.1



