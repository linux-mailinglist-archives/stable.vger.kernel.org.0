Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ACC6C199D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjCTPfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjCTPfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:35:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF4437567
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62E2B80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A15C433EF;
        Mon, 20 Mar 2023 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326063;
        bh=+2t+enFRKlzUWZbDoWwg/y0/eC8PPG1DtS/5oXXkOVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODR0qYJ66G/4koClsGlxBiWtky8mAeV1D7pMZnf75WxonukiCrsCDHIf+eB4rJrEI
         C68Of8Vbnsrc97I09C3Aty+st9rFrYLOqQKXnYr2sRXRlmMem9iow2Uc4jJr/zIXss
         k30CrV83BJRdysHWjc1RqlZ936KIJHo/785BjAME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 152/211] cifs: use DFS root session instead of tcon ses
Date:   Mon, 20 Mar 2023 15:54:47 +0100
Message-Id: <20230320145519.810351136@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 6284e46bdd47743a064fe6ac834a7ac05b1fd206 upstream.

Use DFS root session whenever possible to get new DFS referrals
otherwise we might end up with an IPC tcon (tcon->ses->tcon_ipc) that
doesn't respond to them.  It should be safe accessing
@ses->dfs_root_ses directly in cifs_inval_name_dfs_link_error() as it
has same lifetime as of @tcon.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/misc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1364,6 +1364,7 @@ int cifs_inval_name_dfs_link_error(const
 		 * removing cached DFS targets that the client would eventually
 		 * need during failover.
 		 */
+		ses = CIFS_DFS_ROOT_SES(ses);
 		if (ses->server->ops->get_dfs_refer &&
 		    !ses->server->ops->get_dfs_refer(xid, ses, ref_path, &refs,
 						     &num_refs, cifs_sb->local_nls,


