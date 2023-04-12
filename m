Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D396DEF3C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjDLItN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjDLItE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96A28A57
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1991E63120
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B58BC433D2;
        Wed, 12 Apr 2023 08:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289295;
        bh=abvIVO8JZE1KQoOhnBdFY1iuqX31JVgVIX5XwR0k6ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUiVMmEWE3WoM9xs6B2rK7ee1VFrFsCpTqVX7Ds5Tqel3TQ+6yQ769dTvjWFlQhto
         gVAwxTkCUbjFYuJZoY+/O5nFPUBmx1BDOq9I7UAGU33VS657dfRykYPtSVnvc5Bv4A
         6mPIczc5AEWvGI59fsun06X+6QWzDHix7lVLhh74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dai Ngo <dai.ngo@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 044/173] NFSD: callback request does not use correct credential for AUTH_SYS
Date:   Wed, 12 Apr 2023 10:32:50 +0200
Message-Id: <20230412082839.893123785@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 7de82c2f36fb26aa78440bbf0efcf360b691d98b ]

Currently callback request does not use the credential specified in
CREATE_SESSION if the security flavor for the back channel is AUTH_SYS.

Problem was discovered by pynfs 4.1 DELEG5 and DELEG7 test with error:
DELEG5   st_delegation.testCBSecParms     : FAILURE
           expected callback with uid, gid == 17, 19, got 0, 0

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: 8276c902bbe9 ("SUNRPC: remove uid and gid from struct auth_cred")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 2a815f5a52c4b..4039ffcf90ba5 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -946,8 +946,8 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
 		if (!kcred)
 			return NULL;
 
-		kcred->uid = ses->se_cb_sec.uid;
-		kcred->gid = ses->se_cb_sec.gid;
+		kcred->fsuid = ses->se_cb_sec.uid;
+		kcred->fsgid = ses->se_cb_sec.gid;
 		return kcred;
 	}
 }
-- 
2.39.2



