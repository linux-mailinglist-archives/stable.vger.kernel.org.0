Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C067F59DA4F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239747AbiHWKHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352622AbiHWKF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:05:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419C97171C;
        Tue, 23 Aug 2022 01:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E478611DD;
        Tue, 23 Aug 2022 08:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804EFC433C1;
        Tue, 23 Aug 2022 08:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244734;
        bh=j8glXLaB887gBfr17FRE16vXIkJMGlKP3T3etGltaow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1lNCSg7S1h2dg2TnTjSwL2vTbltGikzDzuAlyw+2rsrUjoxFBU0P80c3Km+1Lr2v
         DsWSqQ8GUM9alkanKq/YGnJqYQiWpkb9pIX6Ja9lhR4wD3DJGl1fTt6/cQMR5DvujR
         z0GBXim9U/WbQUUp6y/oGwU1BqVOskUcE5WtmogM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.14 182/229] apparmor: Fix failed mount permission check error message
Date:   Tue, 23 Aug 2022 10:25:43 +0200
Message-Id: <20220823080100.111525150@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
@@ -233,7 +233,8 @@ static const char * const mnt_info_table
 	"failed srcname match",
 	"failed type match",
 	"failed flags match",
-	"failed data match"
+	"failed data match",
+	"failed perms check"
 };
 
 /*
@@ -288,8 +289,8 @@ static int do_match_mnt(struct aa_dfa *d
 			return 0;
 	}
 
-	/* failed at end of flags match */
-	return 4;
+	/* failed at perms check, don't confuse with flags match */
+	return 6;
 }
 
 


