Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCCF60A72D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiJXMsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiJXMox (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588F426E9;
        Mon, 24 Oct 2022 05:09:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED84612BC;
        Mon, 24 Oct 2022 12:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCB3C433C1;
        Mon, 24 Oct 2022 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613274;
        bh=QOgwnGXtJ5WnEebGLcaB/JmKLZooNWI4me6Yyig3MGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+fkqKfqeBTuIiYaO419A0VL/7ptoBjCeEN3b/zaZAMaPZmkk1yca6C7ixzqLsUXX
         L0Dtd8BqKCkjBqkjMoF0MQMniyv+8infDquMkezVaCSMInY+vXgg1y86lFqSOsIYSm
         bq3llWmkc13DukUpBwAEPDk3HHtxZZPDXGmWlIRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org
Subject: [PATCH 5.4 057/255] selinux: use "grep -E" instead of "egrep"
Date:   Mon, 24 Oct 2022 13:29:27 +0200
Message-Id: <20221024113004.394129391@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c969bb8dbaf2f3628927eae73e7c579a74cf1b6e upstream.

The latest version of grep claims that egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this by using "grep -E" instead.

Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: selinux@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[PM: tweak to remove vdso reference, cleanup subj line]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/selinux/install_policy.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/selinux/install_policy.sh
+++ b/scripts/selinux/install_policy.sh
@@ -78,7 +78,7 @@ cd /etc/selinux/dummy/contexts/files
 $SF -F file_contexts /
 
 mounts=`cat /proc/$$/mounts | \
-	egrep "ext[234]|jfs|xfs|reiserfs|jffs2|gfs2|btrfs|f2fs|ocfs2" | \
+	grep -E "ext[234]|jfs|xfs|reiserfs|jffs2|gfs2|btrfs|f2fs|ocfs2" | \
 	awk '{ print $2 '}`
 $SF -F file_contexts $mounts
 


