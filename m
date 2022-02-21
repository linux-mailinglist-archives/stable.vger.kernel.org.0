Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BE64BE62C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350505AbiBUJfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:35:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350686AbiBUJeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:34:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1929C2AE30;
        Mon, 21 Feb 2022 01:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 486FD60B1E;
        Mon, 21 Feb 2022 09:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B34AC340E9;
        Mon, 21 Feb 2022 09:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434848;
        bh=BG1NpXKssJw3yavqv33fIVlY8+0FkZSDOgF69ULv2oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZjXzs5LNQ6vdJL+0Ur1TQ4Y63e+TUM255Vi0XyxMh09LgxuPP9U56pdinttuk2z1
         DD5oCHSxH7YcLgetew+CULR367n/C59+xAONycTl3io1Z9CU8dv96kZkNeuwqrqAOH
         84Bk549kOXhCoLYcZ/olEicUVYU04NcebsWsbXys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 120/196] cifs: fix set of group SID via NTSD xattrs
Date:   Mon, 21 Feb 2022 09:49:12 +0100
Message-Id: <20220221084934.949460961@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Amir Goldstein <amir73il@gmail.com>

commit dd5a927e411836eaef44eb9b00fece615e82e242 upstream.

'setcifsacl -g <SID>' silently fails to set the group SID on server.

Actually, the bug existed since commit 438471b67963 ("CIFS: Add support
for setting owner info, dos attributes, and create time"), but this fix
will not apply cleanly to kernel versions <= v5.10.

Fixes: 3970acf7ddb9 ("SMB3: Add support for getting and setting SACLs")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/xattr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -175,11 +175,13 @@ static int cifs_xattr_set(const struct x
 				switch (handler->flags) {
 				case XATTR_CIFS_NTSD_FULL:
 					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL |
 						    CIFS_ACL_SACL);
 					break;
 				case XATTR_CIFS_NTSD:
 					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL);
 					break;
 				case XATTR_CIFS_ACL:


