Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD126C193B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjCTPb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbjCTPbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD08D35EE8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6924A614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7606CC4339B;
        Mon, 20 Mar 2023 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325846;
        bh=VCoUk9Py4cE0Vx0q2TgkNuGt9UilbNTVdSBJTBikMuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCNAXw9mbburMbj3SZ0Mm0PuDYUWmnCBOKGOEqSl4NAVSNltY2weHjELvqYmOepoV
         Xe6j5NpqJrbj5CU3BJaXCFyq6k/B/HzIwS5VJQqY7HVGfHgEhL1fcHLlrfUJsn+hlc
         4mCGwM1sc8ZLxMwevtOM3JecSQjMf1OaesmOsELM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Van Hensbergen <ericvh@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 111/211] net/9p: fix bug in client create for .L
Date:   Mon, 20 Mar 2023 15:54:06 +0100
Message-Id: <20230320145517.951415715@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 3866584a1c56a2bbc8c0981deb4476d0b801969e ]

We are supposed to set fid->mode to reflect the flags
that were used to open the file.  We were actually setting
it to the creation mode which is the default perms of the
file not the flags the file was opened with.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Reviewed-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 622ec6a586eea..00a6d1e348768 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1289,7 +1289,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
-	ofid->mode = mode;
+	ofid->mode = flags;
 	ofid->iounit = iounit;
 
 free_and_error:
-- 
2.39.2



