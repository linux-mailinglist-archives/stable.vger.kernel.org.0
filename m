Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C536E6BB225
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjCOMdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbjCOMdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D04296622
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB06161ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1715C433D2;
        Wed, 15 Mar 2023 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883533;
        bh=n0wns6ddOZk19d5aAo/6RxpmtTtYxfdo+sDhp5k6Mas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CE5Z0+Nibwx1OKhsiXwsf+M1NQmBnlXD72pKG4obBnm82C7B599HjOkSA+0wefTwD
         CO6bpJMN//NYcNDRDFs95h2lAul0rM/jcGaPvHg9fMP8gu90HpMMaajW6KWr3f0UG/
         dv2x7QICPaxBHWuQuXCdq2Pe/z8EpnB8JFeEk+SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/143] fs: dlm: use packet in dlm_mhandle
Date:   Wed, 15 Mar 2023 13:12:00 +0100
Message-Id: <20230315115741.542119357@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 5b787667e87a373a2f8f70e6be2b5d99c408462f ]

To allow more than just dereferencing the inner header we directly point
to the inner dlm packet which allows us to dereference the header, rcom
or message structure.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 724b6bab0d75 ("fs: dlm: fix use after free in midcomms commit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 095f2005fb621..4a8721ab9f149 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -194,7 +194,7 @@ struct midcomms_node {
 };
 
 struct dlm_mhandle {
-	const struct dlm_header *inner_hd;
+	const union dlm_packet *inner_p;
 	struct midcomms_node *node;
 	struct dlm_opts *opts;
 	struct dlm_msg *msg;
@@ -1049,7 +1049,7 @@ static struct dlm_msg *dlm_midcomms_get_msg_3_2(struct dlm_mhandle *mh, int node
 	dlm_fill_opts_header(opts, len, mh->seq);
 
 	*ppc += sizeof(*opts);
-	mh->inner_hd = (const struct dlm_header *)*ppc;
+	mh->inner_p = (const union dlm_packet *)*ppc;
 	return msg;
 }
 
@@ -1127,7 +1127,7 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len,
 static void dlm_midcomms_commit_msg_3_2(struct dlm_mhandle *mh)
 {
 	/* nexthdr chain for fast lookup */
-	mh->opts->o_nextcmd = mh->inner_hd->h_cmd;
+	mh->opts->o_nextcmd = mh->inner_p->header.h_cmd;
 	mh->committed = true;
 	dlm_lowcomms_commit_msg(mh->msg);
 }
-- 
2.39.2



