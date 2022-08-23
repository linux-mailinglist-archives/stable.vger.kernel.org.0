Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9259E117
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359186AbiHWMDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359539AbiHWMBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:01:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A87822F;
        Tue, 23 Aug 2022 02:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33983CE1B58;
        Tue, 23 Aug 2022 09:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3141AC433C1;
        Tue, 23 Aug 2022 09:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247370;
        bh=pq5jl0liAQqHiKcuVEOGf6QiN0IET6PLiMh34kv50FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaW7NTjEg5xAyawa+YVZ8zJ0mGk9tDsk9OYgTIOqk8QX+ajS0Lq5K9icvodqYpdcV
         sTGy7gngx9Fdm7JzryLg+57W2mxCRaBhYa9RZ30I5Y1qrjKTYD4XJ/7JoNe2pWlvjx
         FATc8/KkeytlkvD1PFmX7cfA7XAMlD7s6uBpLTNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.10 015/158] apparmor: Fix failed mount permission check error message
Date:   Tue, 23 Aug 2022 10:25:47 +0200
Message-Id: <20220823080046.680873844@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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
 
 


