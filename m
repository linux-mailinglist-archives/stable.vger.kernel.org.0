Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3D759D82F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiHWJj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351738AbiHWJjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3F767C99;
        Tue, 23 Aug 2022 01:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 726F561377;
        Tue, 23 Aug 2022 08:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEE9C433C1;
        Tue, 23 Aug 2022 08:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244055;
        bh=pq5jl0liAQqHiKcuVEOGf6QiN0IET6PLiMh34kv50FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbQL12jcmwr1l1K+HjSQNurCfeAo0HxKnY2hTqkxYKFJbt7LOeKZrDMxg99fYb59S
         7eJPUNSNP3whBuBrXg8HXZMCJrPthfX+iZY8cjpX/GKZ9AStlWne8xJzKAkgcqx8rA
         Yk8BIH32OWKMT4gbBU2dJAMv5pnbr4pd+VxmkOck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 030/244] apparmor: Fix failed mount permission check error message
Date:   Tue, 23 Aug 2022 10:23:09 +0200
Message-Id: <20220823080100.062673324@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Johansen <john.johansen@canonical.com>

commit ec240b5905bbb09a03dccffee03062cf39e38dc2 upstream.

When the mount check fails due to a permission check failure instead
of explicitly at one of the subcomponent checks, AppArmor is reporting
a failure in the flags match. However this is not true and AppArmor
can not attribute the error at this point to any particular component,
and should only indicate the mount failed due to missing permissions.

Fixes: 2ea3ffb7782a ("apparmor: add mount mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/mount.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -229,7 +229,8 @@ static const char * const mnt_info_table
 	"failed srcname match",
 	"failed type match",
 	"failed flags match",
-	"failed data match"
+	"failed data match",
+	"failed perms check"
 };
 
 /*
@@ -284,8 +285,8 @@ static int do_match_mnt(struct aa_dfa *d
 			return 0;
 	}
 
-	/* failed at end of flags match */
-	return 4;
+	/* failed at perms check, don't confuse with flags match */
+	return 6;
 }
 
 


