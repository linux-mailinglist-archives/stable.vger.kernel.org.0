Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0B59DD6C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359383AbiHWMDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359781AbiHWMCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F609DABAB;
        Tue, 23 Aug 2022 02:36:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EBF61227;
        Tue, 23 Aug 2022 09:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153B9C433C1;
        Tue, 23 Aug 2022 09:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247364;
        bh=+BJTvkYDRr0aE4L6o5TNcyJvj52o/Lx/16ryarOswAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYSbxLTIzJcmF12Yj4n1ztrk+QNHmcwwpu+hYlEtak1jgvSQXFOiD9gnDevoUq4GH
         ifiowpalIaprs+vQ4qB36p0boea+YP5ZtJ1ZEt0fwrxvY4fvdGLldcMu/6VqL1uLWx
         8ewtmXUGzBErdwsZrHfS+a0LUxB2xk7JwlRIegJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.10 013/158] apparmor: fix quiet_denied for file rules
Date:   Tue, 23 Aug 2022 10:25:45 +0200
Message-Id: <20220823080046.609588201@linuxfoundation.org>
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

commit 68ff8540cc9e4ab557065b3f635c1ff4c96e1f1c upstream.

Global quieting of denied AppArmor generated file events is not
handled correctly. Unfortunately the is checking if quieting of all
audit events is set instead of just denied events.

Fixes: 67012e8209df ("AppArmor: basic auditing infrastructure.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -137,7 +137,7 @@ int aa_audit(int type, struct aa_profile
 	}
 	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
 	    (type == AUDIT_APPARMOR_DENIED &&
-	     AUDIT_MODE(profile) == AUDIT_QUIET))
+	     AUDIT_MODE(profile) == AUDIT_QUIET_DENIED))
 		return aad(sa)->error;
 
 	if (KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)


