Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD5960A5B5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbiJXM2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiJXM2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:28:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DD513EBA;
        Mon, 24 Oct 2022 05:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6243B811A5;
        Mon, 24 Oct 2022 11:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03728C433D6;
        Mon, 24 Oct 2022 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612656;
        bh=TaOMZ641qK5g+ToI/uLs8Ny1TZ131P0sMACZ7/5HZuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVyYn3gabMWebxyhSToh6n4xjm3vcq00/nmsI+gw2jghGDs/tcu7n/klRXis+jc7Y
         W3oNVMO3qhBqPlD+AfGoNnOitALfas3sS/PZSfoYz4/IZaGS4xOPj7xlM2yFSioR6x
         HmkWsgeNTGuMh90G/A/7tOWVnr0we55KvXxVNUEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org
Subject: [PATCH 4.19 069/229] selinux: use "grep -E" instead of "egrep"
Date:   Mon, 24 Oct 2022 13:29:48 +0200
Message-Id: <20221024113001.309912679@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
@@ -57,7 +57,7 @@ fi
 cd /etc/selinux/dummy/contexts/files
 $SF file_contexts /
 
-mounts=`cat /proc/$$/mounts | egrep "ext2|ext3|xfs|jfs|ext4|ext4dev|gfs2" | awk '{ print $2 '}`
+mounts=`cat /proc/$$/mounts | grep -E "ext2|ext3|xfs|jfs|ext4|ext4dev|gfs2" | awk '{ print $2 '}`
 $SF file_contexts $mounts
 
 


